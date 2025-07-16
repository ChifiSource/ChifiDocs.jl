### welcome to toolips app !
Welcome to the fourth iteration of toolips app ! `ToolipsApp` is an application built to demonstrate the numerous capabilities of `Toolips`. This is a gallery 
of different websites created entirely with `Toolips`. This concept has a storied history of being developed alongside `Toolips`, `ToolipsSession`, and `Olive`, and is 
currently on its fourth iteration. The latest *reimplements* the *carousel* concept introduced in the last version of toolips app. This implementation is driven by a `CarouselArray` from [CarouselArrays](/chifi/CarouselArrays) just as it was in the last version.
##### using toolips app
The topbar contains basic buttons for navigation. On the left is a back button that will take you back to `ChifiDocs`. Across from the logo is the source button. Use the source button at the top to flip between `source` / the web-view. Use the two arrows at the top to switch between web-pages. Most importantly, have fun and enjoy !
##### explanation
```julia
toolipsapp_main = route("/toolips/app/main") do c::Connection
    write!(c, c[:doc].pages["styles"], Style("p", "color" => "white"))
    msg = tmd("msg", read(DIREC * "/toolipsapp/app_main.md", String))
    ToolipsServables.interpolate!(msg, "julia" => Documator.julia_interpolator)
    mainbod = body("main", children = [msg])
    style!(mainbod, "padding" => 10percent, "background-color" => "#4f638c")
    write!(c, mainbod)
end
```
The landing page for `ToolipsApp` is pretty minimal -- it exists as only a route, not an entire server. We start by creating the route itself:
```julia
toolipsapp_main = route("/toolips/app/main") do c::Connection

end
```
Note the path; this path is indeed available, and we are able to visit this app page directly. Next, we call `write!` on `c`, the `Connection` and some other operands. When we call `write!`, we are providing **response output** so this will be written to the client's page on initial response.
```julia
write!(c, c[:doc].pages["styles"], 
    Style("p", "color" => "white"))
```
Here, we use `c[:doc]` to access the [Documator](/chifi/Documator) `Docloader` extension. This is just to access the stylesheet that already exists for `ChifiDocs`. Here, we also see an example of `Style` creation, where a name is provided alongside an infinite list of pairs:
```julia
all_ps = Style("p", "color" => "white", "font-size" => 13pt)
p_class = style("p.myclass", "font-weight" => "bold", "padding" => 2percent)
```
Next, we call a special `Component` constructor: `tmd`. `tmd` stands for `ToolipsMarkdown`. This `Component` will 
turn a markdown string into `html`, which is super handy. As per usual, it takes a name as the first positional argument. 
`tmd` is a bit different, as next it takes another `String` and then takes arguments like a normal `Component`.
```julia
msg = tmd("msg", read(DIREC * "/toolipsapp/app_main.md", String), align = "center")
```
To add to our tmd's visual quality, I am going to add Julia syntax highlighting. Our function, `julia_interpolator` takes a `String` and returns that `String` as highlighted julia code. It might be worth viewing the documentation for [interpolate!](/search?q=interpolate!)
```julia
ToolipsServables.interpolate!(msg, "julia" => Documator.julia_interpolator)
```
Making the body is straightforward, we just make a `body` `Component` with our `tmd` as the child.
```julia
mainbod = body("main", children = [msg])
```
Next, we see an example of mutating styles with `style!`. `style` will create a `Style` whereas `style!` modifies a `Style` or the `style` property of a `Component`. In this particular case, we care calling it on a `Component{:body}` so we will be modifying the `style` property of that 
`Component`.
```julia
style!(mainbod, "padding" => 20percent, "background-color" => "#4f638c")
write!(c, mainbod)
```
This closes with a final call to `write!`, writing our final result (this page):
```julia
toolipsapp_main = route("/toolips/app/main") do c::Connection
    write!(c, c[:doc].pages["styles"], Style("p", "color" => "white"))
    msg = tmd("msg", read(DIREC * "/toolipsapp/app_main.md", String))
    ToolipsServables.interpolate!(msg, "julia" => Documator.julia_interpolator)
    mainbod = body("main", children = [msg])
    style!(mainbod, "padding" => 10percent, "background-color" => "#4f638c")
    write!(c, mainbod)
end
```
##### future toolips app
Future iterations of `ToolipsApp` are going to build a bit more onto this system in smaller ways. This will primarily culminate in the addition of new apps, but the next version will also include more complicated markdown-based walkthroughs for *each* app, similar to the breakdown of this app shown here. This will likely come in the form of a new button on the top bar, possibly `explanation`, which will replace the window with the source code for the package.

This is the first version of the new `ToolipsApp`, thanks for checking it out. The next application I plan to implement is a modified version of the `Connect4` app, which is currently stored [here](https://github.com/emmaccode/Connect4.jl)