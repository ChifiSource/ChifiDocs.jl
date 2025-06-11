module EcoGalaxies
using ChifiDocs
using ChifiDocs.Documator
using Documator.Toolips.Components
using Documator.Toolips
using Documator.ToolipsSession

function make_ecogalaxy(mod::Module, systems::Vector{Documator.DocSystem}, 
    mods::Module ...)
    @info "rendering ecogalaxy '$mod'..."
    w, h = 2000, 800
    circles::Vector{AbstractComponent} = Vector{AbstractComponent}()
    galaxy_window = svg("galaxywin", width = w, height = h)
    n = length(systems)
    galax_step = Int64(round((w) / n))
    current_min = 20
    current_max = galax_step
    positions = Dict{Symbol, Tuple{Int64, Int64}}()
    texts = Vector{AbstractComponent}()
    dependents = Dict{Symbol, Vector{String}}()
    for system in systems
        for docmod in system.modules
            if docmod.name == "ChifiDocs"
                continue
            end
            docname = Symbol(docmod.name)
            if isdefined(mod, docname)
                mod_obj = mod.eval(docname)
                r = 9
                selected_x = rand(current_min:current_max)
                selected_y = rand(50:h - 50)
                lbl = Component{:text}("lbl$docname", x = selected_x, y = selected_y, text = string(docname))
                style!(lbl, "font-weight" => "bold", "font-size" => 20pt, "stroke" => "#1e1e1e", 
                "stroke-width" => 1px, "fill" => "pink", "transition" => 1seconds)
                push!(texts, lbl)
                circ = Component{:circle}("$(docname)planet", cx = selected_x,
                    cy = selected_y, r = 1percent)
                on(Documator.session, "enter$docname") do cm::ComponentModifier
                    cm[circ] = "r" => 4percent
                    style!(cm, "lbl$docname", "fill" => docmod.color, "font-size" => 30pt)
                    this_mod = getfield(mod, docname)
                    allnames = [keys(positions) ...]
                    deps = findall(k -> isdefined(this_mod, k) && k != docname, allnames)
                    for dep in deps
                        style!(cm, "$docname$(allnames[dep])con", 
                        "stroke" => "orange", "stroke-width" => 3px)
                        style!(cm, "lbl$(allnames[dep])", "fill" => "orange", 
                        "font-size" => 22pt)
                    end
                    if ~(docname in keys(dependents))
                        @warn "canceled, $docname"
                        return
                    end
                    for dependent in dependents[docname]
                        style!(cm, "$dependent$(docname)con", 
                        "stroke" => docmod.color, "stroke-width" => 4px)
                        style!(cm, "lbl$dependent", "fill" => docmod.color, 
                        "font-size" => 22pt)
                    end
                end
                on("enter$docname", circ, "mouseenter")
                on(circ, "mouseleave") do cl::ClientModifier
                    cl[circ] = "r" => 1percent
                    style!(cl, "dep$docname", "stroke" => "black")
                    style!(cl, "lbl$docname", "fill" => "white")
                end
                on(Documator.session, "plan$docname") do cm::ComponentModifier
                    alert!(cm, "null")
                end
                on("plan$docname", circ, "click")
                style!(circ, "fill" => docmod.color, "transition" => 600ms)
                push!(galaxy_window, circ)
                push!(positions, docname => (selected_x, selected_y))
            else
                @warn "$docname not defined."
            end
        end
        current_max += galax_step
        current_min += galax_step
    end
    push!(galaxy_window, texts ...)
    allnames = [keys(positions) ...]
    for pos in positions
        this_mod = getfield(mod, pos[1])
        deps = findall(k -> isdefined(this_mod, k) && Symbol(this_mod) != k, allnames)
        for dependent_position in deps
            depkey = Symbol(allnames[dependent_position])
            if depkey in keys(dependents)
                push!(dependents[depkey], string(pos[1]))
            else
                dependents[depkey] = [string(pos[1])]
            end
            connected_pos = positions[depkey]
            connector = Component{:line}("$(pos[1])$(depkey)con", x1 = pos[2][1], y1 = pos[2][2], 
                x2 = connected_pos[1], y2 = connected_pos[2])
            style!(connector, "stroke" => "black", "stroke-width" => .1percent)
            insert!(galaxy_window[:children], 1, connector)
        end
    end
    @warn dependents[:Toolips]
    compress!(galaxy_window)
    galaxy_window
    wrapper = div("$(mod)galaxy", children = [galaxy_window])
    style!(wrapper, "overflow" => "scroll", "border-radius" => 4px, "border" => "2px solid #333333")
    return(wrapper)
end

end