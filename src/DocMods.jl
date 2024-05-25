mutable struct DocModule
    mod::Module
    color::String
    pages::Vector{Component{<:Any}}
    projectpath::String
end

mutable struct DocSystem
    name::String
    color::String
    txtcolor::String
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

function read_doc_config(path::String, mod::Module = Main)
    data = TOML.parse(read(path, String))
    docsystems::Vector{DocSystem} = Vector{DocSystem}()
    for ecosystem in data
        ecodata = ecosystem[2]
        name = ecosystem[1]
        mods = [begin 
            dct_data = dct[2]
            dpages = dct_data["pages"]
            pages = [begin 
                div(string(n), text = dpages[n - 1])
            end for n in range(2, length(dpages), step = 2)]
            @info pages
            DocModule(getfield(mod, Symbol(dct[1])), dct_data["color"], 
            pages, dct_data["path"])
        end for dct in filter(k -> typeof(k[2]) <: AbstractDict, ecodata)]
        push!(docsystems, 
        DocSystem(ecosystem[1], ecodata["color"], ecodata["txtcolor"], mods))
    end
    docsystems::Vector{DocSystem}
end

