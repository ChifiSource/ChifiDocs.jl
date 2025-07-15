### a storied history
The `ChifiDocs` `0.0.3` update includes *a bit* more than just documentation updates and a minor facelift. This update has also taken a focus on updating many of the underlying web-applications that `ChifiDocs` also hosts, such as this simple `/writeups` page. With the completion of `0.0.3`, an entirely new page will be brought into fruition:
```text
ToolipsApp
```
`ToolipsApp` is a concept application that was replicated in the two former versions of `Toolips`... We are currently in `0.3`, and there was a `ToolipsApp` developed for both `0.2` and `0.1`. This app was meant to be a gallery of example `Toolips` applications -- active demonstrating the capabilities of `Toolips` in both its own design and the apps that it is packaged with. At the same time, the app would feature breakdowns of source code to help users implement the same things into their own websites. In its original form, the app simply featured buttons with each available app:

<img src="https://raw.githubusercontent.com/ChifiSource/ToolipsApp.jl/main/public/toolipsappsc.png" width = "500"></img>

This was an early version of **both** `Toolips` and `ToolipsApp` -- this version is compatible with `Toolips` `0.0.5`. This was an expiremental version of `Toolips`, and this version of `Toolips` predates even the `Component` templating architecture. There was an intermittent version of `ToolipsApp` after this called `ToolipsApp` `V2`. This version of the app was eventually scrapped in favor of the *carousel*.

<img src="https://github.com/ChifiSource/ToolipsApp.jl/raw/ToolipsApp-2/public/Screenshot%20from%202022-06-12%2009-46-47.png" width="250"></img>

This was swiftly followed with the *carousel* version, which is the version most would be familiar with. This version is iconic with its `CarouselArrays`-based gallery exploration system. After all of this time, I still really like the carousel app concept -- there is a chance I may eventually recycle it in some capacity -- whether large or small. Leading up to the latest `ToolipsApp` implementation, which exists as a sub-project within `ChifiDocs` at [/toolipsapp](/toolipsapp), this has been the definitive `ToolipsApp`.

<img src="https://github.com/ChifiSource/ToolipsApp.jl/blob/Unstable/public/tlapp3.png?raw=true" width="600"></img>

The latest version of `ToolipsApp` is even better. Unfortunately, there is currently only one demo app available and this app is relatively minimal being a basic 'guessing game' example. More examples will definitely be added soon.