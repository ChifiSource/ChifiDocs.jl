mutable struct DocModule
    mod::Module
    pages::Vector{Component{<:Any}}
    mdpath::String
end

mutable struct DocSystem
    name::String
    color::String
    modules::Vector{DocModule}
end

abstract type AbstractDocClient end

mutable struct DocClient <: AbstractDocClient
    key::String
    tabs::Vector{Component{<:Any}}
end

getindex(dc::Vector{<:AbstractDocClient}, ref::String) = begin
    pos = findfirst(cl::AbstractDocClient -> cl.key == ref, dc)
    if isnothing(pos)

    end
    dc[pos]::AbstractDocClient
end


