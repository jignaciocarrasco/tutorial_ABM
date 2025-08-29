## Run and export scenarios.
using NBInclude
@nbinclude("run.ipynb")

# Scenarios

const scenario_micro_default = Dict()
const scenario_macro_default = Dict()
const scenario_net_hh_0 = Dict(17 => 0)
const scenario_cnet_0 = Dict(18 => 0)
const scenario_all_net_0 = Dict(17 => 0, 18 => 0)
const scenario_all_macro_0 = Dict(1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0)
const scenario_macro_border_spain_0 = Dict(2 => 0)
const scenario_macro_violence_0 = Dict(3 => 0)
const scenario_macro_gdp_0 = Dict(4 => 0)
const scenario_macro_employment_0 = Dict(6 => 0)


# Default model 
    # object "results" is the output with all dataframes of interest.
    # results[1] correspond to the migration rates; results[2] to cumulative migration rates.
dfs_default = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_micro_default, scenario_macro_default, 10)
CSV.write("output/ABM_mig_rate_default.csv", dfs_default[2])
CSV.write("output/ABM_cummig_rate_default.csv", dfs_default[3])

# Scenario networks Spain disabled.
dfs_net_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_net_hh_0, scenario_macro_default, 10)
CSV.write("output/ABM_mig_rate_net_0.csv", dfs_net_0[2])
CSV.write("output/ABM_cummig_rate_net_0.csv", dfs_net_0[3])

# Community networks disabled.
dfs_cnet_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_cnet_0, scenario_macro_default, 10)
CSV.write("output/ABM_mig_rate_cnet_0.csv", dfs_cnet_0[2])
CSV.write("output/ABM_cummig_rate_cnet_0.csv", dfs_cnet_0[3])

# Both household (for Spain) and community networks disabled.
dfs_all_net_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_all_net_0, scenario_macro_default, 10)
CSV.write("output/ABM_mig_rate_all_net_0.csv", dfs_all_net_0[2])
CSV.write("output/ABM_cummig_rate_all_net_0.csv", dfs_all_net_0[3])

# Network effects enabled & all macro effects disabled.
dfs_all_macro_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_micro_default, scenario_all_macro_0, 10)
CSV.write("output/ABM_mig_rate_all_macro_0.csv", dfs_all_macro_0[2])
CSV.write("output/ABM_cummig_rate_all_macro_0.csv", dfs_all_macro_0[3])

# Border Spain disabled.
dfs_border_spain_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_micro_default, scenario_macro_border_spain_0, 10)
CSV.write("output/ABM_mig_rate_border_spain_0.csv", dfs_border_spain_0[2])
CSV.write("output/ABM_cummig_rate_border_spain_0.csv", dfs_border_spain_0[3])

# Violence disabled.
dfs_violence_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_micro_default, scenario_macro_violence_0, 10)
CSV.write("output/ABM_mig_rate_violence_0.csv", dfs_violence_0[2])
CSV.write("output/ABM_cummig_rate_violence_0.csv", dfs_violence_0[3])

# GDP disabled.
dfs_gdp_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_micro_default, scenario_macro_gdp_0, 10)
CSV.write("output/ABM_mig_rate_gdp_0.csv", dfs_gdp_0[2])
CSV.write("output/ABM_cummig_rate_gdp_0.csv", dfs_gdp_0[3])

# Employment growth in Spain disabled.
dfs_employment_0 = run_seeds("output/lampABM.csv", "output/macro.csv", "output/stat_model_lampABM_mlogit.csv", scenario_micro_default, scenario_macro_employment_0, 10)
CSV.write("output/ABM_mig_rate_employment_0.csv", dfs_employment_0[2])
CSV.write("output/ABM_cummig_rate_employment_0.csv", dfs_employment_0[3])

