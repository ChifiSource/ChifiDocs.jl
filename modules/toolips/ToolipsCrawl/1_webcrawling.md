## scraping and crawling
`ToolipsCrawl` provides a simple web-crawling and web-scraping API, built atop the `Toolips` web-development framework. We use the `scrape` function to perform a single website, and the `crawl` function to continue finding websites from that website until we cannot find anymore. Both `scrape` and `crawl` will be passed a `Function`. This `Function` will take a `Crawler` as an argument. Within this function we may use `get_by_tag` and `get_by_name` on the `Crawler` to get vectors of the `Component` by name or tag. So all we need to crawl is
- `crawl`
- `get_by_tag`
- `get_by_name`
Both `get_by_name` and `get_by_tag` will provide a `Vector{Component}`. The arguments, such as hrefs, and the text are preserved.
###### scrape example
```julia
using ToolipsCrawl
rows = []
scrape("https://github.com/ChifiSource") do c::Crawler
    current_rows = get_by_tag(c, "td")
    for row::ToolipsCrawl.Component{:td} in current_rows
        push!(rows, row[:text])
    end
end
```
###### crawl example
```julia
using ToolipsCrawl
titles = []
crawler = crawl("https://chifidocs.com") do crawler::Crawler
    title_comps = get_by_tag(crawler, "title")
    if length(title_comps) > 0
        @info "scraped title from " * crawler.address
        push!(titles, title_comps[1][:text])
    end
end
```
## stopping crawlers
Once a `Crawler` is started, it can be stopped by calling `kill!` on it:
```julia
ToolipsCrawl.kill!(crawler)
```
## internal
Here is a list of internal bindings, which are quite minimal:
- `AbstractCrawler`
- `scrape!`
- `crawl!`
