module Parsing

using Aoc10: Problem

function parse_btn(btn::AbstractString)::Vector{Int64}
  strs = split(strip(btn, ['(', ')']), ",")
  parse.(Int64, strs)
end

function parse_target1(target::AbstractString)::BitVector
  [c == '#' for c in strip(target, ['[', ']'])]
end

function parse_target2(target::AbstractString)::Vector{Int64}
  strs = split(strip(target, ['{', '}']), ",")
  parse.(Int64, strs)
end

function Base.parse(::Type{Problem}, line::AbstractString)::Problem
  parts = split(line, " ")

  target1 = parse_target1(parts[1])
  buttons = parse_btn.(parts[2:(end-1)])
  target2 = parse_target2(parts[end])

  Problem(target1, target2, buttons)
end

end
