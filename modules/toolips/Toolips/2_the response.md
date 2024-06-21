## creating responses
Whenever a client connects to your server, our route's function is called and provided with a `Connection`. The `Connection` includes client data -- from the header, your server's data, as well as a stream to write to. Creating a response usually involves leveraging input alongside server data to produce a result. Server data can be indexed by symbol from the `Connection`.
```julia
module VisitCounter
using Toolips

home = route("/") do c::Connection
    write!(c, "this is your $(visitn)" visit)
end

end
```
## mount and files
The `mount` function is used to quickly create a route from a file or a directory. The function will take a single `Pair{String, String}` as a positional argument. Routing from a directory will route all subsequent files and directories, exactly as you would expect it to. Alternatively, you may route a file directly.
```docstrings
mount
```
```
#     myfiles is a directory
# shell> tree .
# .
# ├── file1
# ├── file2
# └── finalfile.txt
# 1 directory, 3 files
```
```julia
module EmmasFileServer
using Toolips

file_routes = mount("/" => "myfiles")

main = route("/") do c::Toolips.AbstractConnection
    write!(c, "you've reached emma's files!\n")
    # file list. file_route is a `Vector{AbstractRoute}`, one route for each file.
    for file_route in file_routes
        #    using the hostname to get our URL.
        write!(c, "http://" * get_host(c) * file_route.path * "\n")
    end
end

# make sure to export!
export main, file_routes
end
```
- Note that these links are not clickable, as this would require `Components`, which would be getting a little ahead of ourselves.
```julia
julia> start!(EmmasFileServer)
```
Files may also be written directly by using the parametric `File` type provided by `ToolipsServables`.
```julia
module FileServer
using Toolips
newf = File("path/to/file.txt")
# File{:txt}

main = route("/") do c
    write!(c, newf)
end
```
Alongside this, `ToolipsServables` provides a myriad of useful `interpolate!` and `interpolate` bindings, which are useful for interpolating these files -- and sometimes even components.

This is one way to create responses -- files can be interpolated with values or elements from Julia and then served to clients. Alternatively, we can compose an entire web-page from components.
## components
Components are the Julia-side representation of an `HTML` DOM element. For example, there are `Component{:body}`, `Component{:div}`, and `Component{:h1}` components, alongside any other type of element available in HTML. Many components are provided with easy alias or `Method` calls in order to construct them. A `Component` constructor will take our tag/type, our component's name, 
and arguments -- provided as key-word arguments or a `Pair{String, <:Any}`. Components can then be styled with `style!` and composed by using `push!` to append new children.
```julia
# basic top-menu example
example_div = div("menu")
```
- There is a far more in-depth overview on templating available in the `ToolipsServables` documentation. `ToolipsServables` is aliased as `Components` in `Toolips`.
```julia
module SampleServer
using Toolips
using Toolips.Components

end
```
### ToolipsSession

