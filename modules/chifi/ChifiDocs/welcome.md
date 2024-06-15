```img
100|center|/ecosystems/images/olivesquare.png
```
```html
<div align="center">
    <h3>chifi docs</h3>
</div>
```
welcome to chifi docs! The **new** *interactive* `chifi` documentation website. This is a centralized source for accessing information on all **6** `chifi` ecosystems. More ecosystems will be coming to this website as they become available.
#### links
- [chifi on github](https://github.com/ChifiSource)
- [chifi blog](https://chifi.dev/)
## overview
We are currently targeting the creation of **6** powerful ecosystems for Julia. Each ecosystem includes a base package and several extensions to further radicalize the capabilities of that base package. Of these ecosystems, three have launched and have packages available for use right now. These three are
- `parametric`
- `toolips`
- `gattino`
### parametric
The `parametric` ecosystem provides a few entirely random packages with a heavy focus on extensibility through parameters. For instance, `ParametricProcesses` provides the `Worker` data-type, which can be assigned to tasks for incredibly high-level parallel computing with a `ProcessManager`. These packages often act as stubs, from which other projects are build features on top of. For instance, `Toolips` uses `ParametricProcesses` for multi-threading, and `Olive` uses `IPyCells` for multi-typed cells.
### toolips
`Toolips` is a declarative full-stack web-development framework centered around extensibility.
### gattino
### olive
## licensing
- All `chifi` software is distributed with the `MIT-0` *ultra-permissive* software license. You are free to do *whatever you want* with `chifi` software, for example you could copy `Toolips` and distribute or modify it without [attribution](https://en.wikipedia.org/wiki/Attribution_(marketing)) or **any other requirements**.
- `chifi` *content* is published under the `Creative-Commons BY 4.0` (*creative commons with attribution*) license. For `chifi` images, documents, and web-pages, we require [attribution](https://en.wikipedia.org/wiki/Attribution_(marketing)), but you are free to use them however you want so long as that attribution is provided. Note the distinction between *webpage* and *software* here -- you are not allowed to deploy `ChifiDocs` by itself, but you could use `ChifiDocs` or `Documator` to create **your own** website and freely distribute this. By using `chifi` documentations and websites, you agree to the `EULA` (*End User License Agreement*).

Keep in mind that `chifi` is an organization, and `chifi` software is no *one-person's* software.

### documator
This documentation website is powered by `Documator`, a `Toolips`-based documentation generator for julia packages. This allows for a lot of enhanced capabilities when it comes to creating documentation. If you would like to learn more about using this package to generate your own documentation, check out the `chifi/Documator` section.