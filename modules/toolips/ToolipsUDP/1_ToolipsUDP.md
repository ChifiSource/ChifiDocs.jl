## UDP Servers
Something we likely wouldn't expect [Toolips](/toolips/Toolips) (a web-development framework) to support is UDP -- a connection-less, speed-prioritizing data-transmission protocol that has *little* applications in web-development. However, there are server solutions that *require* UDP or are better served by UDP -- for example, DNS servers will likely be a lot faster if they are UDP. If we wanted to make a complex, customized system for a massively online video-game, `Toolips` can do it using this extension, `ToolipsUDP`. And for those applications we will not need to learn a new framework but only a UDP extension!
```julia
using Pkg; Pkg.add("ToolipsUDP")
```
Like regular `Toolips`, `ToolipsUDP` uses modules as servers and servers may be started with `start!`. However, we will need to provide the `Symbol` `UDP` to `start!`, and in place of HTTP **routes** we have **handlers**.
```julia
module NewServer
using ToolipsUDP

new_handler = handler() do c::UDPConnection
    respond!(c, "hello")
end

export new_handler, start!, UDP
end

using NewServer; start!(UDP, NewServer)
```
- `ToolipsUDP` also includes a similar binding for `new_app` that takes `:UDP` as an argument.
## handlers
An `AbstractUDPHandler` is the UDP equivalent of the `AbstractRoute`. These objects of these types will take our response functions, and will be exported from our server. `ToolipsUDP` includes the `UDPHandler` and the `NamedHandler`. Both of these are constructed via a convenient `handler` function. When provided a `String`, this will produce a `NamedHandler`. The `NamedHandler` allows us to set the handlers before finishing any given response, allowing for the next response to be in-line with the prior response's state. This is a convenience feature that implements a psuedo-routing system atop UDP servers.

```julia
module HandlerSample
using ToolipsUDP


main_handler = handler() do c::UDPConnection
    println("response 1")
    set_handler!(c, "second")
end

second_step = handler("second") do c::UDPConnection
    println("response 2")
    remove_handler!(c)
end

multi_handler = ToolipsUDP.MultiHandler(main_handler)

export multi_handler, start!, UDP
export main_handler, second_step
end

# this server will continuously switch between response 1 and response 2.
```

## responses
Our handler functions will be passed a `UDPConnection`, the `Connection` type for a `ToolipsUDP` server. This is a sub-type of `AbstractUDPConnection`, and behaves the same way as most other `AbstractConnection` sub-types other than not having an HTTP header.
- There is also the additional dispatch of `get_ip4` -- allowing us to get the port a user is connecting from.

Most of `ToolipsUDP` usage is incredibly similar to regular `Toolips` usage, but one area where things are quite different is in *the response*. Creating a response for a `UDP` application can be a bit more complex, and `ToolipsUDP` offers a few different functions in place of `write!` from `Toolips` for responding:
- `send` for sending data -- whether we have a server or want to create a new socket server there are numerous dispatches.
- `respond!` for sending data specifically to a client.

```julia
module HelloWorld
using ToolipsUDP

main_handler = handler() do c::UDPConnection
    println("new client sent us... " * c.packet)
end

export main_handler, UDP, start!
end

start!(UDP, HelloWorld, ip = "127.0.0.1":3001)
# take note of  how we test the app in this case:

using ToolipsUDP; send("hello friend", "127.0.0.1":3001)

# output: new client sent us... hello friend
```

This makes things relatively straightforward. `ToolipsUDP` also includes a `UDPIOConnection` for multi-threading support.
## toolips
An important thing to remember when using `ToolipsUDP` is that it is designed to mirror the `Toolips` experience as closely as possible. We have access to the regular `Toolips` functions on our `Connection`, such as `get_ip`. The only thing that changes is that we are no longer using HTTP.
## extensions
Like `Toolips`, `ToolipsUDP` has support for extensions. These extensions cover the same bases as the `Toolips` equivalents they are based on.
## multi-threading

