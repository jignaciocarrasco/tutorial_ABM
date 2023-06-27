
## Contains
# Set param values
# Constructs simulation using setup
# Runs analyses.

# Load neccesary packages
using Random
using Plots
using Distributions
using CSV
using Tables
using DataFrames
using StatsPlots
using StatsBase

#Change to working directory where scripts are contained.
#cd("C:\\Users\\ASUS\\Dropbox\\Documents\\academico\\PhD\\conferences_courses_stays\\Southampton_ABM_2020\\modelling\\pioneers-followers\\scripts")
push!(LOAD_PATH, pwd()) # let Julia find local packages

# Call input code files:
# Setup
# Include frequency weights based on Colombian income distribution
include("income_distribution.jl")
include("setup.jl")

function run_sim(sim, par :: Params, n_steps, verbose = false)
    n_mig = Int[]
    n_int = Int[]
    n_pot = Int[]
    n_nomig = Int[]
    for t in 1:n_steps
        update_households!(sim, par)
        update_agents!(sim, par)
        push!(n_mig, count(p -> p.status == migrant, sim.pop))
        push!(n_int, count(p -> p.status == intention, sim.pop))
        push!(n_pot, count(p -> p.status == potential, sim.pop))
        push!(n_nomig, count(p -> p.status == potential, sim.pop) + count(p -> p.status == intention, sim.pop))
        #Output
        if verbose
            println(t, ", ", n_mig[end], ", ", n_int[end], ", ", n_pot[end], ", ", n_nomig[end])
        end
    end
    #Return the results (normalized by pop size)
    #Only last line is a function output.
    n = length(sim.pop)
    n_mig, n_mig./n, n_int, n_int./n_nomig, n_pot, n_pot./n, n_nomig, n_nomig./n, sim.pop, sim.pop_hh
end

## Running model

#Defining parameters:
# 200 households
# 0.6 Vulnerability threshold
# 1000 agents
# 0.4 probability of contact
# migration cost= 1500
# ratio of income gain/loss = 2.5
# nmig = 0
# seed= 42
#Problem with vul_th. When changed to 0.4 or lower model wont run.
const parameters = Params(200, 0.5, 1000, 0.4, 1.5, 2500, 0, 42, col.incUSD, fw)
sim = setup_sim(par = parameters);

#Arrays with proportion of migrants/potential over time.
n_mig, mig, n_int, int, n_pot, pot, n_nomig, nomig, pop, pop_hh = run_sim(sim, parameters, 300);

Plots.plot([pot, int, mig], labels = ["pot (ABM)" "int (ABM)" "mig (ABM)"])
