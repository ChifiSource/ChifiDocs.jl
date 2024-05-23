module ChifiDocs
using Toolips
using Toolips.Components
using ToolipsSession

# extensions
logger = Toolips.Logger()
session = Session(["/"])

mutable struct DocModule
    mod::module
    color::String
    path::String
    names::Dict{String, Component{<:Any}}
end

doc_mods = Vector{DocModule}()

push!(doc_mods, DocModule(Toolips, "#333333", "public/toolips"))
hover_styles = ("border-radius" => 2px, "border" => "1px solid #333333", 
"position" => "absolute", "z-index" => 5, "background-color" => "white")


function generate_menu(mods::Vector{DocModule})
    [begin
    
    end for menu_mod in mods]
end

function home(c::Toolips.AbstractConnection)
    mainbod = body("main")
    curs = Components.cursor("curs")
    on(c, hovera, "click") do cm::ComponentModifier
        curs = cm[curs]
        x, y = curs["x"], curs["y"]
        style!(hoverdata, "top" => y, "left" => x)
        append!(cm, mainbod, hoverdata)
    end
    hovera2 = a("testa", text = "hoverdata2")
    on(c, hovera2, "click") do cm::ComponentModifier
        curs = cm[curs]
        x, y = curs["x"], curs["y"]
        style!(hoverdata, "top" => y, "left" => x)
        append!(cm, mainbod, hoverdata)
    end
    on(c, mainbod, "click") do cm::ComponentModifier
        curs = cm[curs]
        x, y = curs["x"], curs["y"]
        style!(hoverdata, "top" => y, "left" => x)
        append!(cm, mainbod, hoverdata)
    end
    push!(mainbod, curs, hovera, hovera2)
    write!(c, mainbod)
end

main = route(home, "/")

# make sure to export!
export main, default_404, logger, session
end # - module ChifiDocs <3