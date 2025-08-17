```@meta
CurrentModule = LightweightStats
```

# LightweightStats.jl

A lightweight Julia package providing basic statistical functions with minimal dependencies.

## Overview

LightweightStats.jl is designed as a lower-dependency alternative to Statistics.jl, providing essential statistical functions without pulling in additional dependencies. This makes it ideal for projects that need basic statistical operations but want to minimize their dependency footprint.

## Installation

```julia
using Pkg
Pkg.add("LightweightStats")
```

## Quick Start

```julia
using LightweightStats

# Calculate mean
x = [1, 2, 3, 4, 5]
mean(x)  # Returns 3.0

# Calculate median
median(x)  # Returns 3

# Calculate standard deviation
std(x)  # Returns ~1.58

# Calculate correlation
y = [2, 4, 6, 8, 10]
cor(x, y)  # Returns 1.0 (perfect correlation)
```

## Features

- **Basic descriptive statistics**: mean, median, middle
- **Dispersion measures**: variance (var), standard deviation (std)
- **Correlation and covariance**: cor, cov
- **Quantiles**: quantile function for computing percentiles
- **Dimension-aware operations**: Most functions support the `dims` keyword for operations along specific dimensions
- **Type stability**: Functions maintain type stability where appropriate
- **Zero dependencies**: Only requires Julia standard library

## Functions

### Central Tendency
- `mean(x)` - Arithmetic mean
- `mean(f, x)` - Mean of `f` applied to elements
- `median(x)` - Median value
- `middle(x)` - Middle of the range (min + max) / 2

### Dispersion
- `var(x; corrected=true)` - Variance
- `std(x; corrected=true)` - Standard deviation

### Correlation and Covariance
- `cov(x, y; corrected=true)` - Covariance between vectors
- `cov(X; dims=1, corrected=true)` - Covariance matrix
- `cor(x, y)` - Correlation between vectors
- `cor(X; dims=1)` - Correlation matrix

### Quantiles
- `quantile(v, p)` - Compute the p-th quantile
- `quantile(v, ps)` - Compute multiple quantiles

## Example Usage

```julia
using LightweightStats

# Working with arrays
data = randn(100)
println("Mean: ", mean(data))
println("Median: ", median(data))
println("Std Dev: ", std(data))

# Working with matrices
X = randn(10, 3)
println("Column means: ", mean(X; dims=1))
println("Row means: ", mean(X; dims=2))

# Correlation matrix
C = cor(X; dims=1)
println("Correlation matrix: ", C)

# Quantiles
q = quantile(data, [0.25, 0.5, 0.75])
println("Quartiles: ", q)
```

## Performance

LightweightStats.jl aims to provide efficient implementations while maintaining simplicity and readability. The implementations are based on the algorithms used in Statistics.jl but without the additional dependency overhead.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.