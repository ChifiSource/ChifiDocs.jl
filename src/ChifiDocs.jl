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

function on_start(ext::ClientDocLoader, data::Dict{Symbol, Any}, routes::Vector{<:AbstractRoute})
    ss = make_stylesheet()
    push!(ext.pages, ss)
    push!(data, :doc => ext)
end

function generate_menu(mods::Vector{DocSystem})
    menuholder::Component{:div} = div("mainmenu", align = "center", 
    children = [begin
        mdiv = div(string(menu_mod.name) * "eco", text = "$(menu_mod.name)")
        style!(mdiv, "background-color" => menu_mod.color, 
        "color" => "white", "font-size" => 20pt, "padding" => 14px, "font-weight" => "bold")
        mdiv::Component{:div}
    end for menu_mod in mods])
    style!(menuholder, "width" => 0percent)
    menuholder::Component{:div}
end

function switch_tabs!(c::AbstractConnection, cm::ComponentModifier, t::String)
    
end

function make_stylesheet()
    tabs = ("padding" => 10px, "font-size" => 13pt, "font-weight" => "bold", 
    "color" => "#333333", "border-top" => "1px solid #333333", "border-right" => "1px solid #333333")
    tab_active = Style("div.tabactive",  "background-color" => "white", tabs ...)
    tab_inactive = Style("div.tabinactive", "background-color" => "lightgray", "cursor" => "pointer", 
    "border-bottom" => "1px solid #333333", tabs ...)
    tab_x = ("font-size" => 14pt, "border-radius" => 3px, "padding" => 4px, "margin-left" => 4px)
    tab_x_active = Style("a.tabxactive", "color" => "white", "background-color" => "darkred", tab_x ...)
    tab_x_inactive = Style("a.tabinactive", "color" => "#333333", "background-color" => "lightgray", tab_x ...)
    left_menu_elements = Style("div.menuitem")
    main_menus = Style("div.mainmenu")
    sheet = Component{:stylesheet}("styles")
    sheet[:children] = Vector{AbstractComponent}([tab_active, tab_inactive, tab_x_active, tab_x_inactive])
    sheet::Component{:stylesheet}
end

function generate_tabbar(c::AbstractConnection, client::DocClient)
    n::Int16 = Int16(length(client.tabs))
    tabholder::Component{:div} = div("tabs", align = "left")
    [begin
        labelname = join(split(tab.name, "-")[2:3], " | ")
        tablabel = a("labeltab$(tab.name)", text = "$labelname")
        closetab = a("closetab$(tab.name)", text = "x", class = "tabxinactive")
        taba = div("tab$(tab.name)", class = "tabinactive")
        style!(taba, "display" => "inline-block")
        push!(taba, tablabel, closetab)
        on(c, taba, "click") do cm::ComponentModifier
            switch_tabs!(c, cm, tab.name)
        end
        if e == 1
            closetab[:class] = "tabxactive"
            taba[:class] = "tabactive"
        end
        if e == n
            style!(taba, "border-top-right-radius" => 10px)
        end
        push!(tabholder, taba)
    end for (e, tab) in enumerate(client.tabs)]
    style!(tabholder, "width" => 50percent)
    return(tabholder, client.tabs[1].name)
end

function build_main(c::AbstractConnection, client::DocClient)
    tabbar, docname = generate_tabbar(c, client)
    main_window = div("main_window", align = "left")
    push!(main_window, get_docpage(c, docname))
    style!(main_window, "background-color" => "white", "height" => 100percent, "padding" => 10px)
    main_container::Component{:div} = div("main-container", children = [tabbar, main_window])
    style!(main_container, "height" => 80percent, "width" => 75percent, "background-color" => "lightgray", "padding" => 0px, "display" => "flex", "flex-direction" => "column", 
    "border-bottom-right-radius" => 5px, "border-top-right-radius" => 5px, "border" => "2px solid #211f1f", "border-left" => "none", "border-top" => "none")
    return(main_container::Component{:div}, docname)
end

function get_docpage(c::AbstractConnection, name::String)
    ecopage::Vector{SubString} = split(name, "-")
    c[:doc].docsystems[string(ecopage[1])].modules[string(ecopage[3])].pages[string(ecopage[2])]::Component{<:Any}
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
        push!(c[:doc].clients, DocClient(key, [div("chifi-welcome-ChifiDocs")]))
    end
    key = client_keys[ip]
    client::DocClient = c[:doc].clients[key]
    # build the page
    pages = c[:doc].pages
    write!(c, pages["styles"])
    mainbody::Component{:body} = body("main", align = "center")
    style!(mainbody, "margin-left" => 5percent, "margin-top" => 5percent, "background-color" => "#333333", "display" => "flex", 
    "transition" => 1s)
    main_container::Component{:div}, mod::String = build_main(c, client)
    ecopage = split(mod, "-")
    loaded_page = c[:doc].docsystems[string(ecopage[1])].modules[string(ecopage[3])]
    left_menu = build_leftmenu(c, loaded_page)
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