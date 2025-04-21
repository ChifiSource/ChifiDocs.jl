#== components.jl
`components.jl` is a special source file (specific to this project and loaded in dev.jl) 
which allows us to build custom components into our markdown documentation pages and load dependencies to use in our documentation pages..
Make sure to only export components, interpolate by name into markdown using $, and in Julia using `interpolate!` or `interpolate_code!`.
`$`.
==#
"""
#### ChifiDocs !
chifi docs is a documentation site for `chifi` software created using `Documator`, a 
    documentation website generator powered by the `Toolips` web-development framework.

"""
module ChifiDocs
# chifi :)
using ChifiDocs
using CarouselArrays
using Documator
# parametric :)
using Toolips.ParametricProcesses
using IPyCells
# toolips <3
using Toolips
using Toolips.ToolipsServables
using ToolipsSession
using ToolipsUDP
using ToolipsSVG
# gattino c:
using Gattino
using GattinoPleths
# olive !
using Olive
using Olive.OliveHighlighters
using OlivePython
"""
#### chifi !
- What on Earth is a 'chifi'?

`chifi`, pronounced "kai-fie", is an open-source software organization dedicated to bringing unique 
and compelling ecosystems and tools to the Julia language primarily centered around 
**data-driven** web-development. Anyone and everyone can be and is part of "kai-fie" though our list of 
*code*-based collaborators is rather small. Our goal is to push and educate more to collaborate and create 
while also creating some pretty awesome tools for our favorite programming language (Julia).
"""
function chifi end


function EULA end

"""
### this sample was retrieved!
This sample was grabbed through documentation (`this` is a function) interpolation built into `Documator`!
"""
function this end
module AlgebraFrames

end

module Tumble end

components = Vector{AbstractComponent}()

mutable struct ChifiLinkData
   img::String
   name::String
   href::String
end

lds = Vector{ChifiLinkData}()

push!(lds, ChifiLinkData("https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png", "chifi on github", 
"https://github.com/ChifiSource"), ChifiLinkData("/ecosystems/chifi.png", "blog", "https://medium.com/chifi-media"))

links = div("chifi-links", children = [begin
   mainbox = a(href = linkdata.href)
   style!(mainbox, "padding" => 4px, "display" => "inline-block", "border" => "2px solid #333333", 
   "cursor" => "pointer")
   maintag = span(text = linkdata.name)
   style!(maintag, "color" => "#333333", "font-size" => 12pt)
   image = img(src = linkdata.img, width = 19px)
   push!(mainbox, image, maintag)
   mainbox
end for linkdata in lds])

function build_collaborators(ecotags::Vector)
    srcdir = @__DIR__
    collabs = Documator.TOML.parse(read(srcdir * "/../contributors.toml", String))
    collaborators = div("chifi-collaborators", children = [begin
        clname = collaborator[1]
        mainbox = div(clname)
        style!(mainbox, "display" => "inline-block", "cursor" => "pointer")
        style!(mainbox, "padding" => 9px, "background-color" => "#333333")
        lftimg = img("$clname-img", src = "https://avatars.githubusercontent.com/$clname", width = 50)
        style!(lftimg, "display" => "inline-block", "border-radius" => 6px)
        sidecontainer = div("sidecontainer")
        style!(sidecontainer, "display" => "inline-block", "padding" => 10px)
        label_styles = ("color" => "white", "font-weight" => "bold", 
        "padding-left" => 4px)
        mainlabel = div("$clname-label", text = clname)
        style!(mainlabel, "font-size" => 13pt, "border-left" => "2px solid white", label_styles ...)
        push!(sidecontainer, mainlabel)
        push!(mainbox, lftimg, sidecontainer)
        if "name" in keys(collaborator[2])
            namelabel = div("$clname-namelabel", text = collaborator[2]["name"])
            style!(namelabel, label_styles ...)
            push!(sidecontainer, namelabel)
        end
        overbox = div("over", align = "left")
        style!(overbox, "display" => "flex", "flex-direction" => "column")
        on(mainbox, "click") do cl::ClientModifier
            redirect!(cl, "https://github.com/$clname", new_tab = true)
        end
        toprojs = Vector{AbstractComponent}([ecotags["$name-tag"] for name in collaborator[2]["ecosystems"]])
        supp_butt = div("supp$clname", text = "v", align = "center")
        style!(supp_butt, "background-color" => "#E75480", "font-family" => "storycan", "color" => "white", 
        "cursor" => "pointer", "font-weight" => "bold", "font-size" => 14pt)
        on(supp_butt, "click") do cl::ClientModifier
            redirect!(cl, "https://github.com/sponsors/$clname", new_tab = true)
        end
        ecoholder = div("-", children = toprojs)
        style!(ecoholder, "display" => "flex", "flex-direction" => "column")
        push!(overbox, mainbox, supp_butt, ecoholder)
        overbox
    end for collaborator in collabs])
    style!(collaborators, "border-radius" => 3px, "padding" => 7px, "display" => "flex", "flex-direction" => "row", 
    "justify-content" => "center")
    collaborators
