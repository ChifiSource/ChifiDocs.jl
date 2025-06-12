`chiheader`
```html
<div align="center">
    <h3>chifi docs</h3>
</div>
```
#### links
`chifi-links`

`chifi` is an open-source software organization dedicated to developing data-driven web-development and data-science tools for the Julia programming language. This consists of **chifi websites** (`CC BY 4.0`/`MIT-0`), **chifi servers** (`MIT-0`), **chifi modules** (`MIT-0`) and **notebooks** (`MIT-0`).

We are currently targeting the creation of **6** *powerful* ecosystems for Julia. Each ecosystem includes a base package and a suite of extensions to further the capabilities of said package.
- `chifi-tag`
- `parametric-tag`
- `toolips-tag`
- `gattino-tag`
- `olive-tag`
- `algebraframes-tag`
- `tumble-tag`
---
## explore
`ChifiDocsgalaxy`

## documentation feature overview
`ChifiDocs` is a `Documator`-based documentation website (you are currently viewing) built using the `Toolips` web-development framework. Throughout these documentation pages, small snippets will be highlighted blue, like `this`. These are interpolated doc-strings, clicking them will yield a pop-up with more information about that value. We can also freely interpolate images,
multimedia, and components as we have seen thus far in this document. For example, this element : `toolips-tag` , is added 
directly to this markdown using interpolation.

Additionally, there are language interpolaters for syntax highlighting and custom-block creation. As of right now, this mainly 
facilitates Julia itself. As the need becomes more realized, this will eventually be expanded to support more code-block types.
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
For each documentation page, there is an automatically generated *reference*. If there are extra examples to go along with the overview, these are added to *examples*. Several interactive and unique features and showcases are available thanks to this `Component` interpolation system.



