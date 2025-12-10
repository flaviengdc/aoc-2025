def is_digit = (< 10u8)
def to_digit x = (x - '0' : u8)

-- ==
-- entry: to_digits
-- input { "1234567890" }
-- output { [1u8, 2u8, 3u8, 4u8, 5u8, 6u8, 7u8, 8u8, 9u8, 0u8] }
entry to_digits = map to_digit

-- Part 1

-- ==
-- entry: first_digit_mask
-- input { [1u8, 0u8, 9u8, 105u8, 5u8, 6u8] }
-- output { [true, false, false, false, true, false] }
entry first_digit_mask [n] (digits: [n]u8) =
  loop empty_mask = replicate n false
  for i < n do
    empty_mask with [i] = i == 0 || !(is_digit digits[i - 1])

-- ==
-- entry: parse_number_line
-- input { "12 3542 10002770" }
-- output { [12u64, 3542u64, 10002770u64] }
-- input { "  12    3542   10002770 \t  " }
-- output { [12u64, 3542u64, 10002770u64] }
entry parse_number_line [n] (s: [n]u8) =
  let digits = to_digits s
  let mask = first_digit_mask digits
  let accs: [n]i32 = replicate n 0
  let empty_tuples: [](u64, bool, i32) =
    zip3 (map u64.u8 digits) mask accs
    |> filter (\(d, _, _) -> is_digit (u8.u64 d))
  let accumulated_tuples =
    scan (\(prev_result, was_first_digit, power) (digit, is_first_digit, _) ->
            let current_value: u64 = (digit * u64.i32 power)
            let accumulated_result: u64 = prev_result + current_value
            let a: u64 = if was_first_digit then current_value else accumulated_result
            let b: bool = is_first_digit
            let c: i32 = if is_first_digit then 1i32 else (power * 10)
            in (a, b, c))
         (0u64, false, 1i32)
         (reverse empty_tuples)
  let numbers = accumulated_tuples |> filter (\(_, is_first_digit, _) -> is_first_digit)
  let result = unzip3 numbers
  in reverse result.0

def is_op (c: u8) = (c == '+' || c == '*')

def get_first_op_index [n] (cs: [n]u8) : i64 =
  let is = indices cs
  let ops_is: []i64 =
    (zip cs is)
    |> filter ((.0) >-> is_op)
    |> map (.1)
  in head ops_is

def split_parts [n] (cs: [n]u8) : {numbers: []u8, ops: []u8} =
  let i = get_first_op_index cs
  in {numbers = cs[0:i], ops = cs[i:n]}

def parse_ops = filter is_op

def parse_all_numbers (cs: []u8) =
  let xs: []u64 = parse_number_line cs
  let nb_lines = filter (== '\n') cs
  let n = length nb_lines
  let m = length xs / n
  in unflatten (xs :> [n * m]u64)

def parse_everything (cs: []u8) =
  let {numbers, ops} = split_parts cs
  let numbers = parse_all_numbers numbers
  let ops = parse_ops ops
  in {numbers, ops}

def solve_problem (xs: []u64, op: u8) : u64 =
  if op == '*'
  then reduce (*) 1 xs
  else reduce (+) 0 xs

-- ==
-- entry: part1
-- input @ example.txt.in output { 4277556u64 }
entry part1 (cs: []u8) =
  let {numbers, ops} = parse_everything cs
  let ns = transpose numbers
  let clean_ops = scatter (rep '+') (indices ops) ops
  let ns_and_ops = zip ns clean_ops
  let problems: []u64 = map solve_problem ns_and_ops
  in reduce (+) 0 problems

-- Part 2

def chars_to_matrix (cs: []u8) : [][]u8 =
  let nb_lines = filter (== '\n') cs
  let n = length nb_lines
  let m = length cs / n
  in unflatten (cs :> [n * m]u8)
     |> map init
     |> transpose
     |> map to_digits

def from_reversed_digits [n] (reversed_digits: [n]u8) : u64 =
  let magnitudes =
    indices reversed_digits
    |> map (10 **)
    |> map u64.i64
  let components = map2 (*) (map u64.u8 reversed_digits) magnitudes
  in reduce (+) 0 components

def from_digits [n] (digits: [n]u8) : u64 = reverse digits |> from_reversed_digits

type option 't = #some t | #none

def parse_vertical_digits (xs: []u8) : option u64 =
  if any is_digit xs
  then let ds = filter is_digit xs |> from_digits
       in #some ds
  else #none

def parse_vertical_numbers (cs: []u8) =
  let digits = chars_to_matrix cs
  in map parse_vertical_digits digits

-- ==
-- entry: part2
-- input @ example.txt.in output { 3263827u64 }
entry part2 (cs: []u8) =
  let {numbers, ops} = split_parts cs
  let numbers: [](option u64) = parse_vertical_numbers numbers
  let clean_ops = scatter (rep ' ') (indices ops) ops
  let acc = (#none, ' ')
  let results: [](option u64, u8) =
    scan (\acc cur ->
            match acc.0
            case #none -> cur
            case #some m ->
              match cur.0
              case #none -> (#none, ' ')
              case #some n ->
                let result =
                  if acc.1 == '*'
                  then m * n
                  else m + n
                in (#some result, acc.1))
         acc
         (zip numbers clean_ops)
  let results_with_indices = zip (indices results) results
  let totals =
    filter (\(i, _) ->
              (i == length results - 1)
              || let prev = results[i + 1].0
                 in match prev
                    case #none -> true
                    case #some _ -> false)
           results_with_indices
  let total_numbers: []u64 =
    totals
    |> map (\(_, (n, _)) ->
              match n
              case #none -> 0
              case #some x -> x)
  in reduce (+) 0 (total_numbers)

entry main (cs: []u8) =
  let _ = trace (part1 cs)
  let _ = trace (part2 cs)
  in ()
