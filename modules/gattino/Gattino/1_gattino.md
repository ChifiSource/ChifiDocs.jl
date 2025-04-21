`gattino-scatter`
## what is gattino?
`Gattino` is a **modular** visualization library built (primarily) to provide [Toolips](/toolips) servers with data visualization using the [ToolipsServables](/toolips/ToolipsServables) and [ToolipsSVG](/toolips/ToolipsSVG) packages, though the library is versatile and could easily be used for other purposes. `Gattino` also exibits the same modular design philosophy of all `chifi` packages, and comes with its own [gattino](/gattino) ecosystem. `Gattino`, without extensions, offers:
- `Toolips` compatibility
- An extension ecosystem
- Composable and features data-visualization
- Mutable plotting
- and powerful layout syntax

```julia
using Pkg; Pkg.add("Gattino")
```
## plotting methods
`Gattino` provides a few *complete* plotting functions out of the box, each of these has a mutating `_plot!` function associated with it:
- `hist` (calls `hist_plot!`)
- `line` (calls `line_plot!`)`
- and `scatter` (calls `scatter_plot!`)

These functions are used to create a context and add a plot to it using its mutating equivalent, passing all of the arguments provided to the mutating equivalent on a new `Context` creating according to the arguments for those specific values.
```julia
using Gattino
my_scatter = scatter(randn(20), randn(20), width = 100, height = 100)

my_scatter = context(100, 100) do con::Context
    scatter_plot!(con, randn(20), randn(20))
end
```

