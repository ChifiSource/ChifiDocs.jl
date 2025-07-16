## time
```julia
start(scheduler::Scheduler, mods::Any ...; threads::Int64 = 1, async::Bool = true)
start(t::Task ..., args ...; keyargs ...)
start(path::String = pwd() * "config.cfg", mods::Any ...; keyargs ...)
```
Though `ParametricScheduler` is primarily intended for use *from configuration files*, it is possible to schedule tasks using the API. We start by creating our time type, which will be either `DateTime` or `RecurringTime`. For a `DateTime`, we provide the same seven values we mentioned before.
- 1. `Year`
  2. `Month`
  3. `Day`
  4. `Hour`
  5. `Minute`
  6. `Second`
  7. `Millisecond`

`ParametricScheduler` exports `Method` and `struct`s for these intervals, e.g. `Year` and `year`. `Year` would be used to construct a `Year` interval and `year` would be used *to get the year* from a `DateTime`. `ParametricScheduler` exports *all* of these. These constructed intervals will be provided to `RecurringTime`, or can be used arithmetically with `DateTime`. 
```julia
using ParametricScheduler
# one year from now
d = now() + Year(1)
# every year from now on
my_time = RecurringTime(now(), Year(1))

# getter example:
minute_of_now::Int64 = minute(d)
```
For *getters*, we simply call the *getter* on our `DateTime`.
- `year`
- `month`
- `day`
- `hour`
- `minute`
- `second`
- `millisecond`
```julia
using ParametricScheduler
# 5 A.M. on the first of January, 2025
my_time = DateTime(2025, 1, 1, 5, 0, 0, 0)
```
To create a `RecurringTime`, we provide a start time (another `DateTime`) and an interval from that start time. 
```julia
#                                                (every hour)
my_time = RecurringTime(DateTime(2025, 1, 1, 5, 0, 0, 0), Hour(1))
```
## tasks
After creating a time, we call `new_task` to create a task from that time.
```julia
new_task(f::Function, t::Any, args ...; keyargs ...)
```
```julia
my_task = new_task(println, now(), "hello scheduler!")
```
## scheduler
Now we can provide this new task to `Scheduler` to create a new `Scheduler`, or we could provide these tasks directly to `start` and get a *started* `Scheduler` in return. When we choose the former, we still need to call `start` on the `Scheduler` to start its process.
```julia
unstarted_sched = Scheduler(my_task)

started_sched = ParametricScheduler.start(my_task)

started_sched2 = ParametricScheduler.start(unstarted_sched)
```
There is also `add_tasks!` and `remove_task!`. `add_tasks!` works as expected, all tasks are provided (not as a `Vector`) directly to this function. `remove_task!` can remove tasks by date or enumeration. The tasks are available via `Scheduler.jobs`.
```julia
remove_task!(sched::Scheduler, date::Dates.DateTime)
remove_task!(sched::Scheduler, num::Int64)
add_tasks!(sched::Scheduler, tasks::Task ...)
```
Finally, to `close` our scheduler we use `close(::Scheduler)`.
```julia
close(started_sched)
close(started_sched2)
```
We can also save a scheduler to a file using `save_config` or read tasks directly from a file using `start`.

