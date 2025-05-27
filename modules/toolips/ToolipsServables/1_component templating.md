## components
The backbone of `Component` templating begins with the `AbstractComponent` -- an abstract type which encompasses *all* HTML and CSS elements. Every `AbstractComponent` will have a **name** and vectors of abstract components are index-able by name. The `Vector{AbstractComponent}` is the standard way for representing more than one `Component` and/or `Style` or `KeyFrames`. The `:children` inside of a `Component` will be of type `Vector{AbstractComponent}`. An `AbstractComponent` is a sub-type of `Servable`, which is meant to be the top of the type hierarchy for this templating system. The aforementioned structures are the three types of components we can create:
- The `Component` is used to represent an HTML element.
- The `Style` is used to represent a CSS class.
- and the `KeyFrames` are used to represent `@keyframes` CSS animations.
## HTML templating
In the `ToolipsServables` templating system, a `Component` represents an **HTML element**. HTML elements have a `tag`, `text`, `children`, and `arguments` to consider. Every `AbstractComponent` has a binding to `string`

For the majority of tags, `ToolipsServables` provides **constants** that alias the `Component` constructor for that tag. For example, `svg` is just an alias for `Component{:svg}`, so when we call `ToolipsServables.svg()` we could make that same call with `ToolipsServables.Component{:svg}()`. This is not the case for **every** `Component` name in `ToolipsServables` -- for example, `select` is a `Function` to allow for the `select(::String, ::Vector{AbstractComponent})` dispatch. The input components, such as the `colorinput` also have special calls attached to them that are important to make them work properly. Here is a full list of elements to browse (click to view documentation):
- **in this list, options that appear as `Component` are constant bindings.**

- `img`
- `link`
- `meta`
- `input`
- `a`
- `p`
- `ul`
- `li`
- `br`
- `i`
- `title`
- `span`
- `iframe`
- `svg`
- `h1`
- `h2`
- `h3`
- `h4`
- `h5`
- `h6`
- `h`
- `element`
- `label`
- `script`
- `nav`
- `button`
- `form`
- `section`
- `body`
- `header`
- `footer`
- `b`
- `source`
- `audio`
- `video`
- `table`
- `tr`
- `th`
- `td`
- `tmd`
- `base64img`
- `keyframes`
- `style!`
- `push!`
- `textdiv`
- `textbox`
- `password`
- `numberinput`
- `rangeslider`
- `option`
- `options`
- `select`
- `checkbox`
- `colorinput`
- `progress`
- `cursor`
- `context_menu!`
- `keyinput`

( modifies a `Component`)
- `textdiv_caret_tracker!`

