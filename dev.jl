using Pkg; Pkg.activate(".")
using Revise
using Toolips
using ChifiDocs
toolips_process = start!(ChifiDocs, "192.168.1.10":8000)
