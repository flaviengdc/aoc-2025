module Part2

using JuMP, HiGHS

using Aoc10: Problem

function transform_buttons(buttons::Vector{Vector{Int64}}, len::Int64)::Matrix{Int8}
  btns::Vector{Vector{Int8}} = []
  for btn in buttons
    arr = fill(0, len)
    for i in btn
      arr[i+1] += 1
    end
    push!(btns, arr)
  end
  stack(btns) |> transpose
end

function solve_problem(problem::Problem)::Int64
  btns = transform_buttons(problem.buttons, length(problem.target2))
  n = length(btns[:, 1])

  model = Model(HiGHS.Optimizer)
  set_silent(model)

  @variable(model, xs[1:n] >= 0, Int)
  @objective(model, Min, sum(xs))
  @constraint(model, c1, problem.target2 == sum(eachrow(btns .* xs)))

  optimize!(model)
  objective_value(model) |> round
end

solve(problems::Vector{Problem}) = sum(solve_problem.(problems))

end
