module Aoc10

include("Problem.jl")
include("Parsing.jl")
include("Part1.jl")
include("Part2.jl")

function get_problems()::Vector{Problem}
  filename = "example.txt"

  lines = readlines(filename)
  parse.(Problem, lines)
end

function main()
  problems = get_problems()

  solution1 = Part1.solve(problems)
  println("Part 1: $solution1")

  solution2 = Part2.solve(problems)
  println("Part 2: $solution2")
end

end
