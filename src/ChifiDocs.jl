module ChifiDocs
using Toolips
using Toolips.Components
using ToolipsSession

# extensions
logger = Toolips.Logger()
session = Session(["/"])

mutable struct DocModule
    mod::Module
    color::String
    path::String
    names::Dict{String, Component{<:Any}}
    DocModule(mod::Module, color::String, path::String) = begin
        names = Dict{String, Component{<:Any}}()
        new(mod, color, path, names)
    end
end

function generate_menu(mods::Vector{DocModule})
    menuholder = div("mainmenu", align = "center", 
    children = [begin
        mdiv = div(string(menu_mod.mod), text = "$(menu_mod.mod)")
        style!(mdiv, "background-color" => menu_mod.color, 
        "color" => "white", "font-size" => 14pt, "padding" => 10px)
        mdiv
    end for menu_mod in mods])
    style!(menuholder, "display" => "inline-block")
    menuholder::Component{:div}
end

abstract type AbstractDocClient end

mutable struct DocClient <: AbstractDocClient
    key::String
    tabs::Pair{String, Component{<:Any}}
end

getindex(dc::Vector{<:AbstractDocClient}, ref::String) = begin
    findfirst(cl::AbstractDocClient -> cl.key == ref, dc)
end

mutable struct ClientDocLoader <: Toolips.AbstractExtension
    docmods::Vector{DocModule}
    client_keys::Dict{String, String}
    clients::Vector{DocClient}
    pages::Vector{AbstractComponent}
end


function generate_tabbar(c::Toolips.AbstractConnection)
    clients = c[:ClientDocLoader].clients
    
end


doc_mods = Vector{DocModule}()

push!(doc_mods, DocModule(Toolips, "#333333", "public/toolips"))
hover_styles = ("border-radius" => 2px, "border" => "1px solid #333333", 
"position" => "absolute", "z-index" => 5, "background-color" => "white")


menu = generate_menu(doc_mods)



function home(c::Toolips.AbstractConnection)
    write!(c, menu)
end

main = route(home, "/")

# make sure to export!
export main, default_404, logger, session
end # - module ChifiDocs <3