--
### routing
```docstrings
AbstractRoute
```
`Toolips` features a dynamic three-stage routing system that can change functionality using parametric polymorphism. Two main functions comprise this routing system, `route` and `route!`. `route` is called to create routes, whereas `route!` is called by the server and routes the incoming `Connection` to a `route`. A standard `Route` is created using the `route` function, which will take a `Function` as the first positional argument and a route as the second.
```julia
home = route("/") do c::Connection

end
```
The provided `Function` will take one positional argument, an `AbstractConnection`. A standard `Toolips` route will hold the `Connection` type in a type parameter. The call above will return a `Route{Connection}`. 
```docstrings
route
```



## the connection
A route will be passed a `Connection` whenever it is routed with `route!`. A `Connection` represents a client's entrance into the `Function` pipeline -- each time a request is made to the server. The `Connection` stores the server's routes in its `Connection.routes` field and the server's data in its `Connection.data` field. 
```docstrings
Connection
```
The most vital function in association with the `Connection` is `write!`, which is used to write data to the incoming `Connection` as a response. Note that `write!` is not `write`, as this is a mutating `write!` -- a write on a response *cannot* be reverted!
```docstrings
write!
```
There are also several *getter* methods associated with the `Connection`, which may be used to retrieve data:
```docstrings
get_args
get_ip
get_post
get_route
get_method
get_parent
```



## the response

## templating