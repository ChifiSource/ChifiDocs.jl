This simple RPC app uses `ToolipsSession`'s RPC feature to build a basic multi-user 
"ball" demo. In this demo, either user clicking the ball will change the ball for both users and either user double-clicking will only change the ball for the other user.
```julia
module SimpleRPCApp
using Toolips
using Toolips.Components
using ToolipsSession

logger = Toolips.Logger()
SESSION = ToolipsSession.Session(["/"])

main = route("/") do c::Toolips.AbstractConnection
    # create SVG ball
    ball = Component{:circle}("maincirc", cy = 50, cx = 50, r = 5)
    style!(ball, "fill" => "blue", "transition" => 650ms)
    main_svg = svg("mainsvg", children = [ball])
    # SVG ball RPC callbacks
    on(c, ball, "click") do cm::ComponentModifier
        cm[ball] = "r" => 15
        style!(cm, "maincirc", "fill" => "green")
        # calls to all clients (including current client)
        rpc!(c, cm)
    end
    on(c, ball, "dblclick") do cm::ComponentModifier
        style!(cm, ball, "fill" => "blue")
        cm[ball] = "cy" => 5
        # calls on all other clients (not the source client, or 'clicker')
        call!(c, cm)
        # call a specific client with call!(::AbstractConnection, ::ComponentModifier, ::String)
    end
    # Connect clients to RPC
    session_key::String = ToolipsSession.get_session_key(c)
    if ~(haskey(c.data, :act))
        open_rpc!(c)
        # we provide the session key to `join_rpc!`, so we will need to store it.
        push!(c.data, :act => session_key)
    elseif session_key == c[:act]
        open_rpc!(c)
    else
        join_rpc!(c, c[:act])
    end
    write!(c, body("rpcbod", children = [main_svg]))
end

export start!, main, SESSION
end # - module SimpleRPC <3
```
To start this server, call `start!` on `SimpleRPCApp`
```julia
process_manager = start!(SimpleRPCApp, "127.0.0.1":8000)
```
### line by line
Let's break this example down, line-by-line. We start with our dependencies:
```julia
module SimpleRPCApp
using Toolips
using Toolips.Components
using ToolipsSession
```
`ToolipsSession` is an important add here, as it gives us access to the `Session` extension. This extension stores server-side event callbacks for loaded hyper-text, allowing for single-page events to occur. `Toolips.Components` is an *aliased* `ToolipsServables`, and this package provides `Component` templating that makes it incredibly easy to create complex hypertext documents. `Toolips` is the web-development framework that powers it all, providing crucial functions to this project such as `route` and `start!`. `Toolips` servers operate using two main structures: sub-types of `AbstractRoute` and sub-types of `AbstractExtension`. In this case, we start by constructing our extensions; a `Toolips.Logger` and the `Session` extension from `ToolipsSession`.
```julia
logger = Toolips.Logger()
SESSION = ToolipsSession.Session(["/"])
```
- An important thing to note about `Session` is that it only operates on the routes added to `Session.active_routes`. This is provided directly to the constructor as the first positional argument. Alternatively, we can use `invert_active` to *invert* the active routes and instead make `Session` ignore these routes. If we have `Session` try to connect on a mounted file route, for example, this will then break the serving of that file. In this case, the only route is `/`, and `active_routes` by default will be `["/"]`, so we do not need to provide anything.

