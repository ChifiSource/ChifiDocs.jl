toolipsapp_main = route("/toolips/app/main") do c::Connection
    write!(c, c[:doc].pages["styles"], Style("p", "color" => "white"))
    msg = tmd("msg", read(DIREC * "/toolipsapp/app main.md", String))
    ToolipsServables.interpolate!(msg, "julia" => Documator.julia_interpolator)
    mainbod = body("main", children = [msg])
    style!(mainbod, "padding" => 10percent, "background-color" => "#4f638c")
    write!(c, mainbod)
end