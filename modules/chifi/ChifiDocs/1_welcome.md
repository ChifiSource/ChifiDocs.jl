```img
100|center|/ecosystems/images/olivesquare.png
```
```html
<div align="center">
    <h3>chifi docs</h3>
</div>
```
#### links
`chifi-links`

`chifi` is a organization dedicated to developing data-driven web-devlepment and data-science tools for the Julia programming language. This consists of **chifi websites** (`CC BY 4.0`/`MIT-0`), **chifi servers** (`MIT-0`), **chifi modules** (`MIT-0`) and **random, out-of-ecosystem** packages (`MIT-0`). 
We are currently targeting the creation of **6** powerful ecosystems for Julia. Each ecosystem includes a base package and several extensions to further radicalize the capabilities of that base package. 
- `chifi-tag`
- `parametric-tag`
- `toolips-tag`
- `gattino-tag`
- `olive-tag`
- `algebraframes-tag`
- `tumble-tag`
## documentation feature overview
`ChifiDocs` is a `Documator`-based documentation website (you are currently viewing) built using the `Toolips` web-development framework. Any doc-string can be interpolated into a pop-up button that looks like `this`. We can also add any component we want, images, and more. We can also highlight a variety of different syntax, including above all Julia:
```julia
mutable struct Example{T <: Int64}
    e::Int64
    n::String
    function Example(name::String = "john")
        for x in 1:e
            println(x)
        end
        new{Int64}(1, name)::Example{Int64}
    end
end
```
