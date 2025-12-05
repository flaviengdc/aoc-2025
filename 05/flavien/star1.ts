const [freshIngredientRanges, ingredients] =  (await Bun.file("input.txt").text()).split("\n\n")
const parsedRanges = freshIngredientRanges.split("\n").map(range => range.split("-").map(Number))
const parsedIngredients = ingredients.split("\n").map(Number)

console.log(parsedIngredients.reduce((acc, cur) => {
    return acc + (parsedRanges.some(([minRange, maxRange]) => minRange <= cur && cur <= maxRange) ? 1 : 0)
}, 0))