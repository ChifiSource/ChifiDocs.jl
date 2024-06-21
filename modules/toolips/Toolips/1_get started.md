#### toolips
- **a manic web-development framework**

`toolips` is a software ecosystem that targets the full scope of web-development; from the most basic of APIs to *complex* full-stack applications. The goal of this project is to solve the *two-language problem* as it pertains to web-development -- allowing all web-development to take place in one Scientific programming language. The head of this ecosystem is the `Toolips` 
web-development framework -- a web-development framework designed with extensibility and flexibility in mind. 

For example, `Toolips` offers fullstack callbacks through the `ToolipsSession` extension, enhanced SVG capabilities through the `ToolipsSVG` extension, and UDP servers through the `ToolipsUDP` extension.
```docstrings
Toolips
```

---
# development environment
To get started with `Toolips`, you will need to add the package to an environment with `Pkg`.
```julia
using Pkg

# best available build:
Pkg.add("Toolips")

# latest working:
Pkg.add("Toolips", rev = "stable")

# latest dev:
Pkg.add("Toolips", rev = "Unstable")
```
`Toolips` servers only require a `Module` to run, not a file-system -- so we can start a server from any `Module` with `Toolips.start!`. 
`start!` is provided with a `Module` (your server), an `IP4` (the IP and port to start the server on,) and has the optional key-word arguments `threads` and `router_threads`.
```docstrings
start!
```
```julia
module ExampleServer
using Toolips

# 'hello world' in Toolips:
main = route("/") do c::Connection
    write!(c, "hello world!")
end

#   exporting `main` will load the route. `start!` will allow us to start the server.
export main, start!
end
```
From here, we simply `use` the server and then `start!` it.
```julia
using Main.ExampleServer

start!(ExampleServer)
```
An `IP4` is constructed in a relatively pragmatic way...
```julia
ip = "127.0.0.1":8000
```
```julia
start!(ExampleServer, "127.0.0.1":9000)
```
```docstrings
IP4
```
Though a file-system is not required, it may be easier to start from a base project and utilize a file-system or `Pkg` environment. 
For this, we may use `Toolips.new_app`, which takes a `String`, our project name. We can also provide a `ServerTemplate` to both 
`start!` and `new_app` in the first position before the other arguments to create or start a certain type of app. For example, 
the here is a simple `ToolipsUDP` server
```julia
using Toolips; Toolips.new_app("MyToolipsApp")
```
This will generate a simple base project, demonstrating the basics of `Toolips`:
```julia
module MyToolipsApp
using Toolips
# using Toolips.Components

# extensions
logger = Toolips.Logger()

main = route("/") do c::Toolips.AbstractConnection
    if ~(:clients in c)
        push!(c.data, :clients => 0)
    end
    c[:clients] += 1
    client_number = string(c[:clients])
    log(logger, "served client " * client_number)
    write!(c, "hello client #" * client_number)
end

# make sure to export!
export main, default_404, logger
end # - module MyToolipsApp <3
```
- A `dev.jl` file is provided alongside these projects to automatically start a development server with a simple `include`. This server may be started with `include("dev.jl")`.


Note the **export of `default_404`**. `default_404` is routed to `404` (try `Toolips.default_404.path`). to replace this response page simply make a new route with the `404` path and **export** it. `default_404` will automatically be used on servers without a `404` route, so routing this is not entirely necessary.
```julia
start!(MyToolipsApp)
kill!(MyToolipsApp)
```
After using `start!` we can use `kill!` on the `Module` to kill the server:
```docstrings
kill!
```
---
# routing
```docstrings
AbstractRoute
```
`Toolips` features a dynamic three-stage routing system that can change functionality using parametric polymorphism. Two main functions comprise this routing system, `route` and `route!`. `route` is called to create routes, whereas `route!` is called by the server and routes the incoming `Connection` to a `route`. A standard `Route` is created using the `route` function, which will take a `Function` as the first positional argument and a route as the second.
```julia
home = route("/") do c::Connection

end
```
The provided `Function` will take one positional argument, an `AbstractConnection`. A standard `Toolips` route will hold the `Connection` type in a type parameter. The call above will return a `Route{Connection}`. 
```docstrings
route
```
## the connection
A route will be passed a `Connection` whenever it is routed with `route!`. A `Connection` represents a client's entrance into the `Function` pipeline -- each time a request is made to the server. The `Connection` stores the server's routes in its `Connection.routes` field and the server's data in its `Connection.data` field. 
```docstrings
Connection
```
The most vital function in association with the `Connection` is `write!`, which is used to write data to the incoming `Connection` as a response. Note that `write!` is not `write`, as this is a mutating `write!` -- a write on a response *cannot* be reverted!
```docstrings
write!
```
There are also several *getter* methods associated with the `Connection`, which may be used to retrieve data:
```docstrings
get_args
get_ip
get_post
get_route
get_method
get_parent
```
```julia
module Adder
using Toolips

addition = route("/") do c::AbstractConnection
    args = get_args(c)
    x, y = parse(Int64, args[:x]), parse(Int64, args[:y])
    write!(c, x + y)
end

export addition, start!
end
```
---