toolipsapp_main = route("/toolips/app/main") do c::Connection
    write!(c, c[:doc].pages["styles"], Style("p", "color" => "white"))
    msg = tmd("msg", """### welcome to toolips app !
`ToolipsApp` is an application built to demonstrate the numerous capabilities of `Toolips`. This is a gallery 
of different websites created entirely with `Toolips`. Use the source button at the top to flip between `source` / the web-view.""")
    mainbod = body("main", children = [msg])
    style!(mainbod, "padding" => 20percent, "background-color" => "#4f638c")
    write!(c, mainbod)
end