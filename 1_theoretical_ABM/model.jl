# Params struct. Parameters.

mutable struct Params
    n_hh :: Int64 #Number of households
    vuln_th :: Float64 #Vulnerability threshold
    n :: Int64 #Total population
    p_contact :: Float64 #Proportion/Probability of community contact
    inc :: Float64 #Income gain loss ratio threshold
    cost :: Float64 #Migration cost
    nmig :: Int64 #Number of migrants
    seed :: Int64 #Random seed
    empInc :: Array  #Empirical income distribution.
    weights  #Frequency weights based on histogram drawn from income distribution. Doesnt work when defined as Array
end

# Constructors
Params() = Params(1, 1, 1, 1, 1, 1, 0, 1, [], fw) #Default

#Simulation struct.
mutable struct Simulation
    pop :: Vector{Person}
    pop_hh :: Vector{Household}
end

#Household level. State potential to intention.
function update_potentialHH!(household, par :: Params)
    if household.status_hh == intention_hh
        return
    end
    if household.vuln > par.vuln_th
    household.status_hh = intention_hh
    end
    if household.status_hh == intention_hh
    rand(household.members).status = intention
    end
end

#State potential to intention
function update_potential!(person, par :: Params)
    mnet = count(p -> p.status == migrant, person.family)
    cmnet =  count(p -> p.status == migrant, person.community)
    #Agents are loss averse.
    #Only would want to migrate those were gains are relatively double larger than losses.
    #Intention is both affect by strong (mnet) and weak ties (cmnet).
    #Influence of mnet and cmnet varies randomly over time.
    #mnet (representing hhs) has a greater influence than the community
    #Canonical option: multiply instead of divide (to avoid get the inverted version of the distribution)
    if (person.gain / person.loss) + mnet*rand(0.02:0.05) + cmnet*rand(0.01:0.02) > par.inc
        person.status = intention
    end
end

#State intention to migrant
function update_intention!(person, par :: Params)
    # Object mnet counts number of migrants in agent's network.
    mnet = count(p -> p.status == migrant,  person.family)
    #Agents save a proportion of their income in each time step.
    person.totsav = person.totsav + person.ainc*0.2
    #Migrant family have an additive effect on the capacity to migrate.
    #1 migrant contact increases in 1% the total savings, which represents the ability.
    if person.totsav + person.totsav*(mnet/100) > par.cost
        person.status = migrant
    end
end

function update_HH!(household, par :: Params)
    if isempty(household.members)
        return
    end
    if household.status_hh == potential_hh
       update_potentialHH!(household, par)
    end
end

function update_AG!(person, par :: Params)
    if person.status == potential
       update_potential!(person, par)
   else
       update_intention!(person, par)
    end
end

#There seems to be a problem here.
#This explains why I'm getting mostly all agents changed to intention in the first step.
function update_households!(sim, par :: Params)
    orderHH = shuffle(sim.pop_hh)
    for hh in orderHH
        update_HH!(hh, par)
    end
end

function update_agents!(sim, par :: Params)
    order = shuffle(sim.pop)
    for p in order
        update_AG!(p, par)
    end
end
