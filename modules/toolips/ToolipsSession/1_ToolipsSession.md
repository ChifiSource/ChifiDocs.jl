## fullstack
`ToolipsSession` provides [Toolips](/toolips/Toolips) with **fullstack** web-development capabilities (live calls to the server back and forth from the client on a single page,) through the `Session` extension. This is considered to be the *quintessential* `Toolips` extension, as it was created alongside `Toolips` and helped to shape the framework itself. `ToolipsSession` provides a simple call-back style API based on the [ClientModifier](/toolips/ToolipsServables#client-modifier-callbacks) API from [ToolipsServables](/toolips/ToolipsServables). This is mainly facilitated through new dispatches to `on`, `bind`, and the `ComponentModifier`.
```julia
```
- Note that `Session` requires a `Toolips` (HTTP) server to run.
## loading session
In order to use bind callback events to pages, we are first going to need to load the `Session` extension into our `Toolips` server. The main thing the `Session` extension does is write server information on the client for communcation on pages it is active. This is important, because it means that `Session` needs to delineate what what pages to write this to -- we don't want `Session` writing this on a page where we are meant to serve files. For this reason, we must provide `active_routes` when creating `Session`. We are able to actively change these routes, or invert `Session` behavior so that the `active_routes` become `inactive_routes`, but generally we will need to put all of our target paths into `active_routes`. We start by creating and exporting `Session` in our `Module`, optionally with a list of `active_routes` or key-word arguments.
```julia

```
