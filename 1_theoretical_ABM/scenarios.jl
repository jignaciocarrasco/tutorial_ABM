## (Not exactly) "Sensitivity" analysis

# Include previous scripts
include("run.jl")

#sel_n_hh = [200]
sel_vul_th = [0.2, 0.6]
#sel_n = [1000]
sel_p_contact = [0.2, 0.8]
sel_inc_th = [1.5, 2.5]
sel_cost = [500, 2500]
#sel_nmig = [0]
sel_seed = [42, 50]

output = open("output\\sensitivity_ort.csv", "w") # "w" for write
for vul_th in sel_vul_th
    for pc in sel_p_contact
        for inc_th in sel_inc_th
            for cost in sel_cost
                for seed in sel_seed
                    const parameters = Params(200, vul_th, 1000, pc, inc_th, cost, 0, seed, col.incUSD, fw)
                    sim = setup_sim(par = parameters)
                    n_mig, mig, n_int, int, n_pot, pot, n_nomig, nomig, pop, pop_hh = run_sim(sim, parameters, 300)
                    println(output, vul_th, ", ", pc, ", ", inc_th, ", ", cost, ", ", seed, ", ", mig[2], ", ", mig[35], ", ", mig[75],", ", mig[end])
                end
            end
        end
    end
end

close(output)

## Selected plots

#Plot 1.
#p_contact = 0.2
#inc_th = 1.5
#cost = 500
const parameters = Params(200, 0.6, 1000, 0.2, 1.5, 500, 0, 42, col.incUSD, fw)
sim = setup_sim(par = parameters)
n_mig, mig, n_int, int, n_pot, pot, n_nomig, nomig, pop, pop_hh = run_sim(sim, parameters, 300)
Plots.plot([pot, int, mig], labels = ["pot (ABM)" "int (ABM)" "mig (ABM)"], xticks = 0:50:300)
savefig("figs\\sty_1")

#Plot 2.
#p_contact = 0.8
#inc_th = 1.5
#cost = 500
const parameters = Params(200, 0.6, 1000, 0.8, 1.5, 500, 0, 42, col.incUSD, fw)
sim = setup_sim(par = parameters)
n_mig, mig, n_int, int, n_pot, pot, n_nomig, nomig, pop, pop_hh = run_sim(sim, parameters, 300)
Plots.plot([pot, int, mig], labels = ["pot (ABM)" "int (ABM)" "mig (ABM)"], xticks = 0:50:300)
savefig("figs\\sty_2")

#Plot 3.
#p_contact = 0.2
#inc_th = 1.5
#cost = 2500
const parameters = Params(200, 0.6, 1000, 0.8, 1.5, 2500, 0, 42, col.incUSD, fw)
sim = setup_sim(par = parameters)
n_mig, mig, n_int, int, n_pot, pot, n_nomig, nomig, pop, pop_hh = run_sim(sim, parameters, 300)
Plots.plot([pot, int, mig], labels = ["pot (ABM)" "int (ABM)" "mig (ABM)"], xticks = 0:50:300)
savefig("figs\\sty_3")
