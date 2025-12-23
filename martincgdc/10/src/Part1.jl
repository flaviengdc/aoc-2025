module Part1

using Aoc10: Problem

function push_button(state::BitVector, btn::Vector{Int64})
  new_state = copy(state)
  for i in btn
    # The button indices are 0-indexed while Julia is 1-indexed
    new_state[i+1] ⊻= true
  end
  new_state
end

function solve_problem(problem::Problem)::Int64
  root::BitVector = fill(false, length(problem.target1))
  if (problem.target1 == root)
    return 0
  end

  # BFS
  queue = [(root, 0)]
  seen = Set{BitVector}([root])

  while !isempty(queue)
    state, depth = popfirst!(queue)

    for btn in problem.buttons
      new_state = push_button(state, btn)

      if (new_state in seen)
        continue
      end

      if (problem.target1 == new_state)
        return depth + 1
      end

      push!(seen, new_state)
      push!(queue, (new_state, depth + 1))
    end
  end
end

solve(problems::Vector{Problem}) = sum(solve_problem.(problems))

end
