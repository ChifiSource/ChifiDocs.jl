## what is olive?
`Olive` is an extensible notebook development environment for Julia; an IDE that loads functionality modularly using a *parametric* multiple dispatch system. This allows `Olive` to load new features as new dispatches are loaded. To add `Olive`, use `Pkg`.
```julia
using Pkg; Pkg.add("Olive")

# leap branch..
using Pkg; Pkg.add(name = "Olive", rev = "Leap")
# or Unstable:
using Pkg; Pkg.add(name = "Olive", rev = "Unstable")
```
After adding `Olive` run `start` to start the notebook editor. If we do not provide the `headless` key-word argument, we will be asked for a name and our `olive` directory will be created. There are also `path` and `wd` for changing the `olive` and `working` directory.
```julia
using Olive; Olive.start()
```
- After starting `Olive` a link containing a key will be printed to the REPL, `ctrl` + clicking this link will open the notebook!
## getting started
Upon starting `Olive`, we are greeted with the `get started` screen. This screen will hold our recent projects and also some information on our `Olive` version. We can also *focus* the cell (by clicking it) and use `shift` + `Enter` (**evalutate**, see [controls](#controls)) to create a new project. The `get started` area represents a `Cell`. The window holding get started cell represents a `Project`. We use tabs to navigate and control projects. Double click a tab to reveal its controls.

The area holding our projects (in multiple panes, including the tabs) is called **session**. On top of **session** is the **topbar**. The **topbar** has two icon buttons for opening menus; the [project explorer](#project-explorer) and the [settings](#settings) menu. These menus are revealed with a click.
## settings
The **settings** menu is collapsible from the top-bar icon aligned on the right (by default,)
## controls



## project explorer