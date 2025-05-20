--
### routing
- `AbstractRoute`
`Toolips` features a dynamic three-stage routing system that can change functionality using parametric polymorphism. Two main functions comprise this routing system, `route` and `route!`. `route` is called to create routes, whereas `route!` is called by the server and routes the incoming `Connection` to a `route`. A standard `Route` is created using the `route` function, which will take a `Function` as the first positional argument and a route as the second.
```julia
home = route("/") do c::Connection

end
```
The provided `Function` will take one positional argument, an `AbstractConnection`. A standard `Toolips` route will hold the `Connection` type in a type parameter. The call above will return a `Route{Connection}`.  With no annotation, this will automatically use any `AbstractConnection`. This is primarily used for `Toolips` [multiple-dispatch routing](#multiroute).
## the connection
A route will be passed a `Connection` whenever it is routed with `route!`. A `Connection` represents a client's entrance into the `Function` pipeline -- each time a request is made to the server. The `Connection` stores the server's routes in its `Connection.routes` field and the server's data in its `Connection.data` field. 
```docstrings
Connection
```
The most vital function in association with the `Connection` is `write!`, which is used to write data to the incoming `Connection` as a response. Note that `write!` is not `write`, as this is a mutating `write!` -- a write on a response *cannot* be reverted!
```docstrings
write!
```
There are also several *getter* methods associated with the `Connection`, which may be used to retrieve data(*click* to reveal docstrings):

- `get_args`
- `get_ip`
- `get_post`
- `get_host`
- `get_route`
- `get_method`
- `get_parent`
- `get_client_system`
- `get_cookies`

- For storing cookies, the (`HTTP`) `Cookie` type will be used.

Here are some other functions for working with the `Connection` (*click* to reveal docstrings):
- `startread!`
- `proxy_pass!`
- `download!`
- `respond!`

- Many connections will also come with a `convert!` and `convert` binding. This is one of the ways we can implement a [Connection extension](#connection-extensions). 

The standard process for using the `Connection` involves crafting a response from a `Route` and then writing it to the `Connection` with `write!`. 
```julia
module LandingPage
using Toolips
using Toolips.Components

home = route("/") do c::AbstractConnection
    title_box = h2(text = "welcome to my page!")
    top_header = div("top", align = "center", children = [title_box])
    style!(top_header, "padding-top" => 25px, "height" => 25percent, "width" => 100percent, 
    "background-color" => "#1e1e1e")
    content = div("main", align = "left")
    style!(content, "padding" => 1percent, "width" => 100percent, 
    "background-color" => "#1e1e1e")
    mainbod = body(children = [top_header, content])
    write!(c, mainbod)
end

LOGGER = Toolips.Logger()
export LOGGER, home
end
```
## the response
Creating a response is a great place to start with `Toolips`. To create an app, we build a regular `Module` with `Toolips` as a dependency.
```julia
module SimpleServer
using Toolips

end
```
We create a route using the `route` function, which is provided a `path` (`String`) and a `page` (`Function`). The target will start at `/` and from there we may add additional paths.

```julia
module SimpleServer
using Toolips

home = route("/") do c::AbstractConnection

end
```
We can write strings as a response with `write!`
```julia
write!(c)
```
... and we can also use `ToolipsServables` `Component` templating or other packages to produce our response.
```julia
main = route("/") do c::Toolips.AbstractConnection
    main_box = div("main")
    file_button_style = style("div.filebutton", "padding" => 5percent, "margin" => 2percent, "color" => "#1e1e1e", "font-weight" => "bold", "font-size" => 15pt, 
    "border-radius" => 5px, "border" => "2px solid #1e1e1e", "cursor" => "pointer", "transition" => 850ms)
    file_button_style:"hover":["transform" => "scale(1.05)"]
    style!(main_box, "position" => "absolute", "overflow-x" => "show", "width" => 40percent, "height" => 60percent, "padding" => 5percent, 
    "top" => 0percent, "left" => 0percent)
    for md_filename in readdir(DOCUMENTS_URI)
        presentable_name = replace(md_filename, ".md" => "")
        comp_name = replace(presentable_name, " " => "-")
        push!(main_box, div(comp_name, text = presentable_name, class = "filebutton"))
    end
    write!(c, file_button_style)
    write!(c, body("mainbody", children = [main_box]))
end
```
## templating
Templating for `Toolips` is provided by `ToolipsServables`, aliased as `Components` in `Toolips`. `ToolipsServables` provides an API for templating CSS, HTML, and JavaScript from Julia, allowing us to create some pretty complex websites. 

Every `AbstractComponent` (html element, css class or CSS animation,) will have a `name`. A `Style` will take a name style pairs:
```julia
my_style = style("div.sampleclass", "background-color" => "green", "color" => "white", "font-weight" => "bold", "font-size" => 13pt)
```
A regular `Component` will take key-word arguments and style pairs. Special amongst these are `:children`, `:extras`, and `:text`.
- `:text` is the text of the element
- `:extras` are extra components to be written before the element, as opposed to as a child of the element. This is useful for attaching scripts and other things to components.
- and `:children` are the children of that element, which will be written inside of it. We add new children by using `push!`, or by providing them as an argument when we construct the `Component`.

A `Component` can also have its style modified using `style!`, and `setindex!`/`getindex!` work to retrieve any of these properties with a `Symbol` or `String`. There is also `set_children!`.
```julia
mycomp = h2(text = "hello!")
mycomp = Component{:h2}(text = "hello")
style!(mycomp, "font-size" => 12pt, "font-weight" => "bold", "color" => "orange")

mycomp[:text] = mycomp[:text] * " world". 

new_container = div("sample-container", children = [mycomp])
set_children!(new_container, [mycomp])

push!(new_container, h3(text = "welcome to my julia website"))

```
- There is a lot more this templating can do, but this overview will not go too into detail. For a more exhaustive overview of the features `ToolipsServables` offers, you can check out the documentation for the package [here](/toolips/ToolipsServables)
- Also note the use of *measures* (e.g `pt`) from `ToolipsServables`.
## files
A `File` type is also provided by the `Components` `Module`, and like the `Component` this type may be written directly to the `Connection`. `ToolipsServables` also features the `interpolate!` function for interpolating files of different types. For serving files from routes, `Toolips` includes the `mount` function. `mount` will take a key-value pair, the HTTP target path we want to mount to and the file path to mount. This path can be file or directory; in the case of a directory, this call will return a `Vector{Route}` and in the case of a file it will return a single `Route{Connection}`. Both of these can be exported to be loaded into the server.
```julia
module QuickFileServer
using Toolips

fs = mount("/" => "shared_directory")

export fs
end
```
It is very straightforward, it might also be worth looking into `interpolate!` from `Components`, as well.
## multiroute
Multiroute is a `Toolips` feature that implements multiple dispatch routes for different types of incoming connections. We can create multiple handlers for different cases and the router will handle different incoming connections with the appropriate `AbstractConnection`. The running example for this is the `MobileConnection`.
```julia
module MobileFriendlyServer
using Toolips
using Toolips.Components

home_n = route("/") do c::AbstractConnection
    write!(c, h1(text = "desktop user!"))
end

home_m = route("/") do c::MobileConnection
    write!(c, h1(text = "mobile user!"))
end

home = route(home_n, home_m)

export home
end
```
But with `Toolips` extensibility, we could easily implement our own. For example, we could easily implement a `POST` handler using this multiple dispatch technique. For more information on writing `Connection` extensions, check out  the [connection extensions](#connection-extensions) section.
## routing extensions
Routing in Julia goes through a multi-step pipeline in which an extensible function, `route!`, is called three times.
- 1. `route!` is called on each server extension (<: of `AbstractExtension`) that has a `route!` binding.
- 2. `route!` is called on the `Vector{<:AbstractRoute}`, routing to the appropriate route.
- 3. Finally, `route!` is then called directly on a route from the previous binding.

Understanding this routing system allows us to easily change it. In order to change extension behavior each time the server routes, we use the first binding. In order to change the router, we would extend the second option and if we wanted to change what a `Route` does when routed we use the final option. For example, in order to make a hostname router we would use the second and third:

```julia
using Toolips
import Toolips: route!

abstract type AbstractHostRoute <: Toolips.AbstractRoute end

mutable struct HostRoute <: AbstractHostRoute
    path::String
    link::String
end

route!(c::AbstractConnection, r::AbstractHostRoute) = begin
    proxy_pass!(c, r.link)
end

route!(c::AbstractConnection, vec::Vector{<:AbstractHostRoute}) = begin
    host = get_host(c)
    route!(c, vec[host])
end

main = HostRoute("sample.com", "127.0.0.1:8000")

export main
end
```
For more information on the first dispatch of `route!`, see [creating server extensions](#creating-server-extensions)
## connection extensions
Another way to extend `Toolips` is by adding a `Connection` extension. This takes shape in a new `AbstractConnection`, which will need to have a binding to `write!` (or use the default binding,) and bindings to the `Connection` getter functions. For example, the `IOConnection` comes with `Toolips` and is used to translate client data from the header to the other threads in the `ProcessManager`, so it contains fields for all of this data:
```julia
mutable struct IOConnection <: AbstractIOConnection
    stream::String
    args::Dict{Symbol, String}
    ip::String
    post::String
    route::String
    method::String
    data::Dict{Symbol, Any}
    routes::Vector{<:AbstractRoute}
    system::String
    host::String
```
And then a binding for each **getter**
- Note that if you replicate this behavior (storing the data as fields of your `Connection`,) making it a sub-type of `AbstractIOConnection` will automatically bind those getters.

Likewise, if our implementation is a bit simpler we could just use the `http.Stream` from the original `Connection`, as is the case for the `MobileConnection`.
```julia
mutable struct MobileConnection{T} <: AbstractConnection
    stream::Any
    data::Dict{Symbol, Any}
    routes::Vector{AbstractRoute}
    MobileConnection(stream::Any, data::Dict{Symbol, <:Any}, routes::Vector{<:AbstractRoute}) = begin
        new{typeof(stream)}(stream, data, routes)
    end
end
```
From here, if we could either implement this custom `Connection` into our `Function` pipeline, or write a new binding for `convert` and `convert!`. The `MobileConnection` does the former:
```julia
function convert(c::AbstractConnection, routes::Routes, into::Type{MobileConnection})
    get_client_system(c)[2]::Bool
end

function convert!(c::AbstractConnection, routes::Routes, into::Type{MobileConnection})
    MobileConnection(c.stream, c.data, routes)::MobileConnection{typeof(c.stream)}
end
```
With our `convert!` functions in place, we can create a multi-route with them for our server:
```julia
module MobileFriendlyServer
using Toolips
using Toolips.Components

home_n = route("/") do c::AbstractConnection
    write!(c, h1(text = "desktop user!"))
end

home_m = route("/") do c::MobileConnection
    write!(c, h1(text = "mobile user!"))
end

home = route(home_n, home_m)

export home
end
```
Then we may start the server:
```julia
start!(MobileFriendlyServer)
```



