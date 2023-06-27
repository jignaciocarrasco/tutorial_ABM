## setup.jl

function agent_from_lamp(person_years)
	agent = Person(birth_year(person_years))
	agent.values = lamp_to_values(person_years)
	agent
end

# Add full cohort
function add_agents!(cohort_pop, pop; use_weights = true)
	if length(cohort_pop) == 0
		return
	end

	for person_years in cohort_pop
		w = use_weights ? weight(person_years) : 1
		# Push as many agents as the weight from lamp into pop. (please confirm @Martin)
		for j in 1:w
			push!(pop, agent_from_lamp(person_years))
		end
	end
end

# Actual loading into agents.
# For loop for push written more efficiently.
function setup_sim(data, seed; use_weights = true)
	# find out which type of data we are working on
	DType = valtype(data)

	# number of individuals entering the population per year
	cohort = zeros(Int, 130) # Vector with zeros.

	# actual data by year
	# this could be abbreviated as:
	# cohort_pop = [ Vector{DType}() for i in 1:130 ]
	cohort_pop = Vector{Vector{DType}}() # Vector with empty vectors.
	for i in 1:130 # to account for all agents and their person-years
		push!(cohort_pop, Vector{DType}()) # Manually defining cohort_pop
	end

	# person_years has type DType (which is actually Vector{DataFrameRow})
	for (person_id, person_years) in data
		# year we are dealing with
		index = floor(Int, birth_year(person_years)) - 1929 # 1929 is hardcoded! Change?
		# count
		cohort[index] = cohort[index] + (use_weights ? weight(person_years[1]) : 1)
		# and add to data by "birth" year
		# TODO? maybe already convert to Vector{Float} at this point
		push!(cohort_pop[index], person_years)
	end

	Random.seed!(seed)
	sim = Simulation(Person[], data, cohort, cohort_pop) # remember that last statement is the returned value.
end