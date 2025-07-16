struct ToolipsApp
    route::Toolips.Route{<:Any}
    name::String
    description::String
end

include("toolipsapp/app main.jl")
include("toolipsapp/emmy's app.jl")

TOOLIPS_APPS = CarouselArray([ToolipsApp(toolipsapp_main, "app main", "A simple landing page app for toolips app."), 
    ToolipsApp(EmmysApp.main, "emmy's app", "A simple Toolips + ToolipsSession 'number-guesser' sample app.")])

toolips_app = route("/toolips/app") do c::Connection
    tl_topbar = style("a.topbar", "color" => "white", "font-weight" => "bold", "cursor" => "pointer", "border-left" => "3px solid #36223d", 
        "font-weight" => "bold", "font-size" => 25pt, "padding" => 2percent, "transition" => 750ms)
    tl_topbar:"hover":["transform" => scale(1.01), "border-left" => "6px solid #7d3f91"]
    tlapp_img = img(src = "/images/toolipsapp.png", width = 3percent)
    tlapp_wrap = a("tlappwrap", children = [tlapp_img])
    back_wrap = a("backwrap", text = "<", onclick = "location.href='/'", class = "topbar")
    srclnk = a("srclnk", text = "source", class = "topbar")
    style!(tlapp_wrap, "padding" => 1percent)
    topbar = div("topbar", align = "left", children = [back_wrap, tlapp_wrap, srclnk])
    style!(topbar, "position" => "absolute", "top" => 0percent, "left" => 0percent, "background-color" => "#432f61", "width" => 100percent, "display" => "inline-block", 
        "height" => 3percent, "overflow" => "hidden")
    gallery = build_app_window(c, 1)
    meta = title(text = "toolips app !")
    main_body = body("tlapp", children = [meta, tl_topbar, topbar, gallery])
    style!(main_body, "overflow" => "hidden")
    write!(c, main_body)
end

function build_app_frame(position::Integer)
    app = TOOLIPS_APPS[position]
    new_frame = iframe("mainframe", src = app.route.path, width = 95percent, height = 80percent)
    style!(new_frame, "display" => "inline-block")
    new_frame
end
function build_app_window(c::AbstractConnection, position::Integer)
    new_frame = build_app_frame(position)
    butt_left = span("tlback", text = "<")
    butt_right = span("tlfor", text = ">")
    s = ("width" => 1percent, "color" => "white", "font-weight" => "bold", "font-size" => 25pt, 
        "background-color" => "#2b3c8f", "z-index" => -4, "padding" => 1.1percent, "cursor" => "pointer", 
        "display" => "inline-block")
    style!(butt_left, s ...)
    style!(butt_right, s ...)
    on(c, butt_left, "click") do cm::ComponentModifier
        curr_pos = parse(Int64, cm["gallery"]["position"])
        curr_pos -= 1
        cm["gallery"] = "position" => string(curr_pos)
        new_win = build_app_frame(curr_pos)
        remove!(cm, "mainframe")
        append!(cm, "gallery", new_win)
        app = TOOLIPS_APPS[curr_pos]
        set_text!(cm, "appnameh", app.name)
        set_text!(cm, "appdesc", app.description)
    end
    on(c, butt_right, "click") do cm::ComponentModifier
        curr_pos = parse(Int64, cm["gallery"]["position"])
        curr_pos += 1
        cm["gallery"] = "position" => string(curr_pos)
        new_win = build_app_frame(curr_pos)
        remove!(cm, "mainframe")
        append!(cm, "gallery", new_win)
        app = TOOLIPS_APPS[curr_pos]
        set_text!(cm, "appnameh", app.name)
        set_text!(cm, "appdesc", app.description)
    end
    app = TOOLIPS_APPS[position]
    infoheader = h2("appnameh", text = app.name, style = "color:white;")
    infodesc = p("appdesc", text = app.description, style = "color:white;")
    infobox = div("infob", children = [butt_left, butt_right, infoheader, infodesc])
    gallery = div("gallery", children = [infobox, new_frame], align = "center", position = position)
    style!(gallery, "position" => "absolute", "width" => 100percent, "height" => 97percent, "top" => 3percent, "left" => 0percent, 
        "background-color" => "#2a272b", "border-top" => "5px solid #36223d")
    gallery::Component{:div}
end

function build_app_source(position::Integer)

end