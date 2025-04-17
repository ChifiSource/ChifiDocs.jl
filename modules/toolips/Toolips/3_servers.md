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

**There are some key caveats to multi-threading in Toolips**, at least when it comes to doing so using the router. A `Stream` can only be written to by the `Base` thread. `Toolips` provides a solution to this with the `IOConnection`. This allows for data to be translated back to the base thread and written asynchronously. This means that for multi-threading to work, we will need to annotate our routes with `AbstractConnection`, or some type of converted `Connection` type.

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
```
Then we bind it to any `Toolips` functions we want to use (on_start, route!),
```julia
```
and we finish by exporting it in our server `Module`.
```julia
```
