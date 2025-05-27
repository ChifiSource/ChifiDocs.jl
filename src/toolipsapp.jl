toolips_app = route("/toolips/app") do c::Connection
    gallery = div("gallery")
    style!(gallery, "position" => "absolute", "width" => 100percent, "height" => 100percent, 
    "background-color" => "#73327a", "top" => 0percent, "left" => 0percent)
    tlapp_img = img(src = "/images/toolipsapp.png")
    sub = h2(text = "coming soon, as part of chifidocs")
    style!(sub, "color" => "white")
    maindiv = div("mainmsg", align = "center", "padding" => 20percent, children = [tlapp_img, sub])
    push!(gallery, maindiv)
    main_body = body("tlapp", children = [gallery])
    write!(c, main_body)
end