abstract type DocServable end

mutable struct DocModule <: DocServable
    name::String
    color::String
    pages::Vector{Component{<:Any}}
    projectpath::String
end

mutable struct DocSystem <: DocServable
    name::String
    color::String
    txtcolor::String
    modules::Vector{DocModule}
end

getindex(dc::Vector{<:DocServable}, ref::String) = begin
    pos = findfirst(cl::DocServable -> cl.name == ref, dc)
    if isnothing(pos)
        @info ref
        @info [doc.name for doc in dc]
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
            docmod_from_data(dct[1], dct[2], mod)
        end for dct in filter(k -> typeof(k[2]) <: AbstractDict, ecodata)]))
        push!(docsystems, 
        DocSystem(ecosystem[1], ecodata["color"], ecodata["txtcolor"], mods))
    end
    docsystems::Vector{DocSystem}
end

function docmod_from_data(name::String, dct_data::Dict{String, <:Any}, mod::Module)
    data_keys = keys(dct_data)
    if ~("color" in data_keys)
        push!(dct_data, "color" => "lightgray")
    end
    if ~("path" in data_keys)
        @warn "$name has no path, skipping"
        return(nothing)::Nothing
    end
    pages = Vector{Component{<:Any}}()
    if "pages" in data_keys
        dpages = dct_data["pages"]
        pages = [begin 
            div(string(n), text = dpages[n - 1])
        end for n in range(2, length(dpages), step = 2)]
    end
    DocModule(name, dct_data["color"], 
        pages, dct_data["path"])
end