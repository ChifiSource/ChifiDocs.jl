module ChifiDocs
using Toolips
using Toolips.Components
import Toolips: on_start
import Base: getindex
using ToolipsSession

# extensions
logger = Toolips.Logger()
session = Session(["/"])

include("DocMods.jl")

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

function on_start(ext::ClientDocLoader, data::Dict{Symbol, <:Any}, routes::Vector{<:AbstractRoute})
    push!(data, :doc => ext)
end

tl_docmods = Vector{DocModule}()

push!(tl_docmods, DocModule(Toolips, Vector{Component{<:Any}}(), "public/toolips"))

doc_systems = Vector{DocSystem}()

push!(doc_systems, DocSystem("toolips", "#79B7CE", tl_docmods))


function generate_menu(mods::Vector{DocSystem})
    menuholder::Component{:div} = div("mainmenu", align = "center", 
    children = [begin
        mdiv = a(string(menu_mod.name) * "eco", text = "$(menu_mod.name)")
        style!(mdiv, "background-color" => menu_mod.color, 
        "color" => "white", "font-size" => 20pt, "padding" => 14px, "font-weight" => "bold")
        mdiv::Component{:a}
    end for menu_mod in mods])
    style!(menuholder, "position" => "absolute", "top" => -100, "left" => 0, "width" => 100percent, "height" => 0px, 
    "transition" => 800ms)
    menuholder::Component{:div}
end

function generate_tabbar(client::DocClient)
    tabholder::Component{:div} = div("tabs", align = "left",
    children = [begin
        taba = a("tab$(tab.name)", text = "$(tab.name)")
        style!(taba, "padding" => 10px, "font-size" => 13pt, "font-weight" => "bold", 
        "color" => "#333333", "background-color" => "lightgray", "cursor" => "pointer", 
        "border-bottom" => "1px solid #333333", "border-right" => "1px solid #333333")
        taba
    end for (e, tab) in enumerate(client.tabs)])
    childs = tabholder[:children]
    style!(childs[1], "background-color" => "white", "border-bottom" => "0px", 
    "border-top-left-radius" => 10px)
    style!(childs[length(childs)], "border-top-right-radius" => 10px)
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
    mainbody::Component{:body} = body("main", align = "center")
    style!(mainbody, "margin-left" => 5percent, "margin-top" => 5percent, "background-color" => "#333333", "display" => "flex", 
    "transition" => 1s)
    main_container::Component{:div} = div("main-container")
    style!(main_container, "height" => 80percent, "width" => 75percent, "background-color" => "white", "padding" => 0px, "display" => "flex", "flex-direction" => "column", 
    "border-bottom-right-radius" => 5px, "border-top-right-radius" => 5px, "border" => "2px solid #211f1f", "border-left" => "none", "border-top" => "none")
    main_window::Component{:div} = div("main_window")
    tabbar = generate_tabbar(client)
    style!(tabbar, "width" => 50percent)
    push!(main_container, tabbar, main_window)
    left_menu::Component{:div} = div("left_menu")
    style!(left_menu, "width" => 20percent, "height" => 80percent, "background-color" => "darkgray", "border-bottom-left-radius" => 5px, "border-top-left-radius" => 5px)
    hoverregion = div("menu_button")
    style!(hoverregion, "position" => "absolute", "top" => 0, "left" => 0, "background" => "transparent", 
    "width" => 100percent, "height" => 10percent, "z-index" => -1, "transition" => 1s)
    on(c, hoverregion, "mouseenter") do cm::ComponentModifier
        style!(cm, "mainmenu", "top" => 10)
        style!(cm, "main", "margin-top" => 7percent)
    end
    push!(mainbody, pages["mainmenu"], hoverregion, left_menu, main_container)
    write!(c, mainbody)
end

main = route(home, "/")
docloader = ClientDocLoader(doc_systems)
# make sure to export!
export main, default_404, logger, session, docloader
end # - module ChifiDocs <3