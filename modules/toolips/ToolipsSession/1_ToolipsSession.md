## fullstack
`ToolipsSession` provides [Toolips](/toolips/Toolips) with **fullstack** web-development capabilities (live calls to the server back and forth from the client on a single page,) through the `Session` extension. This is considered to be the *quintessential* `Toolips` extension, as it was created alongside `Toolips` and helped to shape the framework itself. `ToolipsSession` provides a simple call-back style API based on the [ClientModifier](/toolips/ToolipsServables#client-modifier-callbacks) API from [ToolipsServables](/toolips/ToolipsServables). This is mainly facilitated through new dispatches to `on`, `bind`, and the `ComponentModifier`.
```julia
module FullStackServer
using Toolips
using Toolips.Components
using ToolipsSession

SESSION = ToolipsSession.Session()

home = route("/") do c::AbstractConnection
    name_input = Components.textdiv("namebox", text = "enter your name for a greeting", align = "left")
    style!(name_input, "display" => "inline-block", "padding" => 7px, "background-color" => "white", "color" => "#1e3ddd", 
    "border-style" => "solid", "border-width" => 2px, "border-color" => "#1e1e1e", "width" => 80percent)
    # ToolipsSession `on` binding (includes `Connection`):
    on(c, name_input, "focus") do cm::ComponentModifier
            # indexing `ComponentModifier`
        if contains(cm[name_input]["text"], " ")
            set_text!(cm, name_input, "")
        end
    end
    # defining multi-use `ComponentModifier` Function:
    function generate_namepage(cm::ComponentModifier)
        # Component already on page? An easy check for that:
        if "namepage" in cm
            return
        end
        closebutton = button("close", text = "close")
        # non-Session event (`ClientModifier`, no `Connection` provided.) Evaluated as soon as its called, 
        #                  is only a client-side callback
        on(closebutton, "click") do cl::ClientModifier
            remove!(cl, "namepage")
        end
        #  we can also reference components by name
        # properties will always be a `String`, and can be parsed into values in callbacks.
        name::String = cm["namebox"]["text"]
        closebar = div("-", align = "right", children = [closebutton])

        namegreeter = h2(text = name)
        name_sub = p(text = "what a pretty name you have!")

        namepage = div("namepage", children = [closebar, namegreeter, name_sub])
        style!(namepage, "position" => "absolute", "top" => 0percent, "width" => 70percent, "height" => 0percent, "opacity" => 0percent, 
        "transition" => 800ms, "padding" => 10percent)
        append!(cm, "mainbody", namepage)
        on(cm, 600) do cl::ClientModifier
            style!(cl, "namepage", "height" => 100percent, "opacity" => 100percent)
        end
    end

    # ToolipsSession `bind` binding:
    ToolipsSession.bind(generate_namepage, c, name_input, "Enter", prevent_default = true)
    confirm_button = button("conf", text = "confirm")
    # duplicated binding :)
    on(generate_namepage, c, confirm_button, "click")
    style!(confirm_button, "background-color" => "#333333", "padding" => 7px, "border" => "2px solid #1e1e1e", 
    "color" => "white")

    content_box = div("contentbox", align = "center", children = [name_input, confirm_button])
    style!(content_box, "padding" => 30percent, "margin-top" => 5percent)
    main_body = body("mainbody", children = [content_box])
    write!(c, main_body)
end

export SESSION, home
end
```
- Note that `Session` requires a `Toolips` (HTTP) server to run.
## loading session
In order to use bind callback events to pages, we are first going to need to load the `Session` extension into our `Toolips` server. The main thing the `Session` extension does is write server information on the client for communcation on pages it is active. This is important, because it means that `Session` needs to delineate what what pages to write this to -- we don't want `Session` writing this on a page where we are meant to serve files. For this reason, we must provide `active_routes` when creating `Session`. We are able to actively change these routes, or invert `Session` behavior so that the `active_routes` become `inactive_routes`, but generally we will need to put all of our target paths into `active_routes`. We start by creating and exporting `Session` in our `Module`, optionally with a list of `active_routes` or key-word arguments. By default, the `active_routes` will be `["/"]`. These may also be inverted using a key-word argument.
```julia
module SessionMin
using Toolips
using Toolips.Components
using ToolipsSession

SESSION = ToolipsSession.Session(["/", "/forum"])

export SESSION
end
```
- The `timeout` binding is an `Integer` representing how many minutes we wait before deleting a client's active events. By default, this is 10 minutes.

From here, we add `Events`, sub-types of `AbstractEvent` that are normally a regular `Event`, these events are added using the `on` and `bind` functions, amongst other options. 
Each of the following functions can be used to register an event in different ways (click to view function documentation).
- `on`
- `bind`
- `next!`

`ToolipsSession` comes with only a couple event types, the most common is the regular `Event`. Here is a comprehensive list:
- `Event`
- `RPCEvent` (abstract)
- `RPCClient`
- and `RPCHost`.

Events are routed by `Session` to the callbacks on your web-page, the callbacks are registered an ID along with your response. The events are then called using `call!`. This isn't always done with the `register!` function, but most often this is the case. `ToolipsSession` also provides a binding to `kill!` (`kill!(c::AbstractConnection)`) which will remove a user's events from the current session. There is also `clear!`, which will **only remove the client's events** -- not deleting them from the IP table. Beyond this, most of `ToolipsSession` usage will remain in the high-level `on` and `bind` functions.

