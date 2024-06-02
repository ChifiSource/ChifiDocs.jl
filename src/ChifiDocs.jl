module ChifiDocs
using Toolips
using TOML
using Toolips.Components
import Toolips: on_start
import Base: getindex
using ToolipsSession
using OliveHighlighters

# extensions
logger = Toolips.Logger()
session = Session(["/"])

include("DocMods.jl")

mutable struct ClientDocLoader <: Toolips.AbstractExtension
    dir::String
    docsystems::Vector{DocSystem}
    client_keys::Dict{String, String}
    clients::Vector{DocClient}
    pages::Vector{AbstractComponent}
    ClientDocLoader(docsystems::Vector{DocSystem} = Vector{DocSystem}()) = begin
        pages::Vector{AbstractComponent} = Vector{AbstractComponent}()
        new("", docsystems, Dict{String, String}(), Vector{DocClient}(), pages)::ClientDocLoader
    end
end

function on_start(ext::ClientDocLoader, data::Dict{Symbol, Any}, routes::Vector{<:AbstractRoute})
    ss = make_stylesheet()
    push!(routes, mount("/" => "$(ext.dir)/public") ...)
    push!(ext.pages, ss, generate_menu(ext.docsystems))
    push!(data, :doc => ext)
end

function generate_menu(mods::Vector{DocSystem})
    menuholder::Component{:div} = div("mainmenu", align = "center", class = "mmenuholder", open = "none",
    children = [begin
        modname = menu_mod.name
        mdiv = div("$modname")
        preview_img = img("preview$modname", src = menu_mod.ecodata["icon"], width = 25px)
        style!(preview_img, "display" => "inline-block")
        label_a = a("label$modname", text = modname, class = "mainmenulabel")
        style!(mdiv, "background-color" => menu_mod.ecodata["color"], "overflow" => "hidden", 
        "padding-top" => 2px, "height" => 13percent, "transition" => 500ms)
        style!(label_a, "color" => menu_mod.ecodata["txtcolor"])
        push!(mdiv, preview_img, label_a)
        mdiv::Component{:div}
    end for menu_mod in mods])
    childs = menuholder[:children]
    style!(childs[1], "border-top-left-radius" => 3px)
    style!(childs[length(childs)], "border-bottom-left-radius" => 3px)
    menuholder::Component{:div}
end

function bind_menu!(c::AbstractConnection, menu::Component{:div})
    [begin
        econame::String = child.name
        on(c, child, "click") do cm::ComponentModifier
            opened::String = cm["mainmenu"]["open"]
            if opened == econame
                style!(cm, econame, "height" => 13percent)
                cm["mainmenu"] = "open" => "none"
                remove!(cm, "expandmenu")
                return
            elseif opened != "none"
                style!(cm, opened, "height" => 13percent)
                remove!(cm, "expandmenu")
            end
            style!(cm, econame, "height" => 80percent)
            cm["mainmenu"] = "open" => econame
            selected_system = c[:doc].docsystems[child.name]
            submenu = [begin
                    docn = docmod.name
                    menitem = div("men$docn")
                    style!(menitem, "cursor" => "pointer", "border-radius" => 2px, "background-color" => docmod.color, 
                    "border-left" => "3px solid $(selected_system.ecodata["color"])")
                    doclabel = div("doclabel", text = docn)
                    style!(doclabel, "padding" => 3px, "font-size" => 13pt, "color" => "white")
                    push!(menitem, doclabel)
                    on(c, menitem, "click") do cm::ComponentModifier
                        alert!(cm, "this will set the left menu elements, and open a new tab.")
                    end
                    menitem
            end for docmod in selected_system.modules]
            menuel = div("expandmenu", children = submenu)
            append!(cm, econame, menuel)
        end
    end for child in menu[:children]]
end

function switch_tabs!(c::AbstractConnection, cm::ComponentModifier, t::String)
    
end

