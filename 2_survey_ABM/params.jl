## Params
@with_kw struct Params
	n :: Int64 #Total population
	factors :: Vector{Float64} = []
    macro_values :: Matrix{Float64} = []
end

