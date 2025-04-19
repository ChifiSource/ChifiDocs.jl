## the process manager
Tasks are distributing using `ParametricProcesses` by adding `Workers` to a `ProcessManager` and then assigning them a `ProcessJob` using `assign!` or `distribute!`. 
```julia
using ParametricProcesses

procs::ProcessManager = processes(4)

sample_job::ParametricProcesses.ProcessJob = new_job() do
    @info "job completed"
end

distribute!(procs, (sample_job for x in 1:30) ...)
```
Above all, this hinges on the `ProcessManager`, a sub-type of the `AbstractProcessManager`. The `ProcessManager` is a simple typed wrapper for a `Vector` containing the **parametric type** `Worker`, also known as `Workers`. Getting the index of a `ProcessManager` by `String` or `Int64` will give us a worker by name or worker id. We create a `ProcessManager` by calling `processes`.
```julia
processes(n::Int64, of::Type{<:Process} = Threaded, names::String ...)
```
Workers may be added using `add_workers!`, we can close a worker directly or close the entire process manager with `close`.
```julia
procs::ProcessManager = processes(4)
close(procs[2])
close(procs)

add_workers!(procs, 2)
```
For convenience, there is also a binding to `delete!` to remove a `Worker` directly from a `ProcessManager`.
```julia
procs::ProcessManager = processes(4)

delete!(procs, 3)
```
`Workers` can be pushed to the `ProcessManager` with `push!`. There is also `create_workers` for only creating workers. Finally, we can use `worker_pids` to get the ID for each `Worker` in a `Vector{Int64}`.
- (it might also be worth checking out the `ProcessError` doc-string.)
## jobs
The `ProcessJob`, a sub-type of `AbstractJob`, is a how we represent the tasks we want our `Workers` to do. We can create a new `ProcessJob` by using the `new_job` constant binding (or the `ProcessJob` constructor, as they are the same thing.)
```julia
job = new_job() do

end

job = ProcessJob() do

end
```
These jobs can be done by the `Workers` in a `ProcessManager` by using `assign!` and `distribute!`. We can also pass arguments into these jobs, making the process a lot simpler.
```julia
function example(x::Int64, y::String)
    y * string(x)
end

jobs = [new_job(example, e, "job #$e") for e in 1:5]
```
Also **make sure** to add any dependencies or values to the other threads by using `put!` and the `@everywhere` macro.
## workers
A `ProcessManager` built with the `processes` function will automatically spawn with `Workers`. If there are no workers, we can use `add_workers!` and `create_workers` to create them. A `Worker` is a **parametric** type that holds its process distribution type as a parameter. `ParametricProcesses` includes the `Async` `Process` and `Threaded` `Process`. Both of these are a sub-type of `WorkerProcess`, which itself is a sub-type of `Process`. Workers will need to have all dependencies and values loaded to them. This can be done using a combination of `@everywhere` and `put!`.
```julia
module SampleMod

do_thing() = print("hello world!")

end

using ParametricProcesses

procs = processes(4)
@everywhere using SampleMod
job = new_job() do
    SampleMod.do_thing()
end

x = 5
put!(pm, x)

second_job = new_job() do
    x += 1
end

distribute!(procs, (job for w in 1:3) ..., (second_job for v in 1:20) ...)
```
Workers can be assigned directly, or through a `ProcessManager` using the following assignment functions, which will take a `ProcessJob`:
- `assign!` will assign the `ProcessJob` to a worker directly by `pid` or name.
- `assign_open!` will assign the `ProcessJob` to the first open worker, if no worker is available it will assign it as the next task of the final `Worker`. Note that this only works inside of a `ProcessManager`.
- `distribute!` will distribute the jobs to the threads as evenly as possible.
- `distribute_open!` will do the same as `distribute!`, only it will only distribute to threads that are currently open. This one will also only work with a `ProcessManager`.

In addition to closing an entire `ProcessManager`, we can close a `Worker` directly using the `close` function. As for thread concurrency and timing, to wait for a worker to finish a specific task we use the `waitfor` function.
```julia
pm = processes(4)

jb = new_job() do 
    sleep(10)
    @info "hello world!"
    return 55
end

assign!(pm, 2, jb)

ret = waitfor(pm, 2); println("worker 2 completed, it returned: ", ret[1])

# From worker 2:	[ Info: hello world!
# worker 2 completed, it returned: 55
```
After a return is evaluated, the worker stores it and we can retrieve the return using `get_return!`.
## extending
Given it is part of the [parametric](/parametric) ecosystem, this package is built with parametric extensibility in mind. Aside from all of the types having an abstraction hierarchy another type system could easily integrate with, the fundamental way to extend this package is by adding a new `Process` type. There will likely be extensions in this regard coming at some point in the future. First, we would create a new `Process` type...
```julia
abstract type CUDA <: ParametricProcesses.Process end
```
... then we would need to implement the following essential functions:
- `create_workers`
- `waitfor`
- `put!`
- `assign!`
- and `distribute!`

