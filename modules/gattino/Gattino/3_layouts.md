## context layouts
Layouts in `Gattino` take form in two different ways; the *context layout* and the *html layout*. Context-based layouts are the more flexible of the two, but also puts all elements onto the same window and can lead to *some* scaling confusion.
## html layouts
HTML layouts are a dramatically simplified version of layouts where we place contexts next to eachother, rather than combining multiple visualizations on the same context. This is done with `vcat` and `hcat`.
```julia
vcat(comp::AbstractContext, cons::AbstractContext ...)
hcat(comp::AbstractContext, cons::AbstractContext ...)
```