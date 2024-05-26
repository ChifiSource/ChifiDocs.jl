#== components.jl
`components.jl` is a special source file which allows us to build 
custom components into our markdown documentation pages.
Make sure to only export components, interpolate by name into markdown using 
`$`.
==#
module ChifiDocComponents
using Toolips
using ToolipsSession
using Gattino
end