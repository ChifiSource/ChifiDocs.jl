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
The **settings** menu is collapsible from the top-bar icon aligned on the right (by default,) this menu provides options for customizing or modifying things like keybindings, root settings, or themes. Settings are organized into collapsible sections. Two things to note:
- `creator keys` are cell hot-keys that are used to create new cells.
- and not *all* keys or key combinations are going to work for the `keybindings` section -- keep in mind the web-browser has different bindings.
## controls
Using cells is simple. By default, olive bindings (mostly) use `ctrl` alone for window features, `ctrl` + `shift` to do things inside of `Cell`, and `shift` to work with the `Project`.

Here is the keymap, with a reflection of this separation:
- **window bindings**
  - `ctrl` + `S` **save selected project**
  - `ctrl` + `z` cell **undo**
  - `ctrl` + `y` cell **redo**
  - `ctrl` `shift` + `E` **explorer**
- **cell bindings**
  - `ctrl` + `Shift` + `S` **save project as**
  - `ctrl` + `shift` + `Delete` **delete selected cell**
  - `ctrl` + `shift` + `Enter` **new cell**
  - `ctrl` + `shift` + `↑` **move cell up**
  - `ctrl` + `shift` + `↓` **move cell down**
  - `ctrl` + `Shift` + `F` cell **search** 
  - `ctrl` + `Shift` + `O`  cell **open** (open-ended binding, used for extensions -- doesn't do anything for base `Olive` cells)
  - `ctrl` + `Shift` + `A` cell **select**
  - `ctrl` + `C` cell **copy**
  - `ctrl` + `V` cell **paste**
- **cell text bindings**
  - `shift` + `Enter` **run cell**
  - `shift` + `↑` **shift focus up**
  - `shift` + `↑` **shift focus down**
  - `ctrl` + `C` **cell undo**
  - `ctrl` + `Y` **cell redo**
  - `ctrl` + `C` **cell copy**
  - `ctrl` + `V` **cell paste**
  - `ctrl` + `X` **cell cut**

  - Keep in mind these bindings are editable!
## project explorer
The last important thing to cover for `Olive` is the **project explorer**. The **project explorer** is a file explorer built into the side of `Olive` that is revealed by clicking the small file icon on the left side of the **topbar**. For a root user starting `Olive` for the first time, the `ProjectExplorer` will start with two new directories; the `:pwd` directory and the `:home` directory. The `:pwd` directory is the *current working directory* of our `Olive` session. At the top of the `:pwd` button is a `+` button, used to create new files and directories. Each directory within this directory will appear under the collapsible as a black preview -- double click this directory to `cd` to that directory.

We can also *save* a directory, and this will save the directory for our current session. Clicking the save icon on an already saved directory again will add that directory to our group -- this can also be edited inside of the [settings](#settings) for each group if we are root. The button next to `save` is the `cdto` button, which will cd to that directory on click.

As for the `:home` directory, it works quite differently. Like other saved directories, there is a `cdto` button on the home directory. There is also a `run` button and another `add` button. This `add` button doesn't add files, it adds **extensions**. This button lets us quickly install extensions by simply typing their name. This will completely load the extension into our project current `Olive` for us automatically, performing the steps of [installing extensions](#installing-extensions) automatically for us. Extensions can be added here by name *or* by URL. Once the extension is added, we can use the `run` button. The `run` button is used to reload the current `olive` module, which is a containerized environment the `Olive` notebook runs inside of that is created from `src/olive.jl` in your `Olive` home.
## installing extensions
To add extensions to your `Olive`, 
