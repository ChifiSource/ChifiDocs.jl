#== components.jl
`components.jl` is a special source file (specific to this project and loaded in dev.jl) 
which allows us to build custom components into our markdown documentation pages and load dependencies to use in our documentation pages..
Make sure to only export components, interpolate by name into markdown using $, and in Julia using `interpolate!` or `interpolate_code!`.
`$`.
==#
"""
#### ChifiDocs !
chifi docs is a documentation site for `chifi` software created using `Documator`, a 
    documentation website generator powered by the `Toolips` web-development framework.

"""
module ChifiDocs
using Documator
using Toolips
using Toolips.ToolipsServables
using ChifiDocs
using ToolipsSession
using Gattino

"""
#### chifi !
##### an open source software dynasty
"""
function chifi end

"""
---
#### chifi 
## 'End-User License-Agreement'
---
##### article I: Establishment
The Establishing Rights-Holder, henceforth known as **CHIFI - AN OPEN SOURCE SOFTWARE DYNASTY**, sets consistent and reasonable terms for usage of its software, web-pages, or assets. 
- **Software** refers to any plain-text content which CHIFI - AN OPEN SOURCE SOFTWARE DYNASTY publishes under the `MIT` software license.
- **Web-pages** refer to any document intended for direct deployment on a server belonging to CHIFI - AN OPEN SOURCE SOFTWARE DYNASTY. This does **not** include dependencies.
By using, duplicating, or sharing CHIFI - AN OPEN SOURCE SOFTWARE DYNASTY software, web-pages, the Licensee -- henceforth known as **THE CLIENT** -- agrees to the terms of this End-User License-Agreement. 
If the terms of this agreement are breached by either party, this will henceforth be known as a **VIOLATION**. CHIFI - AN OPEN SOURCE SOFTWARE DYNASTY reserves the right to terminate or suspend THE CLIENT
if THE CLIENT is found to be in VIOLATION of this agreement, as outlined in ARTICLE V of this document.
##### article II: Data and Privacy
- **DATA** refers to personal information, system information, and stored information in relation to THE CLIENT.
- **PRIVACY** refers to the reasonable expectation of privacy and anonimity people expect from the internet.
THE CLIENT retains all rights and expectations of privacy in relation to their **DATA**. CHIFI - AN OPEN SOURCE SOFTWARE DYNASTY, as per this agreement, receives open content licenses for the following data:
- **PUBLIC IPv4 ADDRESS**
- **COUNTRY** (via IPv4)
- **OPERATING SYSTEM NAME**
- **PROVIDED NAME**
- **PASSWORD**
- **STORED USER DATA**

As per this agreement, this is **the length** to which CHIFI - AN OPEN SOURCE SOFTWARE DYNASTY is permitted to collect.
##### article III: Content Licensing

##### article IV: Software Licensing

##### article V: Licensee Rights

"""
function EULA end

"""
### this sample was retrieved!
"""
function sample end


components = Vector{AbstractComponent}()

gat_scat = Gattino.scatter(randn(50), randn(50), xlabel = "randn()", ylabel = "randn()", title = "random numbers").window
eula_raw = @doc EULA

gat_scat.name = "gattino-scatter"
EULA_comp = tmd("chifi-EULA", string(eula_raw))
push!(components, EULA_comp, gat_scat)
export ChifiDocs, sample, Toolips, chifi, EULA, components
end