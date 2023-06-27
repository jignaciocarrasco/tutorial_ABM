## packages to be used
using CSV
using DataFrames
using Random
using Parameters
using Distributions
using StatsBase
using Plots

##scripts splitted according to task. 
	# Previously: include("abm_lamp.jl")
include("import.jl")
include("params.jl")
include("model.jl")
include("setup.jl")

#Simulation struct.
#add cohort and lamp data.
# data type is complicated and might change => keep as parameter
# (alternatives would be writing it out ( :-( ) or keeping it
# generic (slow, error-prone!))
mutable struct Simulation{DT}
    pop :: Vector{Person}
	# person_id => [person_years]
	lamp_data :: Dict{String, DT} # slot to be used by the "DataFrame row type"
	# year => number of active persons
	cohort :: Vector{Int}
	# year => [person_years]
	cohort_pop :: Vector{Vector{DT}}
end

function run_sim(path_micro, path_macro, path_stats, years, seed, dest,
	override_micro_factors, override_macro_factors; use_weights = true, verbose = false)

	lamp, start_micro, end_micro = load_lamp(path_stats, path_micro) # add local values on min and max as return values.
	macro_values, start_macro, end_macro = load_macro(path_stats, path_macro)
	rescaled = start_macro - start_micro + 1
	micro_factors, macro_factors, offset = load_stats(path_stats, dest)

	# change factors from data (scenarios)
	for (key, value) in override_micro_factors
		micro_factors[key] = value
	end

	for (key, value) in override_macro_factors
		macro_factors[key] = value
	end

	# final values to be used in decision model
	factors = vcat(offset, micro_factors, macro_factors)
	parameters = Params(length(lamp), factors, macro_values)

	#Creating population and sim objects.
	sim = setup_sim(lamp, seed, use_weights = use_weights)

	d_mig = Int[]
	n_nomig = Int[]
	n_dead = Int[]
	#mean_probs = Float64[]

	for year in 1:years
		# add if to exclude agents lower than min macro. add min macro as parameter of update agents.
		add_agents!(sim.cohort_pop[year], sim.pop, use_weights = use_weights)
		if year >= rescaled # dont update agents before start_macro
			#nmigration_events, mean_prob = update_agents!(sim, year, parameters, start_micro, start_macro)
			nmigration_events = update_agents!(sim, year, parameters, start_micro, start_macro)
			push!(d_mig, nmigration_events)
		else
			push!(d_mig, 0)
		end
		#push!(n_mig, count(p -> p.status == migrant, sim.pop))
		push!(n_nomig, count(p -> p.status != migrant && p.status != inactive, sim.pop))
		push!(n_dead, count(p -> p.status == inactive, sim.pop))
		if verbose
			println(year, ", ", n_mig[end], ", ", n_nomig[end])
	   end
   	end
	n_mig = cumsum(d_mig)
	#d_mig = n_mig[2:end] .- n_mig[1:end-1]
	@assert length(d_mig) == years
	@assert length(n_nomig) == years
	#n_mig, n_nomig, d_mig./n_nomig, sim.pop, sim.cohort, d_mig, n_dead, mean_probs
	# change in cummit rate.
	n_mig, n_nomig, d_mig./(d_mig .+ n_nomig), n_mig./(n_mig .+ n_nomig), sim.pop, sim.cohort, d_mig, n_dead, rescaled
end

## Two functions to analyze data

# Transform vector seeds to data frames
function DF_rates(vector_rates)
	df = DataFrame(zeros(length(vector_rates[1]), length(vector_rates)), :auto) 

	for index in 1:length(vector_rates)
	df[:, index] = vector_rates[index]
	end
	df
end

# RMSE function
function RMSE(empirical_rate, estimated_rate)
	rmse_1 =  sqrt(sum((empirical_rate - estimated_rate).^2) / (length(empirical_rate)))
end

## Run set of seeds using a function
	# Function run_seeds

function run_seeds(path_micro, path_macro, path_stats, override_micro_factors, override_macro_factors, nb_of_seeds)

# Empty vectors where to put each of the seeds results. 
	# Vector will contain one-dimension vectors. 
	vector_n_mig = []
	vector_mig_rate = []
	vector_cummig_rate = []
	
# Run simulation x number of times ("nb_seeds") of times.
	# Only request mig_rates and cummig_rates
	for seed in 1:nb_of_seeds
		n_mig, n_nomig, mig_rate, cummig_rate, pop, cohort, d_mig, n_dead, rescaled = run_sim(path_micro, path_macro, path_stats, 78, seed, "Spain", override_micro_factors, override_macro_factors);
		push!(vector_n_mig, n_mig[32:end])
		push!(vector_mig_rate, mig_rate[32:end])
		push!(vector_cummig_rate, cummig_rate[32:end])
	end
	
# Transform vectors into dataframes to export
	# Push vector into a larger vector.
	vector_vars = []
	push!(vector_vars, vector_n_mig)
	push!(vector_vars, vector_mig_rate)
	push!(vector_vars, vector_cummig_rate)

	# Loop across vector_vars to 
	vec_dfs = []
	for vec in vector_vars 
		push!(vec_dfs, DF_rates(vec))
	end

	vec_dfs

end



