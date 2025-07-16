struct ToolipsApp
    route::Toolips.Route{<:Any}
    name::String
    description::String
end

include("toolipsapp/app main.jl")
include("toolipsapp/emmy's app.jl")

TOOLIPS_APPS = CarouselArray([ToolipsApp(toolipsapp_main, "app main.jl", "A simple `Toolips` landing page."), 
    ToolipsApp(EmmysApp.main, "emmy's app", "A simple Toolips + ToolipsSession 'number-guesser' sample app.")])

toolips_app = route("/toolips/app") do c::Connection
    position = 1
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
    new_frame = iframe("mainframe", src = TOOLIPS_APPS[position].route.path, width = 90percent, height = 90percent)

    gallery = div("gallery", children = new_frame)
    style!(gallery, "position" => "absolute", "width" => 100percent, "height" => 95percent, "padding" => 2percent, "top" => 3percent, "left" => 0percent, 
        "background-color" => "#2a272b", "border-top" => "5px solid #36223d")
    meta = title(text = "toolips app !")
    main_body = body("tlapp", children = [meta, tl_topbar, topbar, gallery])
    style!(main_body, "overflow" => "hidden")
    write!(c, main_body)
end