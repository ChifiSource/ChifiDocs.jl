## files
Alongside the `Component` templating interface, `ToolipsServables` also includes the `File` `Servable`. The `File` servable is a **parametric** type that allows us to quickly write files to streams with file-specific `Method` bindings. To create a `File`, we simply provide a path as a `String`. From here, calling `string` on that file will give us a servable version of the file read into memory.
```julia
my_file = File("my/samplefile.txt")

# (File{:txt})

string(my_file)
```
The parametric typing is useful here, as we can change how our app behaves with different files.
```julia
scan_file(f::File{:html}) = begin

end

scan_file(f::File{:css}) = begin

end
```
## interpolation
With this basic file functionality also comes some interpolation tools for components, files, and combinations of the two. This is exclusively handled using the `interpolate!` and `interpolate!` functions. When interpolating files we use the `interpolate` binding. Our file should have component names and argument names with a `$` before them.`interpolate!` is used for components and allows us to interpolate `code` tags within a `Component{:div}` -- this is created almost exclusively for markdown interpolation with the `tmd` `Component`.


