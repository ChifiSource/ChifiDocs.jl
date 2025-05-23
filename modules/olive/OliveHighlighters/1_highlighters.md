## highlighting
Highlighting with `OliveHighlighters` is based around the `TextStyleModifier`, a type of `TextModifier` and a `Modifier`. The `TextStyleModifier` is also aliased as `Highlighter`. The first step is building a highlighter. The constructor, optionally, takes a `String`.
```julia
using OliveHighlighters

my_hl = Highlighter("sample")
```
After a `Highlighter` is built, we add style classes using `style!` and we mark it using [marking functions](#marking-functions)
```julia
using OliveHighlighters

my_hl = Highlighter("s a m p l e s")

style!(my_hl, :s, "color" => "red", :s)

OliveHighlighters.mark_all!(my_hl, "s")
```
To get the result, we call `string` on our `Highlighter`. 
```julia
display("text/html", string(my_hl))
```
## prebuilt highlighters
Alongside the highlighting system, `OliveHighlighters` offers a few built-in highlighters through styling and marking functions.
- `mark_julia!`
- `style_julia!`
- `julia_block!` (combines `mark_julia!` and `style_julia`)
- `mark_markdown!`
- `style_markdown!`
- `mark_toml`
- `style_toml`
## marking functions
- `mark_all!`
- `mark_between!`
- `mark_before!`
- `mark_after!`
- `mark_inside!`
- `mark_for!`
- `mark_line_after!`




