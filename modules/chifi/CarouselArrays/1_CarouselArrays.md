## carousel arrays?
A `CarouselArray` is an *Array* type that allows for **infinite, repeat-indexing**. The `CarouselArray` acts as a custom-indexing wrapper for the `Base` `Array`. When indexed above its length, a `CarouselArray` will return the count from the first element of the `Array`. For example, in the case of `[1, 2, 3, 4, 5]`, indexing `6` will give us `1`.
```julia
my_array = CarouselArray([1, 2, 3, 4, 5])

my_array[6] == 1
```
Indexing `7` would give us `2`, and indexing `0` would give us `5`. The arrays repeat their few indices to an infinite level. Creating a `CarouselArray` is as straightforward as creating a regular `Vector` in Julia. This package is pretty minimalist, and only includes the `CarouselArray` and its indexing functions. Though they are called arrays, they are more similar to vectors.
- `setindex!(ca::CarouselArray{<:Any}, v::Any, i::Int64)`
- and `getindex(ca::CarouselArray{<:Any}, i::Int64)`
