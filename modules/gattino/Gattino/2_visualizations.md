## contexts
Visualizations in `Gattino` are created through the `Context` type, a sub-type of `AbstractContext`. The `Context` acts as a **scaling wrapper** for the `Component{:svg}`. When written through the `Context`, the components are meant to be scaled to the correct size of the current context. The `Context` stores the SVG window, `Component{:svg}`, as `window` and `dim`/`margin` two `Int64` pairs that represent the current dimensions and margins we are drawing from. These are easily constructed through the `context` function. Here is a full list of (non-plotting) functions to be used with the `context!`.
- `layers`
- `style!`
- `open_layer!`
- `set_shape!`
- `move_layer!`
- `rename_layer!`
- `delete_layer!`
- `merge!`
- `draw!`
- `vcat`
- and `hcat`.
## layers