end

function build_ecotags(docsystems::Vector{Documator.DocSystem})
    Vector{AbstractComponent}([begin 
        mainbox = section(system.name * "-tag")
        style!(mainbox, "background-color" => system.ecodata["color"], 
        "border-radius" => 4px, "padding" => 4px, "display" => "inline-block", "border" => "2px solid #333333", 
        "cursor" => "pointer")
        maintag = span(text = system.name)
        on(mainbox, "click") do cl::ClientModifier
            cl.name = system.name
            redirect!(cl, "/$(system.name)")
        end
        style!(maintag, "color" => system.ecodata["txtcolor"], "font-size" => 12pt)
        pkg_cont = length(system.modules)
        count_tag = span(text = "$pkg_cont packages")
        style!(count_tag, "color" => system.ecodata["txtcolor"], "font-size" => 10pt, "float" => "right", "font-weight" => "bold", "margin-right" => 8px, "margin-top" => 8px, 
        "margin-left" => 8px, "opacity" => 80percent)
        image = img(src = system.ecodata["icon"], width = 19px)
        push!(mainbox, image, maintag, count_tag)
        mainbox
    end for system in docsystems])
end

function start_project(ip::IP4 = "192.168.1.10":8000, path::String = pwd())
    docloader = Documator.docloader
    docloader.dir = path
    docloader.docsystems, docloader.homename = Documator.read_doc_config(path, ChifiDocs)
    ecotags = build_ecotags(docloader.docsystems)
    push!(components,  build_collaborators(ecotags), ecotags ...)
    Documator.load_docs!(ChifiDocs, docloader)
    start!(Documator, ip, router_type = Documator.DocRoute)
end

function reload!()
   docloader = Documator.docloader
    docloader.docsystems = Documator.read_doc_config(docloader.dir, ChifiDocs)
    ecotags = build_ecotags(docloader.docsystems)
    Documator.load_docs!(ChifiDocs, docloader)
end

DIREC = @__DIR__
eula_raw = read(DIREC * "/eula.txt", String)
gat_scat = begin
    gattino_img = img(src = "https://github.com/ChifiSource/image_dump/blob/main/gattino/gattino.png?raw=true", 
        height = 100)
    gattino_img_container = div("gattinoc", align = "center", children = [gattino_img])
    style!(gattino_img_container, "width" => 100px, "height" => 300px, "padding" => 50px, 
        "display" => "inline-block")
    scatplot = Gattino.scatter(randn(50), randn(50), width = 400, height = 350, 
    xlabel = "randn()", ylabel = "randn()", title = "random numbers").window
    div("gattino-scatter", children = [gattino_img_container, scatplot])
end

gat_scat.name = "gattino-scatter"
EULA_comp = tmd("chifi-EULA", String(eula_raw))

container = begin
    confirm_button = div("confbutt", text = "confirm")

    txt = textdiv("maintxt", text = "")

    style!(txt, "padding" => 5px, "border" => "1px solid #1e1e1e", 
        "display" => "inline-block")

    style!(confirm_button, "padding" => 5px, "cursor" => "pointer", "border" => "1px solid #1e1e1e")

    on(confirm_button, "click") do cl::ClientModifier
        alert!(cl, cl["maintxt", "text"])
    end
    section("containersamp", children = [txt, confirm_button])
end

svg_header = begin
    svg_img = img(src = "https://github.com/ChifiSource/image_dump/blob/main/toolips/toolipsSVG.png?raw=true", 
        height = 150)
    choices = [:circle, :star, :rect]
    colors = [:blue, :orange, :pink, :purple]
    circles = [begin
        comp = circle("svg-$x")
        set_size!(comp, 5, 5)
        set_position!(comp, x, rand(20:130))
        comp = set_shape(comp, choices[rand(1:3)])
        style!(comp, "fill" => colors[rand(1:4)])
        comp::Component{<:Any}
    end for x in range(25, 275, step = 10)]
    svg_preview = svg(height = 150, width = 300, children = circles)
    header = section("svgheader", children = [svg_img, svg_preview])
end


push!(components, EULA_comp, gat_scat, links, container, svg_header)
export ChifiDocs, this, Toolips, chifi, EULA, components, reload!
end