## what is olive?
`Olive` is an extensible notebook development environment for Julia; an IDE that loads functionality modularly using a *parametric* multiple dispatch system. This allows `Olive` to load new features as new dispatches are loaded. To add `Olive`, use `Pkg`.
```julia
using Pkg; Pkg.add("Olive")

# leap branch..
using Pkg; Pkg.add(name = "Olive", rev = "Leap")
# or Unstable:
using Pkg; Pkg.add(name = "Olive", rev = "Unstable")
```
After adding `Olive` run `start` to start the notebook editor!
```julia
using Olive; Olive.start()
```
- After starting `Olive` a link containing a key will be printed to the REPL, `ctrl` + clicking this link will open the notebook!
## getting started

## controls

## settings

## project explorer