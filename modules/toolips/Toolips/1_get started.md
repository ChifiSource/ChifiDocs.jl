## toolips
- **a manic web-development framework**

`toolips` is a software ecosystem that targets the full scope of web-development; from the most basic of APIs to *complex* full-stack applications. The goal of this project is to solve the *two-language problem* as it pertains to web-development -- allowing all web-development to take place in one Scientific programming language. The head of this ecosystem is the `Toolips` 
web-development framework -- a web-development framework designed with extensibility and flexibility in mind. 

For example, `Toolips` offers fullstack callbacks through the `ToolipsSession` extension, enhanced SVG capabilities through the `ToolipsSVG` extension, and UDP servers through the `ToolipsUDP` extension.
Julia, unlike JavaScript, does not easily run inside of a web-browser on the client side — so our Julia code is entirely server-side and servers like this are typically associated with back-end projects. 
Toolips is capable of far more than the average framework with extensions, and this includes full-stack development, so with this particular web-framework we are able to manage the front-end from the back-end.
Alongside full-stack web-development, Toolips includes a plethora of alluring features:
- HTTPS capable Can be deployed with SSL.
- Extensible server platform.
- Hyper-Dynamic Multiple-Dispatch Routing — The Toolips router can be completely reworked with extensions to offer completely new and exceedingly versatile functionality.
- Declarative and composable — files, html, Javascript, and CSS templating syntax provided by ToolipsServables.
- Modular servers — toolips applications are regular Julia Modules, making them easier to migrate and deploy.
- Versatilility — toolips can be used for all use-cases, from full-stack web-development to simple endpoints.
- Parallel Computing — Declarative process management provided by parametric processes.
- Optionally Asynchronous — the Toolips.start! function provides several different modes to start the server in, including asynchronous, single-threaded, and multi-threaded.
- Multi-Threaded — Toolips has support for high-level multi-threading through the `ParametricProcesses` Module

Toolips is able to create …

- Endpoints
- File servers
- Interactive fullstack web applications (using the ToolipSession extension)
- Other HTTP or TCP servers (e.g. Proxy server, data-base cursor)
- UDP servers and web-services services (e.g. Systems servers, DNS servers) (using the `ToolipsUDP` extension for UDP.)

Toolips is no ordinary framework; the framework is extensible at every level. There are such particular cases in web-development, it is such a versatile application that we need a versatile framework. For instance, by writing new methods for the route! function in Toolips we can write a custom router that, for example, writes a unique profile for each user based on their URL — so we never have to register a route for each individual profile. I also used a similar technique to create a proxy server.
- `Toolips` requires **julia**. Get Julia [here](https://julialang.org/)
## development environment
To get started with `Toolips` from Julia, you will need to add the package to an environment with `Pkg`.
```julia
using Pkg

# best available build:
Pkg.add("Toolips")

# latest working:
Pkg.add(name = "Toolips", rev = "stable")

# latest dev:
Pkg.add(name = "Toolips", rev = "Unstable")
```
## server modules
`Toolips` servers only require a `Module` to run, not a file-system -- we can start a server from any `Module` with `Toolips.start!`. 
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
`start!` comes with a number of arguments to consider including the `IP`. The inverse to `start!` is `kill!`.
```julia
start!(MyToolipsApp)
kill!(MyToolipsApp)
```
```docstrings
start!
kill!
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
- A `dev.jl` file is provided alongside these projects to automatically start a development server with a simple `include`. This server may be started with `include("dev.jl")`, or from `Bash` or `Command Prompt` `julia -L dev.jl`.
- Note the **export of `default_404`**. `default_404` is routed to `404` (try `Toolips.default_404.path`). to replace this response page simply make a new route with the `404` path and **export** it. `default_404` will automatically be used on servers without a `404` route, so this export is reduntant but in place to demonstrate a `404` page.
