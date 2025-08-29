clear all

global input_data "replicability_demres\input_data\"
global output "replicability_demres\output\"

use "$input_data\lampCD"

keep if year >= 1962 

/***Multonimial logit of Intraregional destinations, Spain and US***/

***logit***
mlogit cctry_dest2 age age2 ///
 female ///
 lgg_educ ///
 lgg_partner ///
 lgg_children ///
 lgg_ocstat_Skilled_manual-lgg_ocstat_Unemployed lgg_ocstat_Unskilled_manual ///
 lgg_wexp_lg ///
 lgg_duasset ///
 lgg_mnet_intra ///
 lgg_mnet_usa ///
 lgg_mnet_spain ///
 lgg_mnet_international_commun ///
 commun_1-commun_14 ///
 lgg_border_840 ///
 lgg_border_724 ///
 lgg_violence ///
 lgg_gdp ///
 lgg_egrowth_usa ///
 lgg_egrowth_spain // 
 
***Model results***
estimates store stat_model
estout stat_model using "$output/stat_model_lampABM_mlogit.csv", replace cells("b(fmt(5)) _star") 





 
 

