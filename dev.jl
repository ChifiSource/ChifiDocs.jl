using Pkg; Pkg.activate(".")
using Revise
using ChifiDocs
using Documator

toolips_process = Documator.start_from_project(".", ChifiDocs, ip = "192.168.1.10":8000)
