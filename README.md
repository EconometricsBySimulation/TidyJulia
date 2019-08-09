# TidyJulia
My attempt to implement some of TIDYR's features in the Julia programming and DataFrames packaging environment through the packaging of anonymous functions.

```julia
using DataFrames
using StatsBase

# Generate some sample data
df = DataFrame(a = sample(1:10, 1000), b = sample(1:10, 1000), c = sample(1:10, 1000))

apply(fun::Function) = x->fun(x)
  df |> apply(x -> x[:a] .^ x[:b])
```
#### rowapply - applies a function explicitly matched row arguments
```
rowapply(fun::Function) = (x->[fun(x[i,:]) for i in 1:size(x)[1]])
  df |> rowapply(x -> x[:a] ^ x[:b] - x[:c])
```
#### rowfilter - filters the data based on function value
```
rowfilter(fun::Function) = x->x[rowapply(fun)(x),:]
  df |> rowfilter(x->x[:a] == x[:b]*x[:c])
```
#### mutate - creates new columns or modifies existing columns
```
function mutate(newvar::Symbol, fun::Function)
  function λ(x)
   x[newvar] = [fun(x[i,:]) for i in 1:size(x)[1]]
   x
  end
end
df |> mutate(:a, x -> x[:a] ^ x[:b] - x[:c]) 
```

But my efforts are not nearly as effective or complete as those developed for the DataFramesMeta package.

[DataFramesMeta.jl](https://github.com/JuliaData/DataFramesMeta.jl)
