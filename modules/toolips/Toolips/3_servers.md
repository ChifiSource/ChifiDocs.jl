--
## controlling servers
As touched on in our initial overview of `start!`, `start!` is the inverse of `kill!`. A call to start will return a `ProcessManager`. The `ProcessManager` is provided by `ParametricProcesses` and makes it easier for `Toolips` to distribute incoming tasks onto multiple threads. For more information of the process management system behind `Toolips`, it might be worthwhile to check out the `ParametricProcesses` [documentation](/parametric/ParametricProcesses).
## multi-threading and processes
The `start!` function gives us several key-word arguments, `async`, `threads`, and `router_threads` will all change the **thread mode** of our server. `async` will determine whether or not the server runs **asynchronously on the main thread**. When set to false, an active server will take the entire thread. `threads` will determine **the total number of workers** in our `ProcessManager`. Finally, `router_threads` is used to determine the range of threads that should be used when routing the server. On a server with `threads` set to 1, `router_threads` will not be used. When `router_threads` is used, each number in the range below 2 represents execution on the base thread. To elaborate, in the case of `-2:3` we would serve the first four incoming requests using the base thread and then use an additional two threads before repeating.
```julia
start!(mod::Module = Main, ip::IP4 = ip4_cli(Main.ARGS);
      threads::Int64 = 1, router_threads::UnitRange{Int64} = -2:threads, router_type::Type{<:AbstractRoute} = AbstractRoute, 
      async::Bool = true)
```
Understanding the base thread and how it impacts performance is important. Evaluating everything on the base thread will **always** be faster, as we do not need to translate all of the data we are working with over to the other thread, *unless* that thread is already bogged down with a lot of other actions.

**There are some key caveats to multi-threading in Toolips**, at least when it comes to doing so using the router. A `Stream` can only be written to by the `Base` thread. `Toolips` provides a solution to this with the `IOConnection`. This allows for data to be translated back to the base thread and written asynchronously. This means that for multi-threading to work, we will need to annotate our routes with `AbstractConnection`, or some type of converted `Connection` type. We *also* need to use a full environment and project for multi-threading to work, otherwise the module and its environment cannot be translated to the other threads. Ensure the website is a regular Julia package, not an in-REPL `Module` -- otherwise you will get an undefined error when a job is distributed.

If all of that is enough, it is also possible to create and distribute processes manually using the `ParametricProcesses` API through the `Connection` or directly. `Toolips` exports the essentials (click to view documentation, and note the `Connection` dispatches added by `Toolips`):
- `assign!`
- `distribute!`
- `assign_open!`
- `distribute_open!`
- `new_job`

A `new_job` can be distributed to a `ProcessManager` or `Connection` directly using these functions. 
```julia
using Toolips
              #  disable router multi-threading
pm = start!(Toolips, threads = 8, router_threads = 1:1)

job = new_job() do
    @info "hello world!"
end

assign!(pm, 2, job)
```

- `ToolipsSession` `0.4.5`+ also has a multi-threading system for callbacks specifically, and this might be better in some projects.
## using server extensions
Server extensions are an integral part of `Toolips` that allows the server to load new advanced capabilities with a single export. In order to use a server extension, start by importing and constructing it -- in this case, we will use the `Logger` -- a `ServerExtension` that comes with `Toolips`.
```julia
module SampleServer
using Toolips

LOGGER = Toolips.Logger()
export LOGGER
end
```
After constructing, just like the routes we will want to export our new extension. Congratulations, the extension is loaded. Here is an example from the `Toolips` ecosystem using `ToolipsSession`:
```julia
module SampleServer
using Toolips
using Toolips.Components
using ToolipsSession

SESSION = ToolipsSession.Session()
LOGGER = Toolips.Logger()

home = route("/") do c::AbstractConnection
      log(c, "hello world!")
      mainbod = body("main")
      # session callback using `ToolipsSession`
      on(c, mainbod, "click") do cm::ComponentModifier
            color_choice = randn(1:5)
            selected_color = ("blue", "white", "orange", "red", "green")[color_choice]
            style!(cm, mainbod, "background-color" => selected_color)
      end
      write!(c, mainbod)
end


export SESSION, LOGGER
export home
end
```
For quick access to `on_start` and `route!` functionality, we can also take advantage of the `QuickExtension` symbolic type. This allows for new extension types to be implemented without creating a new structure.
```julia
module SampleServer
using Toolips
import Toolips: route!, on_start

LOAD = Toolips.QuickExtension{:load}()

on_start(ext::QuickExtension{:load}, data::Dict{Symbol, Any}, routes::Vector{<:AbstractRoute}) = begin
      @info "The server just started"
end

route!(c::AbstractConnection, qe::QuickExtension{:load}) = begin
      @info "The server just served a client"
end

home = route(c -> write!(c, "hello!"), "/")

export LOAD, home
end
```
## creating server extensions
A `ServerExtension` able to change the server's functionality in a few key ways:
- The extension can do something each time the server routes using a `route!` binding.
- The extension can do something each time the server starts with an `on_start` binding.
- And finally, an extension can hold data for the server within its fields.

