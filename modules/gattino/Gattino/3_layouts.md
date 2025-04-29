## context layouts
Layouts in `Gattino` take form in two different ways; the *context layout* and the *html layout*. Context-based layouts are the more flexible of the two, but also puts all elements onto the same window and can lead to *some* scaling confusion. While layering and scaling can both be done in tandem with `group!` we may also exclusively scale using `group`. Note that the width of our plot is only `250` below, whereas our `Context` window width is 500.
```julia
myframe = context(500, 250) do con::Context
    group(con, 250, 250) do g::Group
        Gattino.scatter_plot!(g, [1, 2, 3, 4], [1, 2, 3, 4])
    end
end
```
We use a `250` margin on the X to set the next visualization into the empty space.
```julia
group(myframe, 250, 250, 250 => 0) do g::Group
    Gattino.grid!(g, 4, "stroke" => "pink")
end
```
`groupgatsample`
## html layouts
HTML layouts are a dramatically simplified version of layouts where we place contexts next to eachother, rather than combining multiple visualizations on the same context. This is done with `vcat` and `hcat`.
```julia
vcat(comp::AbstractContext, cons::AbstractContext ...)
hcat(comp::AbstractContext, cons::AbstractContext ...)
```
We can do this infinitely; `hcat` will combine the elements next to eachother in a new `inline` container, whereas `vcat` will put them into a new row in a new `Component`. Note that this will give us a `Component{:div}` and isn't meant to replace your visualization, but be a concatenated copy.


