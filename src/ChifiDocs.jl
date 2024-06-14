#== components.jl
`components.jl` is a special source file (specific to this project and loaded in dev.jl) 
which allows us to build custom components into our markdown documentation pages and load dependencies to use in our documentation pages..
Make sure to only export components, interpolate by name into markdown using $, and in Julia using `interpolate!` or `interpolate_code!`.
`$`.
==#
"""
#### ChifiDocs !
chifi docs is a documentation site for `chifi` software created using `Documator`, a 
    documentation website generator powered by the `Toolips` web-development framework.

"""
module ChifiDocs
using Toolips
using ChifiDocs
using ToolipsSession
using Gattino

"""
#### chifi !
##### an open source software dynasty
"""
function chifi end

"""
---
## chifi 'End-User License-Agreement'
---
"""
function EULA end

"""
### this sample was retrieved!
"""
function sample end
export ChifiDocs, sample, Toolips, chifi, EULA
end