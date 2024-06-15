#### toolips
- **a manic web-development framework**

`toolips` is a software ecosystem that targets the full scope of web-development; from the most basic of APIs to *complex* full-stack applications. The goal of this project is to solve the *two-language problem* as it pertains to web-development. In normal circumstances, a data-driven website consists of two to three applications;
- the *front-end*, client-side JavaScript,
- the *back-end*, server-side JavaScript,
- and the *data back-end*, server-side statistical language.

With `Toolips`, each of these applications' goals are facilitated by `Toolips` alongside its `toolips` extension ecosystem, eliminating the need for other languages or servers. In addition to targeting a broad range of capabilities, the package also targets *minimalism* at its base -- opting to load features via extensions as they are requested. Finally, `Toolips` also utilizes a declarative `export` and routing syntax, alongside the high-level `ToolipsServables` templating syntax.
# development environment
To get started with `Toolips`, you will need to add the package to an environment with `Pkg`.
```julia
using Pkg

Pkg.add("Toolips")
# latest working:
# Pkg.add("Toolips", rev = "stable")
# latest dev:
# Pkg.add("Toolips", rev = "Unstable")
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
Though a file-system is not required, it may be easier to start from a base project. For this, we may use `Toolips.new_app`. 
- Note that other extensions with other types of servers, such as `ToolipsUDP`, may have a different `new_app` and `start!` binding.
```julia
using Toolips; Toolips.new_app("MyToolipsApp")
```
This will generate a simple base project, demonstrating the basics of `Toolips`:
```julia
x = 5
```
# routing
`Toolips` features a dynamic three-stage routing system that can change functionality using parametric polymorphism.
## the connection

## multiple dispatch

## routing extensions

## servers

### command-line interface
