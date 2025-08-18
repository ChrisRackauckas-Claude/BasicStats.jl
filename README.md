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

## Why Does Statistics.jl Have a LinearAlgebra Dependency?

Statistics.jl requires LinearAlgebra.jl for specific mathematical operations in covariance and correlation computations. Here's exactly where and why:

### Complex Number Support
Statistics.jl uses [`conj()`](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L502) from LinearAlgebra to handle complex conjugates in covariance calculations:
- **Line 501-502**: [`_conj()` wrapper function](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L501-L502) that returns `conj(x)` for complex arrays
- **Line 592**: [Documentation](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L592) explains the formula uses complex conjugate: `(x_i - mean(x)) * conj(y_i - mean(y))`

### Matrix Operations
LinearAlgebra provides optimized matrix operations used in multivariate statistics:
- **Line 520**: [`unscaled_covzm`](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L520) uses `x'x` (adjoint multiplication) for covariance matrices
- **Line 525**: [`adjoint()`](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L525) for matrix-vector products
- **Line 528**: [`transpose()`](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L528) for real matrix operations
- **Line 532**: [Mixed operations](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L532) combining `transpose()` and `adjoint()`
- **Line 626**: [Hermitian symmetry](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L626) enforcement with `adjoint()`

### Import Statement
- **Line 10**: [`using LinearAlgebra, SparseArrays`](https://github.com/JuliaLang/Statistics.jl/blob/v1.11.1/src/Statistics.jl#L10) imports the required functions

## How LightweightStats.jl Handles These Operations Differently

LightweightStats.jl avoids the LinearAlgebra dependency by making specific implementation choices:

### 1. Real Numbers Only
- **No complex conjugate support**: LightweightStats.jl's [`cov()` function](src/LightweightStats.jl#L55-L65) uses simple multiplication `(x[i] - xmean) * (y[i] - ymean)` without conjugation
- This means it doesn't correctly handle complex-valued data, but avoids needing `conj()`

### 2. Explicit Loops Instead of Matrix Operations
- **Manual iteration**: Instead of using optimized matrix products like `x'x`, LightweightStats.jl uses [explicit loops](src/LightweightStats.jl#L79-L84):
  ```julia
  for i in 1:p
      for j in i:p
          s = sum((X[k, i] - means[i]) * (X[k, j] - means[j]) for k in 1:n)
          C[i, j] = C[j, i] = corrected ? s / (n - 1) : s / n
      end
  end
  ```
- This avoids needing `adjoint()` and `transpose()` but may be slower for large matrices

### 3. Simplified Type Handling
- Statistics.jl uses specialized methods for different array types and complex numbers
- LightweightStats.jl treats all inputs as real, simplifying the implementation but limiting functionality

### Trade-offs
- **Pros**: Zero dependencies, faster load time, simpler deployment
- **Cons**: No complex number support, potentially slower for large matrices, less optimized for special matrix types

Without LinearAlgebra, Statistics.jl would need to reimplement these mathematical operations, duplicating code and potentially losing performance optimizations. LightweightStats.jl makes the pragmatic choice to support only real-valued statistics in exchange for eliminating dependencies.

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