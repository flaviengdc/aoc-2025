using Test
using Aoc10: Problem, Parsing, Part1, Part2

@testset "parsing tests" begin
  @test Parsing.parse_target1("###..#") == Bool[1, 1, 1, 0, 0, 1]
  @test Parsing.parse_target2("{7,5,12,7,2}") == [7, 5, 12, 7, 2]
  @test Parsing.parse_btn("(0,1,2,4,5)") == [0, 1, 2, 4, 5]
  @test parse(
    Problem,
    "[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}",
  ) == Problem(
    Bool[0, 1, 1, 1, 0, 1],
    [10, 11, 11, 5, 10, 5],
    [[0, 1, 2, 3, 4], [0, 3, 4], [0, 1, 2, 4, 5], [1, 2]],
  )
end

@testset "part1 tests" begin
  example = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"""
  lines = eachline(IOBuffer(example))
  problems::Vector{Problem} = parse.(Problem, lines)

  @test Part1.solve(problems) == 7
end

@testset "part2 tests" begin
  example = """
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"""
  lines = eachline(IOBuffer(example))
  problems::Vector{Problem} = parse.(Problem, lines)

  @test Part2.solve(problems) == 33
end