function make_stylesheet()
    bttons = Style("button", "font-family" => "storycan")
    ico_font = Style("@font-face", "font-family" => "'storycan'", "src" => "url(/fonts/storycan-icons.ttf)")
    tabs = ("padding" => 10px, "font-size" => 13pt, "font-weight" => "bold", 
    "color" => "#333333", "border-top" => "1px solid #333333", "border-right" => "1px solid #333333")
    tab_active = Style("div.tabactive",  "background-color" => "white", tabs ...)
    tab_inactive = Style("div.tabinactive", "background-color" => "lightgray", "cursor" => "pointer", 
    "border-bottom" => "1px solid #333333", tabs ...)
    tab_x = ("font-size" => 14pt, "border-radius" => 3px, "padding" => 4px, "margin-left" => 4px)
    tab_x_active = Style("a.tabxactive", "color" => "white", "background-color" => "darkred", tab_x ...)
    tab_x_inactive = Style("a.tabinactive", "color" => "#333333", "background-color" => "lightgray", tab_x ...)
    left_menu_elements = Style("div.menuitem", "width" => 90percent, "border-bottom" => "2px solid #333333", 
    "margin-left" => 5percent, "padding" => 8px, "margin-top" => 20px)
    main_menus = Style("a.mainmenulabel", "font-size" => 18pt, "font-weight" => "bold", 
    "display" => "inline-block", "opacity" => 100percent, "transition" => 400ms)
    menu_holder = Style("div.mmenuholder", "width" => 8percent, "z-index" => 2, "transition" => 800ms, 
    "overflow" => "hidden", "height" => 80percent)
    menu_holder:"hover":["transform" => scale(1.1)]
    sheet = Component{:stylesheet}("styles")
    sheet[:children] = Vector{AbstractComponent}([tab_active, tab_inactive, tab_x_active, tab_x_inactive, 
    left_menu_elements, main_menus, menu_holder, ico_font, bttons])
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
    style!(main_window, "background-color" => "white", "height" => 100percent, "padding" => 30px)
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
    items = build_leftmenu_elements(c, mod)
    left_menu::Component{:div} = div("left_menu", children = items)
    style!(left_menu, "width" => 20percent, "height" => 80percent, "background-color" => "darkgray", "border-bottom-left-radius" => 5px, 
    "padding" => 15px)
    left_menu::Component{:div}
end

function build_leftmenu_elements(c::AbstractConnection, mod::DocModule)
    [begin 
        pagename = page.name
        openbutton = button("open-$pagename", text = "d")
        style!(openbutton, "border" => 0px, "border-radius" => 2px, "font-size" => 16pt, "background" => "transparent", 
        "color" => "#333333")
        labela = a("label-$pagename", text = replace(pagename, "-" => " "))
        style!(labela, "font-size" => 13pt, "font-weight" => "bold", "color" => "#333333")
        pagemenu = div("pagemenu-$pagename", align = "left", class = "menuitem")
        style!(pagemenu, "background-color" => mod.color)
        push!(pagemenu, labela, openbutton)
        pagemenu::Component{:div}
end for page in mod.pages]::Vector{<:AbstractComponent}
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
    style!(mainbody, "background-color" => "#333333")
    app_window::Component{:div} = div("app-window")
    style!(app_window, "margin-left" => .5percent, "margin-top" => 5percent, "background-color" => "#333333", "display" => "flex", 
    "transition" => 1s)
    main_container::Component{:div}, mod::String = build_main(c, client)
    ecopage = split(mod, "-")
    loaded_page = c[:doc].docsystems[string(ecopage[1])].modules[string(ecopage[3])]
    left_menu = build_leftmenu(c, loaded_page)
    main_menu = copy(pages["mainmenu"])
    bind_menu!(c, main_menu)
    push!(app_window, main_menu, left_menu, main_container)
    push!(mainbody, app_window)
    write!(c, mainbody)
end

docloader = ClientDocLoader()

function start_from_project(path::String = pwd(), mod::Module = Main; ip::Toolips.IP4 = "127.0.0.1":8000)
    docloader.dir = path
    docloader.docsystems = read_doc_config(path * "/config.toml", mod)
    start!(ChifiDocs, ip)
end

main = route(home, "/")
# make sure to export!
export main, default_404, logger, session, docloader
end # - module ChifiDocs <3