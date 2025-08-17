# LightweightStats.jl

[![Build Status](https://github.com/SciML/LightweightStats.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/SciML/LightweightStats.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/SciML/LightweightStats.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/SciML/LightweightStats.jl)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://SciML.github.io/LightweightStats.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://SciML.github.io/LightweightStats.jl/dev/)

A lightweight Julia package providing basic statistical functions with minimal dependencies. LightweightStats.jl serves as a lower-dependency alternative to Statistics.jl, implementing the same algorithms but without pulling in additional dependencies.

## Installation

```julia
using Pkg
Pkg.add("LightweightStats")
```

## Quick Start

```julia
using LightweightStats

# Basic statistics
x = [1, 2, 3, 4, 5]
mean(x)      # 3.0
median(x)    # 3
std(x)       # ~1.58
var(x)       # 2.5

# Correlation and covariance
y = [2, 4, 6, 8, 10]
cor(x, y)    # 1.0
cov(x, y)    # 5.0

# Quantiles
quantile(x, 0.25)  # 2.0
quantile(x, [0.25, 0.5, 0.75])  # [2.0, 3.0, 4.0]
```

## Features

- **Zero dependencies**: Only requires Julia standard library
- **Essential functions**: mean, median, std, var, cov, cor, quantile, middle
- **Dimension-aware**: Most functions support operations along specific dimensions
- **Type stable**: Maintains appropriate type stability
- **Compatible API**: Matches Statistics.jl function signatures

## Why LightweightStats.jl?

This package is ideal when you need:
- Basic statistical operations without heavyweight dependencies
- Minimal package load time
- Reduced dependency tree for deployment
- Core statistical functions in resource-constrained environments

## Documentation

For detailed documentation, see [https://SciML.github.io/LightweightStats.jl/stable/](https://SciML.github.io/LightweightStats.jl/stable/)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Citation

If you use LightweightStats.jl in your research, please cite:

```bibtex
@software{LightweightStats.jl,
  author = {Rackauckas, Chris and contributors},
  title = {LightweightStats.jl: Lightweight Statistical Functions for Julia},
  url = {https://github.com/SciML/LightweightStats.jl},
  year = {2024}
}
```

## License

MIT License