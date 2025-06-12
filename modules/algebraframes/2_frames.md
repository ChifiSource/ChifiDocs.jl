## api overview
Alongside the ability to apply transformation stacks atop out of memory column data, `AlgebraFrames` also provides a simple data-management interface. This interface is created for both the `Frame` and the `AlgebraFrame`. The bindings remain identical between the two, though some bindings are `Frame` *exclusive*, such as `replace!`.
```julia
# algebraframe only
join!(af::AbstractAlgebraFrame, col::Pair{String, DataType}; axis::Any = length(af.names))
# frame and algebraframe (replace algebraframe and frame are interchangeable below)
join!(af::AbstractAlgebraFrame, af2::AbstractAlgebraFrame; axis::Any = length(af.names))
join(af::AbstractAlgebraFrame, af2::AbstractAlgebraFrame; axis::Any = length(af.names))
merge(af::AbstractAlgebraFrame, af2::AbstractAlgebraFrame)
merge!(af::AbstractAlgebraFrame, af2::AbstractAlgebraFrame)
drop!(f::AbstractFrame, col::Int64)
drop!(f::AbstractFrame, col::AbstractString)
deleteat!(f::AbstractFrame, observations::UnitRange{Int64})
deleteat!(f::AbstractFrame, observation::Int64)
cast!(f::Function, af::AbstractAlgebraFrame, col::Int64, to::Type)
# frame only
filter!(f::Function, af::AbstractDataFrame)
replace!(af::AbstractDataFrame, value::Any, with::Any)
cast!(af::AbstractDataFrame, col::Int64, to::Type)
```
- (this portion of the documentation will soon be treated a bit better)

