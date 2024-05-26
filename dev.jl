using Pkg; Pkg.activate(".")
using ChifiDocs
Pkg.activate("chifi")
using Revise
include("chifi/components.jl")
toolips_process = ChifiDocs.start_from_project("chifi", ChifiDocComponents, ip = "192.168.1.10":8000)
