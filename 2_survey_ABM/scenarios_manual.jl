# Scenario default. Spain
const scenario_micro_default = Dict()
const scenario_macro_default = Dict()

# Run test for seed number 1.
# Start year for adding agents = 1962.
# Simulation years = 78, corresponding to 1930-2008.
 	# However, period of interest is 1962-2008. Output vectors are subsetted to 32:end (i.e. 1929+32:2008)

const n_mig, n_nomig, mig_rate, cummig_rate, pop, cohort, d_mig, n_dead, rescaled = run_sim("output/lampABM.csv",
 "output/macro.csv",
  "output/stat_model_lampABM_mlogit.csv",
   78, # Stops in year 2008 (1930+78).
    1,
	 "Spain",
	  scenario_micro_default,
	   scenario_macro_default);

## Run 10 seeds of default model over a loop.

const vector_n_mig_default = []
const vector_mig_rate_default = []
const vector_cummig_rate_default = []
for seed in 1:10
	n_mig, n_nomig, mig_rate, cummig_rate, pop, cohort, d_mig, n_dead, rescaled = run_sim("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", 78, seed, "Spain", scenario_micro_default, scenario_macro_default);
	push!(vector_n_mig_default, n_mig[32:end]) # 1962 to 2008
	push!(vector_cummig_rate_default, cummig_rate[32:end])
	push!(vector_mig_rate_default, mig_rate[32:end])
end
Plots.plot(vector_n_mig_default, labels = ["migrants"], legend = false)
Plots.plot(vector_cummig_rate_default, labels = ["migrants"], legend = false)
Plots.plot(vector_mig_rate_default, labels = ["mig_rate"], legend = false)