@enum Status potential intention migrant inactive
mutable struct Person
	id :: String
	birth_year :: Int
	values :: Vector{Vector{Float64}}
	status :: Status
end

Person(birth_year) = Person("", birth_year, [[]], potential)

# this is the core of the decision model
"Calculate decision probability based on log-odds `z = f0 + f1 * v1 + f2 * v2 + ...`"
function evaluate(values, factors)
    @assert length(factors) == length(values) + 1
	# offset/intercept
	result = factors[1]

	# log odds
	for (f, v) in zip(factors[2:end], values)
		result += f * v
	end

	# calculate probability from log odds
	1/(1+exp(-result))
end

# Update functions
# Simulation year and not actual historical year.
function update_potential!(person, year, par, start_micro, start_macro)
	# nth year in person's data
	person_year = (year - (person.birth_year - start_micro))
	@assert person_year > 0
	index_macro = year - (floor(Int, start_macro) -  start_micro)
	all_values = vcat(person.values[person_year], par.macro_values[index_macro, 2:end])
	# computes outmigration probability from person values and model factors
	p = evaluate(all_values, par.factors)
	if p > rand()
		person.status = migrant
	end
end

function update_intention!(person, year, par)
# nothing so far either. Threshold might be here instead.
end

function update_migrant!(person, year, par)
	# nothing so far
end

# Including all update functions.
function update_AG!(person, year, par, start_micro, start_macro)
	# nth year in person's data
	person_year = (year - (person.birth_year - start_micro))
	# inactivate agents after no more person-years are available.
	if person_year > length(person.values)
		person.status = inactive
	end
	if person.status == potential
	#if person.status != inactive # This was required for the mean_prob calculation. See "loading_lamp_no_decision"
		update_potential!(person, year, par, start_micro, start_macro) # p is returned
	elseif person.status == intention
		update_intention!(person, year, par)
	elseif person.status == migrant
		update_migrant!(person, year, par)
	end
end

# See "loading_lamp_no_decision" for the version of the function returning mean_probs.
function update_agents!(sim, year, par :: Params, start_micro, start_macro)
    n_migrants = 0
    for p in sim.pop
		migrated = p.status == migrant
        update_AG!(p, year, par, start_micro, start_macro)
		# newly migrated; it adds 1 to counter provided person hasn't migrated before.
        if ! migrated && p.status == migrant
            n_migrants += 1
        end
    end
    n_migrants
end