## the auth extension
If all of these features still weren't enough, `ToolipsSession` also includes an API for basic authentication using the `Auth` `ServerExtension`. This extension is loaded with a vector of `AbstractClient`, usually of type `Client`. This will send an `AuthenticatedConnection`, a type of `Toolips.IOConnection` into authenticated routes. We use multi-route to handle authenticated and non-authenticated clients differently.
## authenticating clients
Authorization with `Auth` revolves around three different functions:
- `authorize!` for authorizing clients to enter the `AuthenticatedConnection` binding.
- `auth_redirect!` for redirectng authenticated users with their authenticated session key,
- and `auth_pass!` for passing a newly authenticated client straight to the authorized web-page.
```julia
module AuthServer
using Toolips
using Toolips.Components
using ToolipsSession

session = Session()
auth = Auth()

main_land = route("/") do c::AbstractConnection
    mainbody = body("main", children = [h2(text = "you are not authenticated")])
    authbutton = button("auth-button", text = "press to authenticate")
    on(c, authbutton, "click") do cm::ComponentModifier
        authorize!(c)
        # by default redirects to `/`.
        auth_redirect!(c, cm)
    end
    push!(mainbody, authbutton)
    write!(c, mainbody)
end

main_auth = route("/") do c::AuthenticatedConnection
    write!(c, "you have been authenticated")
end

main = route(main_land, main_auth)

export main, session, auth
end
```
This is helpful for easily separating logged clients and non-logged clients, and also can help to serve as one (ideally, of many,) buffers against high-request attacks (rejecting connections to reduce network traffic.)


