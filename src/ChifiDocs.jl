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
DIREC = @__DIR__
# chifi :)
using ChifiDocs
using CarouselArrays
using Documator
# parametric :)
using Toolips.ParametricProcesses
using IPyCells
using ParametricScheduler
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
using OliveDocBrowser
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
"https://github.com/ChifiSource"), ChifiLinkData("/ecosystems/chifi.png", "blog", "https://medium.com/chifi-media"), 
ChifiLinkData("/images/contact.png", "contact", "/contact"), ChifiLinkData("/images/creative-commons.png", "licenses", "/licensing"), 
ChifiLinkData("", "write ups", "/writeups"), ChifiLinkData("", "toolips app", "/toolips/app"))

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
        style!(maintag, "color" => system.ecodata["txtcolor"], "font-size" => 12pt, "margin-left" => 4px)
        pkg_cont = length(system.modules)
        count_tag = span(text = "$pkg_cont packages")
        style!(count_tag, "color" => system.ecodata["txtcolor"], "font-size" => 10pt, "float" => "right", "font-weight" => "bold", "margin-right" => 8px, "margin-top" => 8px, 
        "margin-left" => 8px, "opacity" => 80percent)
        image = img(src = system.ecodata["icon"], width = 19px)
        push!(mainbox, image, maintag, count_tag)
        mainbox
    end for system in docsystems])
end

licenses = route("/licensing") do c::Connection
    write!(c, c[:doc].pages["styles"])
    DIREC = @__DIR__
    license_container = div("licenseco", children = [EULA_b, MIT_b, CCBY_B])

    write!(c, tmd("chifi-EULA", read(DIREC * "/eula.txt", String)))
end

contact = route("/contact") do c::Connection
    write!(c, c[:doc].pages["styles"])
    contact_dialog = div("contactchi")
    style!(contact_dialog, "background-color" => "#ef6292", "border-radius" => 5px, 
    "border" => "1px solid #522966", "padding" => 2percent, "position" => "absolute", 
    "width" => 40percent, "left" => 30percent, "top" => 20percent, "height" => 30percent)
    contact_dialog[:children] = [begin 
        lbl = a(text = infoname)
        style!(lbl, "color" => "#333333", "font-weight" => "bold", "margin-right" => 10px)
        fillbox = Components.textdiv(infoname, text = "")
        style!(fillbox, "padding" => 2percent, "background-color" => "white", "border" => "1px solid #333333")
        div("$infoname-cont", children = [lbl, fillbox])
    end for infoname in ("name", "email", "organization", "subject", "message")]
    mainbod = body("main", children = contact_dialog)
    style!(mainbod, "background-color" => "#333333", "transition" => 1000ms)
    on(c, 100) do cm::ComponentModifier
        style!(cm, "main", "background-color" => "#191921")
    end
    write!(c, mainbod)
end

writeups = route("/writeups") do c::Connection
    write!(c, "have yet to fully implement this page :(")
end

toolips_app = route("/toolips/app") do c::Connection
    gallery = div("gallery")
    main_body = body("tlapp", children = [gallery])
    write!(c, main_body)
end

function start_project(ip::IP4 = "192.168.1.10":8000, path::String = pwd())
    docloader = Documator.docloader
    docloader.dir = path
    if ~(licenses.path in docloader.routes)
        # add new routes here!
        push!(docloader.routes, licenses, contact, writeups, toolips_app)
    end
    docloader.docsystems, docloader.homename = Documator.read_doc_config(path, ChifiDocs)
    push!(docloader.meta, "title" => "chifi docs", 
    "desc" => """chifi is an open-source software organization focused on making web-development 
    and data-science software for the Julia programming language. 'ChifiDocs' is an effort to centralize 
    `chifi` services and documentation, as well as provide a basic home for `chifi` on the internet. This 
    website includes interactive documentation, information on chifi, information on programming, as well as links 
    to the rest of the `chifi` web.""", 
    "tags" => "Programming, Software, WebDevelopment, Internet, Julia, Julialang", "icon" => "/favicon.ico")
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

local_euro_resource = GattinoPleths.ChoroplethResource("europe.svg", 680 => 520, GattinoPleths.def_names)

x = ["it", "uk", "fr", "de"]
y = [50, 22, 33, 95]
result = choropleth(x, y, local_euro_resource)
GattinoPleths.choropleth_legend!(result, "dry" => "wet")
result

pleth = result.window
pleth.name = "plethsample"

