module EmmysApp
using Toolips
using Toolips.Components
using ToolipsSession
# extensions

main = route("/toolips/app/guesser") do c::Toolips.Connection
    main_body::Component{:body} = body("main", align = "center")
    style!(main_body, "background-color" => "#200521")
    # creating 'fade up' animation:
    fade_up::Components.KeyFrames = keyframes("fadeup")
    keyframes!(fade_up, 0percent, "opacity" => 0percent, "transform" => "translateY(20%)")
    keyframes!(fade_up, 100percent, "opacity" => 100percent, "transform" => "translateY(0%)")
    # creating classes:
    circ_class = style("circle.circ", "fill" => "pink", "stroke" => "purple", "stroke-width" => 2px, 
    "transition" => 750ms)
    circ_class:"hover":["stroke" => "lightgreen"]
    circ_selected = style("circle.selected", "fill" => "blue", 
    "stroke-width" => 5px, "stroke" => "green")
    style!(circ_class, fade_up)
    # component templating:
    guy_image::Component{:img} = img("creatorguy", src = "/images/creatorcutie.png")
    heading = h2("creatorlabel", text = "creator's guessing game!")
    sub_heading = h4("subhead", text = "guess the randomly selected circle to win!")
    style!(guy_image, fade_up)
    style!(heading, fade_up)
    style!(sub_heading, fade_up)
    style!(heading, "font-size" => 22pt, "font-weight" => "bold", "color" => "white")
    style!(sub_heading, "font-size" => 16pt, "color" => "pink")
    my_svg::Component{:svg} = svg("mywindow", width = 600, height = 250, selected = "0")
    # game algorithm
    # we need to scale the circles to fit in the `600px` frame. (i meant to make this the width earlier)
    n::Int64 = 5
    correct_answer = string(rand(1:n))
    distance = (600 - 100) / n
    new_circles = [begin
        this_circle = Component{:circle}("circle$count", 
        r = 20, cy = 125, cx = count * distance, class = "circ")
        on(c, this_circle, "click") do cm::ComponentModifier
            cm["mywindow"] = "selected" => string(count)
            subm_b = button("subb", text = "submit")
            if ~("subb" in cm)
                style!(subm_b, "background-color" => "pink", "font-weight" => "bold", 
                "border" => "3px whitesmoke", "border-radius" => 3px, "padding" => 7px)
                on(c, subm_b, "click") do cm2::ComponentModifier
                    replay_button = button("reload", text = "replay?")
                    on(replay_button, "click") do cm::ClientModifier
                        redirect!(cm, "/toolips/app/guesser")
                    end
                    remove!(cm2, "subb")
                    append!(cm2, "main", replay_button)
                    if cm2["mywindow"]["selected"] == correct_answer
                        style!(cm2, this_circle, "fill" => "darkgreen")
                        return
                    else
                        style!(cm2, this_circle, "fill" => "red")
                        style!(cm2, "circle$correct_answer", "fill" => "orange")
                    end
                end
                append!(cm, "main", subm_b)
            end
            cm[this_circle] = "class" => "selected"
            for val in filter(number -> number != count, Vector(1:5))
                cm["circle$val"] = "class" => "circ"
            end
        end
        this_circle::Component{:circle}
    end for count in 1:n]
    set_children!(my_svg, new_circles)
    push!(main_body, fade_up, circ_class, circ_selected, 
    guy_image, heading, sub_heading, my_svg)
    write!(c, main_body)
end

# make sure to export!
export main
end # - module EmmysApp <3