To create a `Component`, we provide a `name` and an infinite list of `Pair{String, <:Any}` and `Symbol` arguments. All of these arguments are optional most of the time... In rare cases, such as `div`, the `name` is not optional, because this binding is *actually* an additional `Method` for `Base.div`. Most of the time, we can skip providing the name. The properties can be whatever we want them to be, or builtin HTML element properties such as `align`, `href`, `src`, and `spellcheck`. Each `Component` will be constructed with a few *special* properties; `:text`, `:children`, and `:extras`.
- The `:text` will be rendered **inside** of a given element.
- The `:children` are components will be rendered **inside** of a given element.
- And the `:extras` are extra components to be written with a `Component` that are written before the `Component`. This is useful for adding scripts and animations, for example, to a `Component` without writing them individually.
```julia
main_comp = div("main", align = "center")

style!(main_comp, "padding-top" => 5percent, "cursor" => "pointer")


push!(main_comp, h2(text = "hello world!"))

set_children!(main_comp, [h2(text = "goodbye world!")])

comp_class = style("div.main", "background-color" => "whitesmoke")

comp_class:"hover":["transform" => scale(1.07)]

# add to extras
push!(main_comp.extras, comp_class)

# change properties
main_comp[:align] = "left"

# convert to `String`:
string(main_comp)
```
There are three main ways we mutate components,
- By modifying its children using `push!`, `set_children!`, or by indexing `:children`.
- By modifying its properties.
- By modifying its style using the `:class` argument or the `style!` function.
- By binding callback events to a `Component` with `on` (see [client modifier callbacks](#client-modifier-callbacks))

By combining these techniques we can effectively template any HTML document we want from `Toolips` pretty easily. There is also support for basic client-side JavaScript and CSS templating.
## CSS templating
Alongside HTML templating, `ToolipsServables` provides a moderately robust API for templating CSS through the sub-types of `StyleComponent`. The `Style` and the `KeyFrames` animation are provided in this regard. The `style` is simple; this structure represents a CSS **class**. A CSS class only contains a `name` and a list of style pairs, the constructor calls reflect this simplicity:
```julia
my_style = style("div.sample", "color" => "green")

my_style["color"] = "blue"

style!(my_style, "background-color" => "white")

# add a transition length?
style!(my_style, "transition" => 500ms)
```
To create sub-classes, use the `:` or `(:)` operator. First our style then a sub-class name and then a `Vector` of our style pairs.
```julia
my_style:"hover":["background-color" => "green"]
```
Once we have a class, we can set a `Component` to that class by setting its `:class` property or using the `style!` function.

The `Style` is a single-step process, but the same cannot be said for the `keyframes`. First, we will need to construct the `KeyFrames`, then we will need to add key-frames to it using the `keyframes!` function.
```julia
# KeyFrames(name::String; 
#        iterations::Int64 = 1, duration::String = 1s)
fade_up = keyframes("fadeup")

keyframes!(fade_up, 0percent, "opacity" => 0percent, 
"transform" => translateY(10percent))

keyframes!(fade_up, 100percent, "opacity" => 100percent, 
"transform" => translateY(0percent))
```
The animation may then be applied in the same way to a `Style`. Note that these must be written with a `Component` to work, we cannot write the `Component` without the `StyleComponent`.
## measures
`ToolipsServables` also includes several `measures`. These are facilitated by the `WebMeasure` type. These `measures` are convenient macros that make templating far more convenient inside of the Julia language.
```julia
my_div = div("sample-div", text = "hello")
style!(my_div, "text-color" => "#1e1e1e", "background-color" => "pink", 
"font-size" => 13pt, "padding" => 15px, 
"margin-left" => 5percent, "transition" => 5s, "transform" => translateY(10percent))
```
A full list of available `measures`:
```julia
# size
px
pt
inch
pc
mm
cm
# relative size
perc, per, percent
em
# time
seconds, s
ms
# angles
deg
turn

# animation
to
from
perc, per, percent

# transforms, colors
rgba
translateX
translateY
rotate
matrix
skey
translate
scale
```
## client modifier callbacks
For adding scripts and functionality to these templates, `ToolipsServables` offers a `ClientModifier` callback system. This system hinges on the `on` and `bind` functions, which will take a callback function that takes a `ClientModifier` as an argument. This is the `Toolips` system for creating callbacks:

```julia
confirm_button = div("confbutt", text = "confirm")

txt = textdiv("maintxt", text = "")

style!(txt, "padding" => 5px, "border" => "1px solid #1e1e1e", 
    "display" => "inline-block")

style!(confirm_button, "padding" => 5px, "cursor" => "pointer", "border" => "1px solid #1e1e1e")

on(confirm_button, "click") do cl::ClientModifier
    alert!(cl, cl["maintxt", "text"])
end

container = section(children = [txt, confirm_button])

# display?
display("/text/html", string(container))
```
- Also check out `funccl`
Note the indexing of the `ClientModifier`, we index by name and property name, this returns a `Component{:property}` which we can pass to modifier functions and create some level of complex functionality using only client-side callbacks. Note that the `ClientModifier` is called the `ClientModifier` because it is exclusively used to create client-side JavaScript. This example produces the following result:

`containersamp`

The majority of `ClientModifier` callbacks are not going to use the `Component{:property}`, and anything that needs to be done in Julia will require full-stack callbacks. For server-side full-stack callbacks, see the [ToolipsSession](/toolips/ToolipsSession) server extension for [Toolips](/toolips).
## modifier functions
Here is an exhaustive list of `ClientModifier` callback functions we are able to call on our modifiers. These will always take a `ClientModifier` as the first argument, and *usually* a `Component` name as the second:
- `move!`
- `set_text_div_cursor!`
- `remove!`
- `set_text!`
- `set_children!`
- `append!`
- `insert!`
- `sleep!`
- `style!`
- `set_style!`
- `alert!`
- `focus!`
- `blur!`
- `redirect!`
- `next!`
- `next_transition!`
- `transition!`
- `update!` (for type display)
- `update_base64!`