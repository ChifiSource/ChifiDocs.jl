module ChifiDocs
using Toolips
using Toolips.Components
import Toolips: on_start
import Base: getindex
using ToolipsSession

# extensions
logger = Toolips.Logger()
session = Session(["/"])

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

mutable struct ClientDocLoader <: Toolips.AbstractExtension
    docsystems::Vector{DocSystem}
    client_keys::Dict{String, String}
    clients::Vector{DocClient}
    pages::Vector{AbstractComponent}
    ClientDocLoader(docsystems::Vector{DocSystem}) = begin
        pages::Vector{AbstractComponent} = Vector{AbstractComponent}([generate_menu(doc_systems)])
        new(docsystems, Dict{String, String}(), Vector{DocClient}(), pages)::ClientDocLoader
    end
end

tl_docmods = Vector{DocModule}()

push!(tl_docmods, DocModule(Toolips, Vector{Component{<:Any}}(), "public/toolips"))

doc_systems = Vector{DocSystem}()

push!(doc_systems, DocSystem("toolips", "#79B7CE", tl_docmods))

function on_start(ext::ClientDocLoader, data::Dict{Symbol, <:Any}, routes::Vector{<:AbstractRoute})
    push!(data, :doc => ext)
end

function generate_menu(mods::Vector{DocSystem})
    menuholder::Component{:div} = div("mainmenu", align = "center", 
    children = [begin
        mdiv = a(string(menu_mod.name) * "eco", text = "$(menu_mod.name)")
        style!(mdiv, "background-color" => menu_mod.color, 
        "color" => "white", "font-size" => 14pt, "padding" => 10px)
        mdiv::Component{:a}
    end for menu_mod in mods])
    menuholder::Component{:div}
end

function generate_tabbar(client::DocClient)
    tabholder::Component{:div} = div("tabs", align = "center", 
    children = [begin
        taba = a("tab$(tab.name)", text = "$(tab.name)")
        style!(taba, "padding" => 10px, "font-size" => 13pt, "font-weight" => "bold", 
        "color" => "#333333", "background-color" => "lightgray")
        taba
    end for (e, tab) in enumerate(client.tabs)])
    style!(tabholder[:children][1], "border-bottom" => "2px solid pink", "background-color" => "white")
    tabholder::Component{:div}
end

function home(c::Toolips.AbstractConnection)
    # verify incoming client
    client_keys = c[:doc].client_keys
    ip = get_ip(c)
    if ~(ip in keys(client_keys))
        key::String = Toolips.gen_ref(4)
        push!(client_keys, ip => key)
        push!(c[:doc].clients, DocClient(key, [div("maintab", text = "hello world")]))
    end
    key = client_keys[ip]
    client::DocClient = c[:doc].clients[key]
    # build the page
    pages = c[:doc].pages
    tabbar = generate_tabbar(client)
    mainbody::Component{:body} = body("main")
    style!(mainbody, "background-color" => "#333333")
    push!(mainbody, pages["mainmenu"], tabbar)
    write!(c, mainbody)
end

main = route(home, "/")
docloader = ClientDocLoader(doc_systems)
# make sure to export!
export main, default_404, logger, session, docloader
end # - module ChifiDocs <3