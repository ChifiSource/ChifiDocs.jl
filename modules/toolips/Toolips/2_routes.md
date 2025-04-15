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

A `Component` can also have its style modified using `style!`, and `setindex!`/`getindex!` work to retrieve any of these properties with a `Symbol` or `String`.
```julia
# TODO EXAMPLE HERE

```
For a more exhaustive overview of the features `ToolipsServables` offers, you can check out the documentation for the package [here](/toolips/ToolipsServables)
## files

## multiroute

## routing extensions


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

