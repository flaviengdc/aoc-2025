import Data.Ix (inRange)
import Data.List (sortOn)
import Text.ParserCombinators.Parsec

main :: IO ()
main = do
  contents <- readFile "example.txt"
  let (ranges, ingredients) = readData contents

  let result1 = countFreshIngredients ranges ingredients
  print result1

  let result2 = countAllRanges $ dedupe $ sortByFst ranges
  print result2

type Range = (Int, Int)

-- Part 1

countFreshIngredients :: [Range] -> [Int] -> Int
countFreshIngredients ranges ingredients =
  let pred = inAnyRange ranges
  in countBy pred ingredients

countBy :: (a -> Bool) -> [a] -> Int
countBy pred = length . filter pred

inAnyRange :: [Range] -> Int -> Bool
inAnyRange ranges n = any (`inRange` n) ranges

-- Part 2

sortByFst :: [Range] -> [Range]
sortByFst = sortOn fst

countAllRanges :: [Range] -> Int
countAllRanges = sum . map countRange

countRange :: Range -> Int
countRange (a, z) = z - a + 1

dedupe :: [Range] -> [Range]
dedupe (x:y:xs) = case dedupeTwo x y of
  [a, b] -> a:dedupe (b:xs)
  [a]    -> dedupe (a:xs)
  []     -> dedupe xs
dedupe xs = xs

dedupeTwo :: Range -> Range -> [Range]
dedupeTwo a b
  | a == b         = [a]
  | snd a < fst b  = [a, b]
  | snd a >= snd b = [a]
  | otherwise      = [(fst a, snd b)]

-- Parsing

readData :: String -> ([Range], [Int])
readData str =
  case (parse parseFile "" str) of
    Left err -> error $ show err
    Right x  -> x

parseFile :: Parser ([Range], [Int])
parseFile = do
  ranges <- parseRanges
  _ <- newline
  ingredients <- parseIngredientIds
  return (ranges, ingredients)

parseRange :: Parser Range
parseRange = do
  a <- many1 digit
  _ <- char '-'
  z <- many1 digit
  return (read a, read z)

parseRanges :: Parser [Range]
parseRanges = sepEndBy1 parseRange newline

parseIngredientIds :: Parser [Int]
parseIngredientIds = sepEndBy1 (read <$> many1 digit) newline
