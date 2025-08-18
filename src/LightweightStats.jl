module LightweightStats

export mean, median, std, var, cov, cor, quantile, middle

# Internal implementation of complex conjugate to avoid LinearAlgebra dependency
_conj(x::Real) = x
_conj(x::Complex) = Complex(real(x), -imag(x))
_conj(x::AbstractArray{<:Real}) = x
_conj(x::AbstractArray{<:Complex}) = _conj.(x)

function mean(A::AbstractArray; dims = :)
    if dims === (:)
        isempty(A) && throw(ArgumentError("mean of empty collection undefined"))
        return sum(A) / length(A)
    else
        return mapslices(mean, A; dims = dims)
    end
end

function mean(f, A::AbstractArray)
    isempty(A) && throw(ArgumentError("mean of empty collection undefined"))
    return sum(f, A) / length(A)
end

# Restricted to Array due to scalar indexing
function median(v::Vector)
    isempty(v) && throw(ArgumentError("median of empty collection undefined"))
    sorted = sort(v)
    n = length(sorted)
    if isodd(n)
        return sorted[(n + 1) ÷ 2]
    else
        return (sorted[n ÷ 2] + sorted[n ÷ 2 + 1]) / 2
    end
end

function median(A::Array; dims = :)
    if dims === (:)
        return median(vec(A))
    else
        return mapslices(median, A; dims = dims)
    end
end

function var(A::AbstractArray; corrected::Bool = true, mean = nothing, dims = :)
    if dims === (:)
        n = length(A)
        isempty(A) && return oftype(real(zero(eltype(A)))/1, NaN)
        m = mean === nothing ? LightweightStats.mean(A) : mean
        s = sum(x -> abs2(x - m), A)
        return corrected ? s / (n - 1) : s / n
    else
        return mapslices(x -> var(x; corrected = corrected, mean = mean), A; dims = dims)
    end
end

function std(A::AbstractArray; corrected::Bool = true, mean = nothing, dims = :)
    return dims === (:) ? sqrt(var(A; corrected = corrected, mean = mean)) :
           sqrt.(var(A; corrected = corrected, mean = mean, dims = dims))
end

function cov(x::AbstractVector, y::AbstractVector; corrected::Bool = true)
    n = length(x)
    length(y) == n || throw(DimensionMismatch("x and y must have the same length"))
    n == 0 && return oftype(real(zero(eltype(x)))/1, NaN)

    xmean = mean(x)
    ymean = mean(y)

    # Use broadcasting instead of scalar indexing
    s = sum((x .- xmean) .* _conj(y .- ymean))
    return corrected ? s / (n - 1) : s / n
end

function cov(x::AbstractVector; corrected::Bool = true)
    return var(x; corrected = corrected)
end

function cov(X::AbstractMatrix; dims::Int = 1, corrected::Bool = true)
    if dims == 1
        n, p = size(X)
        n == 0 && return fill(oftype(real(zero(eltype(X)))/1, NaN), p, p)

        means = vec(mean(X; dims = 1))
        C = zeros(promote_type(Float64, real(eltype(X))), p, p)
        
        # Center the data once using broadcasting
        X_centered = X .- means'

        for i in 1:p
            for j in i:p
                # Use views and broadcasting for column operations
                s = sum(view(X_centered, :, i) .* _conj(view(X_centered, :, j)))
                C[i, j] = corrected ? s / (n - 1) : s / n
                if i != j
                    C[j, i] = _conj(C[i, j])
                end
            end
        end
        return C
    elseif dims == 2
        n, p = size(X')
        n == 0 && return fill(oftype(real(zero(eltype(X)))/1, NaN), p, p)

        means = vec(mean(X; dims = 2))
        C = zeros(promote_type(Float64, real(eltype(X))), p, p)
        
        # Center the data once using broadcasting
        X_centered = X .- means

        for i in 1:p
            for j in i:p
                # Use views and broadcasting for row operations
                s = sum(view(X_centered, i, :) .* _conj(view(X_centered, j, :)))
                C[i, j] = corrected ? s / (n - 1) : s / n
                if i != j
                    C[j, i] = _conj(C[i, j])
                end
            end
        end
        return C
    else
        throw(ArgumentError("dims must be 1 or 2"))
    end
end

function cor(x::AbstractVector, y::AbstractVector)
    length(x) == length(y) || throw(DimensionMismatch("x and y must have the same length"))

    sx = std(x; corrected = false)
    sy = std(y; corrected = false)

    (sx == 0 || sy == 0) && return oftype(real(zero(eltype(x)))/1, NaN)

    return cov(x, y; corrected = false) / (sx * sy)
end

function cor(X::AbstractMatrix; dims::Int = 1)
    C = cov(X; dims = dims, corrected = false)

    if dims == 1
        s = vec(std(X; dims = 1, corrected = false))
    else
        s = vec(std(X; dims = 2, corrected = false))
    end

    # Use broadcasting to compute correlation matrix
    # Create outer product of standard deviations
    s_outer = s * s'
    
    # Handle zero variance cases with broadcasting
    R = similar(C)
    zero_mask = (s_outer .== 0)
    R[zero_mask] .= oftype(real(zero(eltype(X)))/1, NaN)
    R[.!zero_mask] = C[.!zero_mask] ./ s_outer[.!zero_mask]

    return R
end

# Restricted to Vector due to scalar indexing
function quantile(v::Vector, p::Real)
    0 <= p <= 1 || throw(ArgumentError("quantile requires 0 <= p <= 1"))
    isempty(v) && throw(ArgumentError("quantile of empty collection undefined"))

    sorted = sort(v)
    n = length(sorted)

    if p == 0
        return sorted[1]
    elseif p == 1
        return sorted[n]
    else
        h = (n - 1) * p + 1
        i = floor(Int, h)
        if i == n
            return sorted[n]
        else
            return sorted[i] + (h - i) * (sorted[i + 1] - sorted[i])
        end
    end
end

function quantile(v::Vector, p::AbstractVector)
    return [quantile(v, pi) for pi in p]
end

function middle(x::Real, y::Real)
    return (x + y) / 2
end

function middle(a::AbstractArray)
    isempty(a) && throw(ArgumentError("middle of empty collection undefined"))
    return middle(extrema(a)...)
end

function middle(x::Real)
    return x
end

end