After creating our extensions, we build our routes. Below, we create `main`:
```julia
main = route("/") do c::Toolips.AbstractConnection
    # create SVG ball
...
```
We see `main`, along with the rest of our extensions, are exported from our server:
```julia
export start!, main, SESSION, logger
end # - module SimpleRPC <3
```
Take note of this; `Toolips` routes and extensions with will **only load if they are exported**.
##### main
Back in our `main` `Route`, we start by creating a `:circle` `Component`.
```julia
    # create SVG ball
    ball = Component{:circle}("maincirc", cy = 50, cx = 50, r = 5)
    style!(ball, "fill" => "blue", "transition" => 650ms)
```
A `Component` constructor will take a `name` and an infinite list of key-word arguments and pairs, representing our HTML arguments. `:text`, `:children`, and `:extras` are all special keys. `:text` will be a `String`, whereas `:children` and `:extras` will be a `Vector{AbstractComponent}`. Here we provide the properties `cy`, `cx`, and `r`. We then call `style!`, which mutates our `Component`'s `:style` property directly. We also go ahead and construct a `Component{:svg}` to hold this new circle, adding the ball as a child.
```julia
    # create SVG ball
    ball = Component{:circle}("maincirc", cy = 50, cx = 50, r = 5)
    style!(ball, "fill" => "blue", "transition" => 650ms)
    main_svg = svg("mainsvg", children = [ball])
```
Next, we create our first `ComponentModifier` callbacks. `ComponentModifier` callbacks are events, bound to a `Component` or directly to our document using the `Connection`. These are created using `on` and `bind`.
```julia
    # SVG ball RPC callbacks
    on(c, ball, "click") do cm::ComponentModifier
        cm[ball] = "r" => 15
        style!(cm, "maincirc", "fill" => "green")
        # calls to all clients (including current client)
        rpc!(c, cm)
    end
    on(c, ball, "dblclick") do cm::ComponentModifier
        style!(cm, ball, "fill" => "blue")
        cm[ball] = "cy" => 5
        # calls on all other clients (not the source client, or 'clicker')
        call!(c, cm)
        # call a specific client with call!(::AbstractConnection, ::ComponentModifier, ::String)
    end
```
Here, we see the discretion between `call!` and `rpc!`. Calling **either** of these will clear the current changes of our `cm`. `call!` may be used to *'call'* the current changes on *all other clients* **or** a single client, depending on the dispatch used.
```julia
call!(c::AbstractConnection, cm::ComponentModifier)
call!(f::Function, c::AbstractConnection, cm::ComponentModifier)
# call on specific peer
#      `peerid` = Session.get_session_key(::Connection)
call!(c::AbstractConnection, cm::ComponentModifier, peerid::String)
```
`rpc!` will call the changes on **all** clients.
```julia
rpc!(c::AbstractConnection, cm::ComponentModifier)
rpc!(f::Function, c::AbstractConnection, cm::ComponentModifier)
```
To recap, using `call!` we can call on all other peers, or a specific peer. Using `rpc!` we can call on all peers, including the current peer. To finish this, to call on the current peer we simply use our `cm` without an `rpc!` or `call!` after.
```julia
    on(c, ball, "click") do cm::ComponentModifier
        cm[ball] = "r" => 15
        style!(cm, "maincirc", "fill" => "green")
        # calls to all clients (including current client)
        rpc!(c, cm)
        #== `rpc!` just cleared our changes, so from here on out all will run on the 
        'clicker' of this button ==#
        alert!(cm, "you just clicked the button!")
    end
```
Keep in mind, we can do an `rpc!` or `call!` as many times as we may like in a single callback, so we can potentially have different actions for each peer or a specific action for a specific peer.
##### connecting RPC
The last part of our `main` route's page is a small snippet that connects incoming clients to an active RPC peer session. We start by getting the *session key* using the `get_session_key` function. This session key is used to connect to our existing RPC session.
```julia
    # Connect clients to RPC
    session_key::String = ToolipsSession.get_session_key(c)
    if ~(haskey(c.data, :act))
        open_rpc!(c)
        # we provide the session key to `join_rpc!`, so we will need to store it.
        push!(c.data, :act => session_key)
    elseif session_key == c[:act]
        open_rpc!(c)
    else
        join_rpc!(c, c[:act])
    end
```
Next, we need to keep track of our RPC session so that our other incoming clients can join. We can create an infinite number of RPC sessions, but each session must have a host. We make the current client a host by calling `open_rpc!`. Note that there is a different binding for `open_rpc!` in a callback versus in a response. The former will take a `Connection` **and** a `ComponentModifier`, whereas the latter will take only the `Connection`. The latter will not work in a callback, and the  callback version will not work in a response -- as is usually the case when both dispatches exist.

First, we check to see if `:act`, the key, is inside of our `Connection` data. If not, we go ahead and `open_rpc!`. We do the same if our current client's `session_key` happens to be the host, this will reconnect our host to the same RPC session. Finally, if they are not the host and the RPC session is already opened, we `join_rpc!` to `:act`. The `Route` finishes by composing and writing the body:
```julia
    on(c, ball, "dblclick") do cm::ComponentModifier
        style!(cm, ball, "fill" => "blue")
        cm[ball] = "cy" => 5
        # calls on all other clients (not the source client, or 'clicker')
        call!(c, cm)
        # call a specific client with call!(::AbstractConnection, ::ComponentModifier, ::String)
    end
    # Connect clients to RPC
    session_key::String = ToolipsSession.get_session_key(c)
    if ~(haskey(c.data, :act))
        open_rpc!(c)
        # we provide the session key to `join_rpc!`, so we will need to store it.
        push!(c.data, :act => session_key)
    elseif session_key == c[:act]
        open_rpc!(c)
    else
        join_rpc!(c, c[:act])
    end
    write!(c, body("rpcbod", children = [main_svg]))
```
For a final result ...
```julia
main = route("/") do c::Toolips.AbstractConnection
    # create SVG ball
    ball = Component{:circle}("maincirc", cy = 50, cx = 50, r = 5)
    style!(ball, "fill" => "blue", "transition" => 650ms)
    main_svg = svg("mainsvg", children = [ball])
    # SVG ball RPC callbacks
    on(c, ball, "click") do cm::ComponentModifier
        cm[ball] = "r" => 15
        style!(cm, "maincirc", "fill" => "green")
        # calls to all clients (including current client)
        rpc!(c, cm)
    end
    on(c, ball, "dblclick") do cm::ComponentModifier
        style!(cm, ball, "fill" => "blue")
        cm[ball] = "cy" => 5
        # calls on all other clients (not the source client, or 'clicker')
        call!(c, cm)
        # call a specific client with call!(::AbstractConnection, ::ComponentModifier, ::String)
    end
    # Connect clients to RPC
    session_key::String = ToolipsSession.get_session_key(c)
    if ~(haskey(c.data, :act))
        open_rpc!(c)
        # we provide the session key to `join_rpc!`, so we will need to store it.
        push!(c.data, :act => session_key)
    elseif session_key == c[:act]
        open_rpc!(c)
    else
        join_rpc!(c, c[:act])
    end
    write!(c, body("rpcbod", children = [main_svg]))
end
```