## creating choropleths
`GattinoPleths` is an extension that provides a simple choropleth interface for `Gattino`. Choropleths must be plotted atop an `AbstractChoroplethResource`, `GattinoPleths` includes the `ChoroplethResource` and the `RemoteChoroplethResource`. These resources simply include style definition names and `svg` files to bind to them. `Gattino` provides  a few useful default maps... `usa_map`, `world_map`, and `euro_map` are all predefined `ChoroplethResources` available in `GattinoPleths`. More remote resources will be available [here](#https://github.com/ChifiSource/GattinoPleths-Resources) in the future. A `RemoteChoroplethResource` can be downloaded using `download_resource`.

To create a choropleth, we provide this resource to `choropleth` along with `x` and `y` values. The `x` will always be lower-case abbreviations with *official* `GattinoPleths` resources.
```julia
using GattinoPleths

local_euro_resource = download_resource(GattinoPleths.europe_map)

# we can also skip the `download_resource` step to implicitly download the file 
#   under the `RemoteChoroplethResource`'s `name`.
x = ["it", "uk", "fr", "de"]
y = [50, 22, 33, 95]
result = choropleth(x, y, local_euro_resource)
GattinoPleths.choropleth_legend!(result, "dry" => "wet")
result
```

`plethsample`

## additional features
- We can also add a legend to a `choropleth` visualization with `choropleth_legend!`,
- and scale our visualization using `scale!`
- It might also be worth looking into `Gattino.make_gradient` for this package!