Creating your own server extension is straightforward, first we make our `ServerExtension` type,
```julia
module ClientTrackServer
using Toolips

mutable struct ClientTracker <: Toolips.ServerExtension
      clients::Vector{String}
      ClientTracker() = new(Vector{String}())
end

home = route(Toolips.default_404.page, "/")

TRACKER = ClientTracker()

export TRACKER, home
end
```
Then we bind it to any `Toolips` functions we want to use (on_start, route!),
```julia
module ClientTrackServer
using Toolips
# be sure to import, or you will create `ClientTrackServer.on_start` instead 
#    of a new `Method`.
import Toolips: on_start, route!

mutable struct ClientTracker <: Toolips.ServerExtension
      clients::Vector{String}
      ClientTracker() = new(Vector{String}())
end

home = route(Toolips.default_404.page, "/")

TRACKER = ClientTracker()

# our new bindings:
function on_start(ext::ClientTracker, data::Dict{Symbol, Any}, routes::Vector{<:AbstractRoute})
      # ensure `clients` is left empty (in case of restart).
      ext.clients = Vector{String}()
end

function route!(c::AbstractConnection, ext::ClientTracker)
      ip = get_ip(c)
      # check if the client is currently counted:
      if ~(ip in ext.clients)
            @info "registering client: $ip"
            push!(ext.clients, ip)
      end
      ip = nothing
end


client_count = route("/clients") do c::AbstractConnection
      write!(c, length(TRACKER.clients))
end

export TRACKER, home, client_count
end
```
and we finish by exporting it in our server `Module`. Note that these bindings are **not necessary** but optional dependent on the desired functionality of the `ServerExtension`.
## extended servers
While `Toolips` *primarily* targets HTTP-based web-development, the package is not *just* a web-development framework, but also a **server-development framework**. For UDP servers, check out the [ToolipsUDP](/toolips/ToolipsUDP) extension. `Toolips` includes a built-in TCP server extension. To start from a `TCP` server template, use 
`new_app(:TCP, name::String)` dispatch of `new_app`.
```julia
using Toolips

Toolips.new_app(:TCP, "NewServer")
```
This will give us a nice minimal demonstration:
```julia
module NewServer
using Toolips
using Toolips: get_ip4, handler, read_all

main_handler = handler() do c::Toolips.SocketConnection
    query = read_all(c)
    write!(c, "hello client!")
end
# (try with `socket = connect(server IP4); write!(socket, "hello server!"); print(String(readavailable(socket)))`
export main_handler, start!
end
```
The `Connection` is then replaced with the `SocketConnection`, and the `Route` with the `Handler`. The `Handler` is an `AbstractHandler`, created using the `handler` function. TCP is a `Connection`-based protocol, and in most cases we would choose to keep this connection open. There is also `get_ip4` for getting the connecting port alongside the IP address. The `is_closed` and `is_connected` bindings are useful for this.
```julia
main_handler = handler() do c::Toolips.SocketConnection
    input_str = ""
    while is_connected(c)
        input_str = input_str * input_str
        if ~(length(input_str) > 2 && input_str[end - 1:end] == "!\n")
            continue
        end
        result = input_str[1:end - 3]
        @warn result
        if result == "password"
            break
        end
        write!(c, "thanks for sending!")
        input_str = ""
    end
    # second loop?
    while is_connected(c)
      break
    end
end
```
There is also a convenience function provided for easily creating a `handler`, `continue_connection`.
