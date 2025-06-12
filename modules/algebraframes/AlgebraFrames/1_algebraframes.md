# algebra frames
- `AlgebraFrames` is officially released!

The `AlgebraFrames` package provides Julia with algebraic data-structures for managing *out-of-memory* data. This is facilitated through the `Algebra` and `AlgebraFrame`, computational representations of the `Base.Array` and `AlgebraFrames.Frame`. These computational representations can be live-indexed and feature a robust data-management API.
```julia
af = algebra(1000, "col1" => Int64,"col2" => Float64)

algebra!(af) do frame::Frame
    frame["col1", 1:5] = [5, 3, 4, 2, 1]
end

generated = generate(af)

col1 = af["col1"]
```
## creating algebra
We are able to create two *algebraic* types with *base* `AlgebraFrames`, the `Algebra` and the `AlgebraFrame`. The `Algebra` will be generated into a `Base.Array` and an 
`AlgebraFrame` will generate to a `Frame`. To create `Algebra`, we must provide a `Type` and a length.
```julia
# a vector of 10 integers
my_alg = algebra(Int64, 10)
```
In addition to length, we may provide a shape to create multi-dimensional `Algebra`.
```julia
my_alg = algebra(Int64, (5, 5))
```
As well as provide our own generator. By default, this will be a basic initializer for the `Type` of the `Algebra`.

Our new `Algebra`'s indexing mimmics the `Array`:
```julia
my_alg[1, 1]
my_alg[1]
my_alg[1:5, 1:2]
```
Creating an `AlgebraFrame` also utilizes the `algebra` function. This time, we start with the length of our data-frame and follow this by column name and type pairs.
```julia
af = algebra(25, "A" => Int64, "B" => String)
```
These may be indexed similarly, using axes and names.
```julia
af["A"]
af["A", 1:5]
```
As these are both sub-types of `AbstractAlgebra`, they have the following methods bound to them:
```julia
length(a::AbstractAlgebra)
size(a::AbstractAlgebra)
copy(alg::AbstractAlgebra)
reshape(alg::AbstractAlgebra, news::Tuple{Int64, Int64})
set_generator!(f::Function, alg::AbstractAlgebra)
getindex(alg::AbstractAlgebra, dim::Int64)
getindex(alg::AbstractAlgebra, dim::Int64, dim2::Int64)
getindex(alg::AbstractAlgebra, row::UnitRange{Int64}, col::UnitRange{Int64} = 1:1)
eachrow(alg::AbstractAlgebra)
eachcol(alg::AbstractAlgebra)
```
The `AlgebraFrame` is a sub-type of the `AbstractAlgebraFrame`, which also has a list of methods associated with it:
```julia
# methods for abstract algebra frames
copy(af::AbstractAlgebraFrame)
generate(af::AbstractAlgebraFrame)
names(af::AbstractAlgebraFrame)
size(af::AbstractAlgebraFrame)
length(af::AbstractAlgebraFrame)
algebra!(f::Function, af::AbstractAlgebraFrame, ...)
set_generator!(f::Function, af::AbstractAlgebraFrame, ...)
eachrow(af::AbstractAlgebraFrame)
framerows(af::AbstractAlgebraFrame)
eachcol(af::AbstractAlgebraFrame)
pairs(af::AbstractAlgebraFrame)
Dict(af::AbstractAlgebraFrame)
cast!(f::Function, af::AbstractAlgebraFrame, ...)
merge!(af::AbstractAlgebraFrame, af2::AbstractAlgebraFrame)
merge(af::AbstractAlgebraFrame, af2::AbstractAlgebraFrame)
join(af::AbstractAlgebraFrame, ...)
join!(af::AbstractAlgebraFrame, ...)
drop!(af::AbstractAlgebraFrame, ...)
deleteat!(af::AbstractAlgebraFrame, ...)
head(af::AbstractAlgebraFrame, headlength::Int64 = 5)
```
## transformations
The central premise of `AlgebraFrames` is the ability to dynamically stack mutations across unallocated data. This is accomplished through the `algebra` and `algebra!` functions. `algebra`, as demonstrated in the previous section, is used to create `Algebra` and `AlgebraFrames`. `algebra!` is used to mutate them. Within the `algebra!` calls, we are able to mutate our resulting `Vector` directly; it is passed as an argument to our provided `Function`.
```julia
# Algebra
alg = algebra(Int64, 16)

algebra!(alg) do vec::Vector{Int64}
    println(length(vec) == 16)
    vec[1] = 5
end

alg[1:3] # [5, 0, 0]
```
An `AlgebraFrame` holds column positions and **transformations**. Transformations are a sub-type of `AbstractTransformation`; the standard transformation provided with `AlgebraFrames` is the `Transform`. A `Transform` is applied whenever we call `algebra!` on our `AlgebraFrame`. This can be done on specific columns, or the entire `AlgebraFrame` itself. A `Frame` will be passed into the provided `Function`. The `Frame` works nearly identically to the `AlgebraFrame`, only with a few extra function bindings.
```julia
alg = algebra(10, "A" => String, "B" => String)

algebra!(alg) do frame::Frame
    frame["A", 1:3] = [8, 7, 6]
end

alg["A"][1:3] # [8, 7, 6]
```
The first transform in our `Algebra` or `AlgebraFrame` is called **the generator**. The generator creates the vector or array itself. We can change the generator as we please using `set_generator!`. For the `Algebra`, we provide this directly to the `Algebra` and our function can take a single argument or no arguments. If no arguments, we generate the entire array immediately. If there is one argument, the index of the value will be passed into the generator.The enumeration will **always** be provided on an `AlgebraFrame` column.
```julia
set_generator!(af, "A") do e
    e
end

set_generator!(alg) do e
    rand(1:5)
end

set_generator!(alg) do e
    [rand(1:5) for x in a.length]
end
```
`cast!` is used to quickly set a column's type on both an `AlgebraFrame` and a `Frame`.
## generation
There are several different ways to generate both the `Algebra` and the `AlgebraFrame`. `Algebra` is generally *indexed* or vectorized. Generally, the same is true for the `AlgebraFrame`, but we might also use `generate` to turn it into a `Frame` or use `framerows` to get its rows. Calling these generators is straightforward.
```julia
gen_vals = [alg]
frame = generate(af)
```
```julia
# Algebra (along with indexing)
vect(alg::AbstractAlgebra)
eachrow(alg::AbstractAlgebra)
eachcol(alg::AbstractAlgebra)
```
```julia
# AlgebraFrame (along with indexing)
names(af::AbstractAlgebraFrame)
generate(af::AbstractAlgebraFrame)
eachrow(af::AbstractAlgebraFrame)
eachcol(af::AbstractAlgebraFrame)
framerows(af::AbstractAlgebraFrame)
Dict(af::AbstractAlgebraFrame)
```
The `AlgebraFrame` generators may also be used as *accessors* for the `Frame`.

