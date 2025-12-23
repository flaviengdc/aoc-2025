using Revise
using Aoc10

entr(["src", "test"]) do
  try
    include("test/runtests.jl")
  catch err
    showerror(stderr, err)
    println()
  end
end
