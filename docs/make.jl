using BasicStats
using Documenter

DocMeta.setdocmeta!(BasicStats, :DocTestSetup, :(using BasicStats); recursive=true)

makedocs(;
    modules=[BasicStats],
    authors="ChrisRackauckas <contact@chrisrackauckas.com>",
    sitename="BasicStats.jl",
    format=Documenter.HTML(;
        canonical="https://ChrisRackauckas-Claude.github.io/BasicStats.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/ChrisRackauckas-Claude/BasicStats.jl",
    devbranch="main",
)