using BasicStats
using Documenter

DocMeta.setdocmeta!(BasicStats, :DocTestSetup, :(using BasicStats); recursive=true)

makedocs(;
    modules=[BasicStats],
    authors="ChrisRackauckas <contact@chrisrackauckas.com>",
    sitename="BasicStats.jl",
    format=Documenter.HTML(;
        canonical="https://SciML.github.io/BasicStats.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/SciML/BasicStats.jl",
    devbranch="main",
)