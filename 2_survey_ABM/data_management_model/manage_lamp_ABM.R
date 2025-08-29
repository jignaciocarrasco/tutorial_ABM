
# Select vars of interest -------------------------------------------------

source("vars_interest.R")

lampABM_raw <- lampCD %>% 
  select("id_pers",
         "year",
         "age",
         "age2",
         "female",
         "persnum",
         "commun",
         all_of(vars_lampABM),
         lgg_wexp,
         lgg_employed,
         starts_with(c("event", "commun")),
         surveyyr,
         abyr1,
         weight) %>% 
  select(-commun)

# Complete person-year: make same number of person-years for all individuals. -------------------
  # Completing trajectories is needed for two things. 
    # First, the ABM needs to evaluate migration probability even after actual migration is produced. 
      # Therefore, despite lampABM is censored (as is based on lampCD), we create new person-years. More details in "Methods" section of full paper.
    # Second, simulating trajectories after empirical data is finished.

#Add cases to complete data.
lampABM <- lampABM_raw %>%
  ungroup %>%
  complete(id_pers, nesting(age, age2)) %>%
  group_by(id_pers) %>%
  fill("female",
       starts_with("commun"),
       "persnum",
       all_of(vars_lampABM),
       lgg_employed,
       abyr1,
       starts_with("event"),
       "weight",
       .direction = c("down")) %>%
  mutate(year = first(year) + cumsum(persnum) - 1)

# Correct Work experience (lgg_wexp) variable so that is time-variant  --------

lampABM <- lampABM %>% 
  group_by(id_pers) %>% 
  mutate(
    wexp_aux = ifelse(lgg_employed == "Employed", 1, 0),
    lgg_wexp = ifelse(age >= 15, cumsum(wexp_aux), 0),
    lgg_wexp_lg = ifelse(lgg_wexp == 0, 0, log(lgg_wexp))
  )

# Select vars of interest  -----------------------------------------------------------

lampABM <- lampABM %>%
  select(id_pers,
         year,
         age,
         age2,
         female,
         lgg_educ,
         lgg_partner,
         lgg_children,
         starts_with("lgg_ocstat"),
         lgg_wexp_lg,
         lgg_duasset,
         starts_with(c("lgg_mnet", "commun", "event")),
         abyr1,
         surveyyr,
         weight) %>%
  mutate(across(everything(), as.numeric))

# Macro values as a separate object. --------------------------------------

# Identify cases with completed data for macro values. Three individuals, for instance: "9_2015_3_14_2014_1".
# lamp_cl %>%  filter(year == 2015, age == 55) %>%
#   select(id_pers, year, age, lyear)

# Create dataset with information for macro variables, based on individual with completed data.
# To be used in ABM simulation.

macro <- lamp_macro %>%
  select(year, all_of(vars_macro)) %>% 
  ungroup() %>%
  filter(id_pers == "9_2015_3_14_2014_1",
         year %in% c(1961:2015)) %>%
  mutate(across(c(all_of(vars_macro)),
                  lag,
                .names = "lgg_{.col}")) %>% 
  select("year",
         "lgg_border_840",
         "lgg_border_724",
         "lgg_violence",
         "lgg_gdp",
         "lgg_egrowth_usa",
         "lgg_egrowth_spain",
         "lgg_oilpr") %>% 
  filter(year >= 1962)

# Weights -------------------------------------------------------

weights <- lampABM %>%
  group_by(id_pers,
           weight) %>%
  count() %>%
  select(-n)

# Save modules ------------------------------------------------------------

# export data frame to dta and csv formats.
write.dta(lampCD, "../2_survey_ABM/data/lampCD.dta")
write.csv(lampABM, "../2_survey_ABM/lampABM.csv")
write.csv(macro, "../2_survey_ABM/macro.csv")
