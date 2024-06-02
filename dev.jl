using Pkg; Pkg.activate(".")
using Revise
using ChifiDocs
Pkg.activate("chifi")
include("chifi/components.jl")
toolips_process = ChifiDocs.start_from_project("chifi", ChifiDocComponents, ip = "192.168.1.10":8000)
