## components
The backbone of `Component` templating begins with the `AbstractComponent` -- an abstract type which encompasses *all* HTML and CSS elements. Every `AbstractComponent` will have a **name** and vectors of abstract components are index-able by name. The `Vector{AbstractComponent}` is the standard way for representing more than one `Component` and/or `Style` or `KeyFrames`. The `:children` inside of a `Component` will be of type `Vector{AbstractComponent}`. An `AbstractComponent` is a sub-type of `Servable`, which is meant to be the top of the type hierarchy for this templating system. The aforementioned structures are the three types of components we can create:
- The `Component` is used to represent an HTML element.
- The `Style` is used to represent a CSS class.
- and the `KeyFrames` are used to represent `@keyframes` CSS animations.
## HTML templating
In the `ToolipsServables` templating system, a `Component` represents an **HTML element**. HTML elements have a `tag`, `text`, `children`, and `arguments` to consider. 
```html
<div arg="hello">

text/children

</div>
```
For the majority of tags, `ToolipsServables` provides **constants** that alias the `Component` constructor for that tag. For example, `svg` is just an alias for `Component{:svg}`, so when we call `ToolipsServables.svg()` we could make that same call with `ToolipsServables.Component{:svg}()`. This is not the case for **every** `Component` name in `ToolipsServables` -- for example, `select` is a `Function` to allow for the `select(::String, ::Vector{AbstractComponent})` dispatch. The input components, such as the `colorinput` also have special calls attached to them that are important to make them work properly. Here is a full list of elements to browse (click to view documentation):

**in this list, options that appear as `Component` are constant bindings.**


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

To create a `Component`, we provide a `name` and an infinite list of `Pair{String, <:Any}` and `Symbol` arguments. All of these arguments are optional most of the time... In rare cases, such as `div`, the `name` is not optional, because this binding is *actually* an additional `Method` for `Base.div`. Most of the time, we can skip providing the name.

CONTINUE~
## CSS templating

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
For adding scripts and functionality to these templates, `ToolipsServables` offers a `ClientModifier` callback system.