#### toolips
- **a manic web-development framework**

`toolips` is a software ecosystem that targets the full scope of web-development; from the most basic of APIs to *complex* full-stack applications. The goal of this project is to solve the *two-language problem* as it pertains to web-development -- allowing all web-development to take place in one Scientific programming language.

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
```docstrings
start!
```
`Toolips` servers only require a `Module` to run, not a file-system -- so we can start a server from any `Module` with `Toolips.start!`. 
`start!` is provided with a `Module` (your server), an `IP4` (the IP and port to start the server on,) and has the optional key-word arguments `threads` and `router_threads`.
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
Though a file-system is not required, it may be easier to start from a base project and utilize a file-system or `Pkg` environment. 
For this, we may use `Toolips.new_app`, which takes a `String` an 
- Note that other extensions with other types of servers, such as `ToolipsUDP`, may have a different `new_app` and `start!` binding.
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
---
# routing
```docstrings
route
route!
```
`Toolips` features a dynamic three-stage routing system that can change functionality using parametric polymorphism. Two main functions comprise this routing system, `route` and `route!`. `route` is called to create routes, whereas `route!` is called by the server and routes the incoming `Connection` to a `route`. A standard `Route` is created using the `route` function, which will take a `Function` as the first positional argument and a route as the second.
```julia
home = route("/") do c::Connection

end
```
The provided `Function` will take one positional argument, an `AbstractConnection`. The call above will return a `Route{Connection}`.
## the connection
A route will be passed a `Connection` whenever it is routed with `route!`. A `Connection` represents a client's entrance into the `Function` pipeline -- each time a request is made to the server. The `Connection` stores the server's routes in its `Connection.routes` field and the server's data in its `Connection.data` field. There are also several *getter* methods associated with the `Connection`, which may be used to retrieve data:
```docstrings
get_args
get_ip
get_post
get_route
get_method
get_parent
get_client_system
```
## multiple dispatch

## routing extensions
Routes are able to be extended simply by writing new dispatches for `route!`.
## servers

### command-line interface

## requests
