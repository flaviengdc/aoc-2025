import Base: ==

struct Problem
  target1::BitVector
  target2::Vector{Int64}
  buttons::Vector{Vector{Int64}}
end

function ==(a::Problem, b::Problem)::Bool
  a.target1 == b.target1 && a.target2 == b.target2 && a.buttons == b.buttons
end
