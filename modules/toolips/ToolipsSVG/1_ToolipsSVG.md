`svgheader`
## contents
`ToolipsSVG` is a *minimalist* framework for working with SVGs in the form of `ToolipsServables` `Components` with *some* extra extravagant features added on top. `ToolipsSVG` provides a few useful functions for creating and mutating SVG shapes and canvases in Julia using `Components`.
## components
Above all, `ToolipsSVG` provides a few extra `Component` constants *specifically* for working with SVG elements. Here is a full list (click to view documentation):
- `text`
- `path`
- `image`
- `circle`
- `rect`
- `line`
- `ellipse`
- `polygon`
- `polyline`
- `use`
- `g`
- `svg`
- `div`

With two *special* shape components:
- `star`
- `polyshape`

## functions
`ToolipsSVG` also establishes a consistent `size`/`set_size!` and `position`/`set_position!` with multiple dispatch that will work with any `Component`. This makes it easier to size both a circle and a square using the same generic function call, for example. There is also `get_shape` and `set_shape` for changing the shape of SVG elements. Here is a full list of functions for this purpose:

- `size(::Component{<:Any})`
- `set_size!`
- `get_position`
- `set_position!`
- `get_shape`
- `set_shape`

Finally, there is also a simple API for editing paths through convenient `Function` macros, these functions will all be called directly on a `Component{:path}`:
- `M!`
- `L!`
- `Z!`
- `Q!`
- `C!`
- `A!`