con_manual = context() do con::Context
    w, h = Int64(round(con.dim[1] * .75)), Int64(round(con.dim[2] * .75))
    ml, mt = Int64(round(con.dim[1] * .12)) + con.margin[1], Int64(round(con.dim[2] * .12) + con.margin[2])
    group!(con, "title") do titlegroup::Group
        posx = Int64(round(con.dim[1] * .35) + con.margin[1])
        posy = Int64(round(con.dim[2] * .08) + con.margin[2])
        Gattino.text!(con, posx, posy, "sample plot", "fill" => "black", "font-size" => 15pt)
    end
   group(con, w, h, ml => mt) do plotgroup::Group
        group!(plotgroup, "axes") do g::Group
            Gattino.axes!(g)
        end
        group!(plotgroup, "grid") do g::Group
            Gattino.grid!(g, 4)
        end
    end
end.window

con_manual.name = "conmanual"
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

chifidocs_header = begin
    right_in = keyframes("rightin")
    keyframes!(right_in, 0percent, "opacity" => 0percent, "transform" => translateX(-5percent))
    keyframes!(right_in, 100percent, "opacity" => 100percent, "transform" => translateX(0percent))
    chisvg = svg(text = read(DIREC * "/chifi.svg", String), width = 125, height = 125)
    style!(chisvg, "animation-name" => "rightin", "animation-duration" => 650ms)
    div("chiheader", children = [right_in, chisvg], align = "center")
end

chifidocs_footer = begin
    cc_by = img("ccby", src = "/images/creative-commons.png", width = 17)
    on(cc_by, "click") do cl::ClientModifier

    end
    license_link = a(href = "/licensing", text = "licensing")
    link_common = ("color" => "white", "background-color" => "#1e1e1e", "padding" => 7px, 
    "margin-left" => 5px)
    style!(license_link, link_common ...)
    contact_link = a(href = "/contact", text = "contact")
    style!(contact_link, link_common ...)
    locate_label = a("locate", text = "Albuquerque, New Mexico")
    style!(locate_label, "color" => "white", "margin-left" => 8px, "font-size" => 11pt, 
    "opacity" => 60percent)
    style!(cc_by, "display" => "inline-block")
    chi_label = a(text = "chifi software")
    style!(chi_label, "color" => "white", "font-size" => 15pt, "font-weight" => "bold", 
    "margin-left" => .5percent)
    docs_label = a(text = "chifidocs (" * string(pkgversion(ChifiDocs)) * ")")
    style!(docs_label, "opacity" => 60percent, "color" => "#f178a1", "font-size" => 13pt, 
    "margin-left" => 7percent)
    chisvg = svg(text = read(DIREC * "/chifi.svg", String), width = 17, height = 17)
    style!(chisvg, "animation-name" => "rightin", "animation-duration" => 650ms, 
    "margin-left" => 3percent)
    foot = div("chifoot", children = [cc_by, chi_label, locate_label, contact_link, license_link, docs_label])
    style!(foot, "background-color" => "#1e1e1e", "padding" => 2percent, "border-radius" => 4px)
    foot
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
    section("svgheader", children = [svg_img, svg_preview])
end

openlay_sample = begin
    firstfeature = randn(500)
    secondfeature = randn(500)
    thirdfeature = randn(500)
    fourthfeature = randn(500)
    mycon = context(500, 500) do con::Context
        Gattino.scatter_plot!(con, firstfeature, secondfeature)
    end
    Gattino.open_layer!(mycon, "points") do ec
         Gattino.set!(ec, :r, thirdfeature, max = 60)
         style!(ec, "stroke" => "#1e1e1e")
         style!(ec, fourthfeature, "stroke-width" => 10)
    end
    mycon.window.name = "openlayersample"    
    mycon.window
end

groupgat_sample = begin
    myframe = context(500, 250) do con::Context
        group(con, 250, 250) do g::Group
            Gattino.scatter_plot!(g, [1, 2, 3, 4], [1, 2, 3, 4])
        end
    end
    group(myframe, 250, 250, 250 => 0) do g::Group
        Gattino.grid!(g, 4, "stroke" => "pink")
    end
    myframe.window.name = "groupgatsample"
    myframe.window
end

push!(components, gat_scat, links, container, svg_header, con_manual, 
chifidocs_header, pleth, openlay_sample, groupgat_sample, foot)
export ChifiDocs, this, Toolips, chifi, EULA, components, reload!
end