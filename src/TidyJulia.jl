module TidyJulia
cd("C:/Users/francis.smart.ctr/GitDir/SoftDatesJL/TidyJulia")
using Pkg
Pkg.activate(".")

greet() = print("Ok, very much in alpha testing mode. Still need to figure out how to organize package.")

import DataFrames
import Random
using  StatsBase

# Generate some sample data
df = DataFrame(a = sample(1:10, 1000), b = sample(1:10, 1000), c = sample(1:10, 1000))

apply(fun::Function) = x->fun(x)
  df |> apply(x -> x[:a] .^ x[:b])

rowapply(fun::Function) = (x->[fun(x[i,:]) for i in 1:size(x)[1]])
  df |> rowapply(x -> x[:a] ^ x[:b] - x[:c])

rowfilter(fun::Function) = x->x[rowapply(fun)(x),:]
  df |> rowfilter(x->x[:a] == x[:b]*x[:c])

function mutate(newvar::Symbol, fun::Function)
  function λ(x)
   x[newvar] = [fun(x[i,:]) for i in 1:size(x)[1]]
   x
  end
end
df |> mutate(:a, x -> x[:a] ^ x[:b] - x[:c])



# Create some filter functions by operation =, >, <
filterequal(lookup::Symbol, equals::Number) = (x->x[x[lookup] .== equals, :])
filterequal(lookup::Symbol, equals::Symbol) = (x->x[x[lookup] .== x[equals], :])
  df |> filterequal(:a,5)
  df |> filterequal(:a,:b)

filtergt(lookup::Symbol, gt::Number) = (x->x[x[lookup] .> gt, :])
filtergt(lookup::Symbol, gt::Symbol) = (x->x[x[lookup] .> x[gt], :])
  df |> filtergt(:a,5) |> filtergt(:b,5)
  df |> filtergt(:a,:b)|> filtergt(:a,:c)

filterlt(lookup::Symbol, lt::Number) = (x->x[x[lookup] .< lt, :])
filterlt(lookup::Symbol, lt::Symbol) = filtergt(lt, lookup)
  df |> filterlt(:a,5) |> filterlt(:b,5)
  df |> filterlt(:a,:b)|> filterlt(:a,:c)

filtergte(lookup::Symbol, gt::Number) = (x->x[x[lookup] .>= gt, :])
filtergte(lookup::Symbol, gt::Symbol) = (x->x[x[lookup] .>= x[gt], :])
  df |> filtergte(:a,5) |> filtergt(:b,5)
  df |> filtergte(:a,:b)|> filtergt(:a,:c)

filterlte(lookup::Symbol, lt::Number) = (x->x[x[lookup] .<= lt, :])
filterlte(lookup::Symbol, lt::Symbol) = filtergte(lt, lookup)
  df |> filterlte(:a,5) |> filterlte(:b,5)
  df |> filterlte(:a,:b)|> filterlte(:a,:c)

filterne(lookup::Symbol, equals::Number) = (x->x[x[lookup] .!= equals, :])
filterne(lookup::Symbol, equals::Symbol) = (x->x[x[lookup] .!= x[equals], :])
  df |> filterne(:a,5) |> filterne(:b,5)
  df |> filterne(:a,:b)|> filterne(:a,:c)


end # module
