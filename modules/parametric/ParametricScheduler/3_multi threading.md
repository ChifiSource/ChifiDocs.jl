It is assumed that **all** assigned functions will be loaded into `Main`; this means including your functions before assigning them as jobs and distributing them. When it comes to multi-threading, we use `mod` arguments to include our functions. This may be done from a configuration file or provided as arguments. Threads will **not** be able to run functions that are not loaded by provided the `Module` or include path to `mods`.
- `mods` in configuration file:
```julia
activate .
using Pkg
include fns.jl
3 6 7 sampletwo "hi1"
3 6 4 sampletwo "hi2"
3 4 24 Pkg.instantiate
```
- `mods` in API:
```julia
using ParametricScheduler
using TOML
# make sure to also include on the main thread (if not, you will get a failed to run task warning):
include("fns.jl")
# the `mods` key-word argument is specific to this dispatch.
ParametricScheduler.start(sched, new_task(println, now(), "hello scheduler!"), mods = ["fns.jl", TOML] threads = 4)
```

