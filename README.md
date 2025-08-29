# Tutorial: Agent-Based Modelling with Survey Data

This repository contains materials for a tutorial on **Agent-Based Modelling (ABM)**, with applications to migration research.  
It includes **Julia code**, **Jupyter notebooks**, **R/Stata scripts**, supporting **survey data wrangling**, and a **presentation**. 
To run survey ABM, LAMP data needs to be request to LAMP project administrators at https://mmp.research.brown.edu/.

---

## Contents

### 1. Theoretical ABM

Folder: `1_theoretical_ABM/`

- **`data/colinc/`**  
  Household survey data on Colombian income.
- **`scenarios.jl`** and **`scenarios.ipynb`**  
  Run all notebooks and simulate all scenarios.
- **Other notebooks** (e.g., `agents.ipynb`)  
  Provide detailed explanations of specific components.

This section introduces the logic of a **theoretical ABM** and shows how to simulate scenarios step by step.

---

### 2. Survey ABM

Folder: `2_survey_ABM/`

#### a. Data management and model preparation (`2_survey_ABM/data_management_model/`)

- **`run_scripts.R`**  
  Loads `lamp.rda` and `lamp_macro.rda` and sources `manage_lamp_ABM.R`.
- **`manage_lamp_ABM.R`**  
  Data wrangling of LAMP data to produce micro (`lampABM.csv`) and macro (`macro.csv`) datasets used in the ABM.
- **`model_ABM.do`**  
  Stata script fitting a discrete-time event history model. Saves estimated migration probabilities to `stat_model_lampABM_mlogit.csv`.
- **`vars_interest/`**  
  Selected variables from the LAMP survey data.

**Outputs:**
- `lampABM.csv` (micro-level data)  
- `macro.csv` (macro-level data)  
- `stat_model_lampABM_mlogit.csv` (estimated migration parameters)

#### b. ABM implementation (`2_survey_ABM/`)

- **`import.ipynb`**  
  Creates functions to import micro and macro data.
- **`model.ipynb`**  
  Defines behavioral rules and model parameters.
- **`setup.ipynb`**  
  Setup functions for the ABM.
- **`run.ipynb`**  
  Simulation functions, data transformations, and RMSE computation.
- **`scenarios`**
  Runs all notebooks; all scenarios are simulated.

# Using survey-based ABM in migration research
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16994291)](https://doi.org/10.5281/zenodo.16994291)

This repository contains materials for a tutorial on **Agent-Based Modelling (ABM)**, with applications to migration research.  
It includes **Julia code**, **Jupyter notebooks**, **R/Stata scripts**, supporting **survey data wrangling**, and a **presentation**.
