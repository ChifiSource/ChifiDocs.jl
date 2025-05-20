## contexts
Visualizations in `Gattino` are created through the `Context` type, a sub-type of `AbstractContext`. The `Context` acts as a **scaling wrapper** for the `Component{:svg}`. When written through the `Context`, the components are meant to be scaled to the correct size of the current context. The `Context` stores the SVG window, `Component{:svg}`, as `window` and `dim`/`margin` two `Int64` pairs that represent the current dimensions and margins we are drawing from. These are easily constructed through the `context` function. Here is a full list of (non-plotting) functions to be used with the `context`.
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

- `compess!` can also be used on a `Context`, this will reduce its memory usage dramatically but will make its contents no longer editable.
The `context` function will take a `Function` as its first argument. This function will take a `Context` and mutate the `Context`. Keep in mind that we can perform this mutation outside of this `Function`, and `context` will always return a `Context` using base `Gattino` dispatches. A **context plotting function** is used to **mutate** a `Context`. All of these will end in an exclamation point as they are mutating. When these are called on the `Context`, the function will scale its output to the `Context` and add it to the `Context`. The mutating equivalents of `scatter`, `hist`, and `line` (`scatter_plot!`, `hist_plot!`, and `line_plot!`,) are the first examples we have seen of these functions, but `Gattino` includes a number of unexported plot bindings:

Here is a comprehensive list of every **context plotting function** base `Gattino` provides (click to view documentation):
- `text!`
- `line!`
- `gridlabels!`
- `grid!`
- `labeled_grid!`
- `points!`
- `axes!`
- `axislabels!`
- `bars!`
- `barlabels!`
- `v_bars!`
- `v_barlabels!`
- `legend!`
- `append_legend!`
- `make_legend_preview`
```julia

```
- Note that if continuous numerical data has already been scaled to our `Context`, we provide a maximum and minimum value as arguments to each of these functions to keep it scaled properly with that data. Ideally, you would plot the data with the largest continuous range *first* to account for this.
## layers
Another important thing to consider in `Gattino` is *layering*. Layers in `Gattino` are individual *children* of the `Context.window` `Component{:svg}`. We can access new layers with `layers`, and create new layers by using `group!`. For mutating layers, we also have some additional functions:
- `layers`
- `group!`
- `move_layer!`
- `delete_layer!`
- and `rename_layer!`

## layer scaling
Our individual layers can also be scaled, either individually with `group!` or in totality with `group`. We pass a function to both of these, and that function will take a `Group` -- which is another type of `AbstractContext`. The `Group` will provide the same scaling features as a `Context`, only it will not draw to a new layer it will draw straight to the `Context`. So, for example, if we had an algorithm to make a plot on multiple layers of a context (such as `scatter_plot!`) we could use `group` to create the dimensions of the plot window and use `group!` on the resulting `Group`. 
```julia
mycon = context() do con::Context
    w, h = Int64(round(con.dim[1] * .75)), Int64(round(con.dim[2] * .75))
    ml, mt = Int64(round(con.dim[1] * .12)) + con.margin[1], Int64(round(con.dim[2] * .12) + con.margin[2])
    group!(con, "title") do titlegroup::Group
        posx = Int64(round(con.dim[1] * .35) + con.margin[1])
        posy = Int64(round(con.dim[2] * .08) + con.margin[2])
        Gattino.text!(con, posx, posy, "sample plot", "fill" => "black", "font-size" => 15pt)
    end
   group(con, w, h, ml => mt) do plotgroup::Group
        group!(plotgroup, "axes") do g::Group
            Gattino.axes!(g)
        end
        group!(plotgroup, "grid") do g::Group
            Gattino.grid!(g, 4)
        end
    end
end
```
`conmanual`

## editing layers
After creating your layers, layers can be edited using several key methods. Firstly, there is a binding for `style!` for `Context` layers:
```julia
# for layers:
style!(con::AbstractContext, s::String, spairs::Pair{String, String} ...)
# for styling the window:
style!(con::AbstractContext, spairs::Pair{String, String} ...)
```
We can also `set_shape!` on a layer.
```julia
set_shape!(con::AbstractContext, layer::String, into::Symbol; args ...)
```

Finally, there is open mode, which will loop through each `Component` and also give its enumeration. We open a `Context` using `open_layer!`.
```julia
open_layer!(f::Function, con::AbstractContext, layer::String)
```
We pass a `Function` into `open_layer`, which takes a `Pair{Int64, Component}` -- the enumeration and the `Component`. This `ecomp` combination has several functions binded to it. These numerous options allow us to create variations using data (or across the entire layer). For setting component properties (such as the radius of a circle with `r`,) we use `set!`:
```julia
# sets every component's property statically:
set!(ecomp::Pair{Int64, <:ToolipsSVG.ToolipsServables.Servable}, prop::Symbol, value::Any)
# scales the value based on `vec`, using `max` for values that are `100`-percent of the maximum of `vec`.
set!(ecomp::Pair{Int64, <:ToolipsSVG.ToolipsServables.Servable}, prop::Symbol, vec::Vector{<:Number}; max::Int64 = 10)
# sets value to 
set!(ecomp::Pair{Int64, <:ToolipsSVG.ToolipsServables.Servable}, prop::Symbol, vec::Vector{<:AbstractString})
```
There are also different `style!` bindings for a `Pair{Int64, Component}` that allow for the same changes with styles.
```julia
# style the value of `stylep` based on the values of `vec` on the open components.
style!(ecomp::Pair{Int64, <:ToolipsSVG.ToolipsServables.AbstractComponent}, vec::Vector{<:Number}, stylep::Pair{String, Int64} ...)
# style each subsequent component with each subsequent element in `vec`
style!(ecomp::Pair{Int64, <:ToolipsSVG.ToolipsServables.AbstractComponent}, key::String, vec::Vector{String})
# regular styling:
style!(ecomp::Pair{Int64, <:ToolipsSVG.ToolipsServables.AbstractComponent}, p::Pair{String, String} ...)
```
There is also `set_gradient!`, which can be used to make a gradient across multiple components in a visualization. Useful for this is a gradient creation function, `make_gradient`. Make sure to check out all of the dispatches here, as these functions can be used in a lot of different ways.
```julia
using Gattino
firstfeature = randn(500)
secondfeature = randn(500)

mycon = context(500, 500) do con::Context
    Gattino.scatter_plot!(con, firstfeature, secondfeature)
end

thirdfeature = randn(500)
fourthfeature = randn(500)

Gattino.open_layer!(mycon, "points") do ec
    Gattino.set!(ec, :r, thirdfeature, max = 60)
    style!(ec, "stroke" => "#1e1e1e")
    style!(ec, fourthfeature, "stroke-width" => 10)
end

mycon
```

`openlayersample`

- By using `open_layer!`, we can represent multiple features more easily in the same visualization, especially related features.




