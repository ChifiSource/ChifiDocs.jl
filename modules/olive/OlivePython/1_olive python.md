## installing olive python
`OlivePython` is an [Olive](https://github.com/ChifiSource/Olive.jl) extension that provides `Olive` with a `:python` *session* cell, a `:py` *file* cell, and the ability to export notebooks as `Python` code. In order to add `OlivePython` to your `Olive` environment,
- 1. The *home* directory in the **project explorer** (the pink one) holds a small `+` button. Clicking this button will append a textbox, from this textbox with can simply type `OlivePython` and this will automatically add `OlivePython` and import it into your `olive` module.
- 2. Manually, we could activate `olive` (either through `Olive` or in the REPL,) and then add `OlivePython` to its environment. With `OlivePython` added, we finish by editing `olive/src/olive.jl` and adding a new `using OlivePython` line.
- 3. If using `Olive` `0.1.3` +, we could also add `OlivePython`, use `OlivePython`, and then run an `Olive` server with `headless = true` provided to `start`.

Once we have `OlivePython` installed into our `Olive`, we should immediately be able to add python cells, open `.py` files, and edit the color scheme of the syntax highlighting! Python evaluation isn't perfect, and depends heavily on `PyCall`'s ability to parse whatever code is provided. Keep this in mind!
## internals
`OlivePython` provides new parametric method bindings for the following `Olive` functions:
```julia
# cells
build(c::Connection, cm::ComponentModifier, cell::Cell{:python}, proj::Project{<:Any})
evaluate(c::Connection, cm::ComponentModifier, cell::Cell{:python}, proj::Project{<:Any})
get_highlighter(c::Connection, cell::Cell{:python})
cell_highlight!(c::Connection, cm::ComponentModifier, cell::Cell{:python}, proj::Project{<:Any})
string(c::Cell{:python})

build(c::Connection, om::OliveModifier, oe::OliveExtension{:python})

# highlighting
mark_python!(tm::OliveHighlighters.TextStyleModifier)
highlight_python!(tm::OliveHighlighters.TextStyleModifier)

# files
read_py(uri::String)
build(c::Connection, cell::Cell{:py},
    d::Directory{<:Any})
olive_read(cell::Cell{:py})
olive_save(p::Project{<:Any}, 
    pe::ProjectExport{:py})

```
Given this is an `Olive` extension, most of the functionality is provided via these additional dispatches, and hopefully merely observing these dispatches is enough to portray a basic idea of how this all works. `OlivePython` only provides the following two functions:
- `py_string`
- `read_py`


