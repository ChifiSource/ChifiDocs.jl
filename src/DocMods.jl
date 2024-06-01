abstract type DocServable end

mutable struct DocModule <: DocServable
    name::String
    color::String
    pages::Vector{Component{<:Any}}
    projectpath::String
end

mutable struct DocSystem <: DocServable
    name::String
    modules::Vector{DocModule}
    ecodata::Dict{String, Any}
end

getindex(dc::Vector{<:DocServable}, ref::String) = begin
    pos = findfirst(cl::DocServable -> cl.name == ref, dc)
    if isnothing(pos)
        throw("$ref was not in here")
    end
    dc[pos]::DocServable
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

function read_doc_config(path::String, mod::Module = Main)
    data = TOML.parse(read(path, String))
    docsystems::Vector{DocSystem} = Vector{DocSystem}()
    for ecosystem in data
        ecodata = ecosystem[2]
        name = ecosystem[1]
        mods = Vector{DocModule}(filter(k -> ~(isnothing(k)), [begin
            docmod_from_data(dct[1], dct[2], mod, path)
        end for dct in filter(k -> typeof(k[2]) <: AbstractDict, ecodata)]))
        push!(docsystems, 
        DocSystem(name, mods, Dict{String, Any}(ecodata)))
    end
    docsystems::Vector{DocSystem}
end

function docmod_from_data(name::String, dct_data::Dict{String, <:Any}, mod::Module, path::String)
    data_keys = keys(dct_data)
    if ~("color" in data_keys)
        push!(dct_data, "color" => "lightgray")
    end
    if ~("path" in data_keys)
        @warn "$name has no path, skipping"
        return(nothing)::Nothing
    end
    pages = Vector{Component{<:Any}}()
    path::String = split(path, "/")[1] * "/modules/" * dct_data["path"]
    if "pages" in data_keys
        dpages = dct_data["pages"]
        pages = [begin
            tmd(string(dpages[n - 1]), read(path * "/" * dpages[n], String))
        end for n in range(2, length(dpages), step = 2)]
    end
    DocModule(name, dct_data["color"], 
        pages, path)
end