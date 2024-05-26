module ChifiDocs
using Toolips
using TOML
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
    ClientDocLoader(docsystems::Vector{DocSystem} = Vector{DocSystem}()) = begin
        pages::Vector{AbstractComponent} = Vector{AbstractComponent}([generate_menu(docsystems)])
        new(docsystems, Dict{String, String}(), Vector{DocClient}(), pages)::ClientDocLoader
    end
end

function on_start(ext::ClientDocLoader, data::Dict{Symbol, <:Any}, routes::Vector{<:AbstractRoute})
    push!(data, :doc => ext)
end

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

function generate_menu(dm::Vector{DocModule})
    
end

function switch_tabs!(c::AbstractConnection, cm::ComponentModifier, t::String)

end

function generate_tabbar(c::AbstractConnection, client::DocClient)
    tabholder::Component{:div} = div("tabs", align = "left",
    children = [begin
        taba = a("tab$(tab.name)", text = "$(tab.name)")
        style!(taba, "padding" => 10px, "font-size" => 13pt, "font-weight" => "bold", 
        "color" => "#333333", "background-color" => "lightgray", "cursor" => "pointer", 
        "border-bottom" => "1px solid #333333", "border-right" => "1px solid #333333")
        on(c, taba, "click") do cm::ComponentModifier
            switch_tabs!(c, cm, tab.name)
        end
        taba
    end for (e, tab) in enumerate(client.tabs)])
    childs = tabholder[:children]
    style!(tabholder, "width" => 50percent)
    style!(childs[1], "background-color" => "white", "border-bottom" => "0px", 
    "border-top-left-radius" => 10px)
    style!(childs[length(childs)], "border-top-right-radius" => 10px)
    return(tabholder, client.tabs[1].name)
end

function build_main(c::AbstractConnection, client::DocClient)
    tabbar, docname = generate_tabbar(c, client)
    main_container::Component{:div} = div("main-container", children = [tabbar, div("main_window")])
    style!(main_container, "height" => 80percent, "width" => 75percent, "background-color" => "white", "padding" => 0px, "display" => "flex", "flex-direction" => "column", 
    "border-bottom-right-radius" => 5px, "border-top-right-radius" => 5px, "border" => "2px solid #211f1f", "border-left" => "none", "border-top" => "none")
    return(main_container::Component{:div}, docname)
end

function build_leftmenu(c::AbstractConnection, mod::DocModule)
    [begin 
        pagename = page.name
        openbutton = button("open-$pagename", text = "open")
        labela = a("label-$pagename", text = replace(pagename, "-" => " "))
        pagemenu = div("pagemenu", text = "")
    end for page in mod.pages]
    left_menu::Component{:div} = div("left_menu")
    style!(left_menu, "width" => 20percent, "height" => 80percent, "background-color" => "darkgray", "border-bottom-left-radius" => 5px, "border-top-left-radius" => 5px)
    left_menu::Component{:div}
end

function home(c::Toolips.AbstractConnection)
    # verify incoming client
    client_keys::Dict{String, String} = c[:doc].client_keys
    ip::String = get_ip(c)
    if ~(ip in keys(client_keys))
        key::String = Toolips.gen_ref(4)
        push!(client_keys, ip => key)
        push!(c[:doc].clients, DocClient(key, [div("chifi-", text = "hello world")]))
    end
    key = client_keys[ip]
    client::DocClient = c[:doc].clients[key]
    # build the page
    pages = c[:doc].pages
    mainbody::Component{:body} = body("main", align = "center")
    style!(mainbody, "margin-left" => 5percent, "margin-top" => 5percent, "background-color" => "#333333", "display" => "flex", 
    "transition" => 1s)
    main_container::Component{:div}, mod::String = build_main(c, client)
    ecopage = split(mod, "-")
    @info ecopage
    @info [docmod.name for docmod in c[:doc].docsystems]
    @info [docmod.name for docmod in c[:doc].docsystems["toolips"].docmods]
    loaded_page = c[:doc].docsystems[string(ecopage[1])].modules[string(ecopage[2])]
    left_menu = build_leftmenu(c, mod)
    push!(mainbody, pages["mainmenu"], left_menu, main_container)
    write!(c, mainbody)
end
docloader = ClientDocLoader()

function start_from_project(path::String = pwd(), mod::Module = Main; ip::Toolips.IP4 = "127.0.0.1":8000)
    docloader.docsystems = read_doc_config(path * "/config.toml", mod)
    start!(ChifiDocs, ip)
end

main = route(home, "/")
# make sure to export!
export main, default_404, logger, session, docloader
end # - module ChifiDocs <3