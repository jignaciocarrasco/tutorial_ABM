## Future "import.jl" script. Importing and data management

function load_lamp(path_stats, path_micro) # add start and end dates.
	# Now all models (including the event_international contain the same number of vars)
	# Therefore, no need to specify destination in function parameters.
	init_var = 3
	end_var = 34

	stats = CSV.read(path_stats, DataFrame)
	vars_interest =  stats[init_var:end_var, 1]

	data = CSV.read(path_micro, DataFrame)
	data = select(data, "id_pers", "year", vars_interest, "weight")
	lamp = Dict{String, Vector}()

	for row in eachrow(data)
		if haskey(lamp, row[1])
			push!(lamp[row[1]], row[2:end])
	    else
			lamp[row[1]] = [ row[2:end] ]
		end
	end
	start_micro = minimum(map(x -> x[1][1], values(lamp)))
	end_micro = maximum(map(x -> x[1][1], values(lamp)))
	lamp, start_micro, end_micro
end

# person_years is a Vector{DataFrameRow} from the LAMP data
weight(person_years) = round(Int, person_years[1][end])
birth_year(person_years) = person_years[1][1]

# This makes life easier down the line, plus the program more efficient. Also,
# this way we can cut out year and weight, so values is really only values.
"convert list of person years from LAMP data (DataFrameRow) to Vector{Float}"
lamp_to_values(person_years) = map(x->Vector{Float64}(x)[2:end-1], person_years)

function load_macro(path_stats, path_macro) # add start and end dates; minimum and maximum values of arrays.

	init_var = 35
	end_var = init_var + 5

	stats = CSV.read(path_stats, DataFrame)
	vars_interest =  stats[init_var:end_var, 1]

	data_macro = CSV.read(path_macro, DataFrame)
	macro_values = Array(select(data_macro, "year", vars_interest))
	start_macro = minimum(macro_values[:,1])
	end_macro = maximum(macro_values[:,1])
macro_values, start_macro, end_macro
end

function load_stats(path, dest)
	# Factors are selected depending on the destination of interest.
	# We only need the position of the first factor.
	if dest == "Intraregional"
		init_micro_var = 43
	elseif dest == "USA"
		init_micro_var = 83
	elseif dest == "Spain"
		init_micro_var = 123
	end

   end_micro_var = init_micro_var + 31
   init_macro_var = end_micro_var + 1
   end_macro_var = init_macro_var + 5
   stats = CSV.read(path, DataFrame)
   micro_factors = parse.(Float64, stats[init_micro_var:end_micro_var, 2])
   macro_factors = parse.(Float64, stats[init_macro_var:end_macro_var, 2])
   offset = parse.(Float64, stats[end,2])
   micro_factors, macro_factors, offset
end