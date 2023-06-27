## Contains:
# Functions to produce a runnable simulation object from a parameter object

#Change to working directory where scripts are contained.
#cd("C:\\Users\\ASUS\\Dropbox\\Documents\\academico\\PhD\\conferences_courses_stays\\Southampton_ABM_2020\\modelling\\pioneers-followers\\scripts")

# Call input code files: model and analysis
include("agents.jl")
include("model.jl")
#include("analysis.jl")

# Creation of a population object.
# Create n number of agents and households.
function setup_mixed(par :: Params)
    #Create agents and households
    pop = [ Person(i) for i = 1:par.n ]
    pop_hh = [ Household() for i = 1:par.n_hh ]
    ##Households
    # Assign agents to a random household.
    for p in pop
      push!(rand(pop_hh).members, p)
    end
    #Copy hh members to agents family. A bit messy code.
    for hh in pop_hh
      for j in eachindex(hh.members)
        for i in eachindex(hh.members)
          push!(hh.members[j].family, hh.members[i])
        end
      end
    end
    for hh in pop_hh
      hh.vuln = rand()
    end
    #Households
    #Create agents community list
    for i in eachindex(pop)
        for j in i+1:length(pop)
            if rand() < par.p_contact
                push!(pop[i].community, pop[j])
                push!(pop[j].community, pop[i])
            end
        end
    end
    for p in pop
        p.ainc = sample(par.empInc, par.weights)
    end
    for p in pop
        p.gain = rand()
        p.loss = rand()
    end
    pop, pop_hh
end

# Create simulation objects. Function has 4 parameters.
function setup_sim(;par :: Params)
    Random.seed!(par.seed)
    # Parameters as the field to create agents and households
    # Function creates two objects: pop and pop_hh
    pop, pop_hh = setup_mixed(par)
    # Only create one object sim with pop and pop_hh?
    sim = Simulation(pop, pop_hh)
    for i in 1:par.nmig
        # number of migrants before simulation begins. Default 0.
        sim.pop[i].status = migrant
    end
    sim
end
