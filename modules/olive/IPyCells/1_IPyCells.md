## cells
The `IPyCells` package's type system revolves around the `Cell` and `AbstractCell` types. A `Cell` is a **parametric type** that represents a cell of any type within a notebook. Cells are typed using a type parameter; a standard julia code cell will use `:code` and a standard markdown cell will use `:markdown`. Cells also have an `id`, `source`, and `outputs`. `source` and `id` **must** be strings, whereas `outputs` may be of any type. `string` is binded to each `Cell`, and this will print the cells into `Olive` format. A `Vector` of cells **can also** be indexed by `id` in the form of a `String`.
## read and write
Along with these cells, `IPyCells` provides several reading and writing functions for turning those cells into different file types or reading them from different file types. There are functions binded for both read and parse for each file type, as well as a binding for writing `Olive` and `ipynb`. **None** of these are exported.
- `parse_pluto`
- `read_pluto`
- `parse_olive`
- `read_olive`
- `parse_julia`
- (note that read_jl will deliniate whether or not a `.jl` file is `Pluto`, `Olive`, or plain Julia.)
- `read_jl`
- `read_ipynb`
- `save`
- `save_ipynb`

These last two functions convert a `.ipynb` directly to a Julia file, or the inverse (this was the original purpose for the package before it became the package behind `Olive`, so the feature has been retained):
- `ipyjl`
- `jlipy`