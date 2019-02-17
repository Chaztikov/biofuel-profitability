/* This file is used for profitability calculation and visualization, and sensitivity analysis. This if for the baseline analysis (!= optimization scenarios).

		Input files: 	Draws_baseline.dta
						Non_stochastic_input_parameters.xlsx
		Output files: 	Dataset.dta
						ProfitabilityMeasures.dta
						Results.xlsx
						np_return_land_LY_H.pdf
						np_return_land_HY_H.pdf
						np_return_land_LY_F.pdf
						np_return_land_HY_F.pdf
						np_return_labour_LY.pdf
						np_return_labour_HY.pdf
						np_prof_LY.pdf
						np_prof_HY.pdf
						median_return_land_LY_H.pdf
						median_return_land_HY_H.pdf
						median_return_land_LY_F.pdf
						median_return_land_HY_F.pdf
						median_return_labour_LY.pdf
						median_return_labour_HY.pdf
						median_prof_LY.pdf
						median_prof_HY.pdf
						BaselineAnalysis.log
*/	

clear all
cd "C:\Users\..." // Replace by working directory
version 14
cap log close
log using BaselineAnalysis, text replace
set more off
set min_memory 2g









/***** DEVELOP FULL DATASET *****/
{
*** CREATE SCENARIOS (2 YIELD x 7 VALUE CHAINS = 14 SCENARIOS) AND MERGE WITH THE MONTE CARLO SAMPLES
{
// Import yield scenarios & associated non-stochastic input parameters
import excel using "C:\Users\...\Non_stochastic_input_parameters.xlsx", sheet ("Yield scenarios") firstrow // Replace by working directory
drop yield_scenario
save filetemp1, replace
clear
// Import value chain scenarios & associated non-stochastic input parameters
import excel using "C:\Users\...\Non_stochastic_input_parameters.xlsx", sheet ("Value chain scenarios") firstrow // Replace by working directory
drop value_chain_scenario
save filetemp2, replace
clear
// Combine scenarios and add Monte Carlo samples
use filetemp1.dta
cross using filetemp2.dta
cross using Draws_baseline.dta
quietly compress
erase filetemp1.dta
erase filetemp2.dta
}
*

*** DIFFERENTIATE YIELD FOR THE 2 YIELD SCENARIOS
{
set seed 12345
// High yield figures (= BP data) should start from seeds, low yield figures (= yield project data) from fruits
replace fruit_yield_ha_5 = . if ID_yield == 200
replace fruit_yield_ha_6 = . if ID_yield == 200
replace fruit_yield_ha_7 = . if ID_yield == 200
replace fruit_yield_ha_8 = . if ID_yield == 200
replace fruit_yield_ha_9 = . if ID_yield == 200
replace fruit_yield_ha_10 = . if ID_yield == 200
replace fruit_yield_ha_15 = . if ID_yield == 200
replace fruit_yield_ha_20 = . if ID_yield == 200
replace fruit_yield_ha_25 = . if ID_yield == 200
replace fruit_yield_ha_30 = . if ID_yield == 200
replace seed_yield_ha_5 = . if ID_yield == 100
replace seed_yield_ha_6 = . if ID_yield == 100
replace seed_yield_ha_7 = . if ID_yield == 100
replace seed_yield_ha_8 = . if ID_yield == 100
replace seed_yield_ha_9 = . if ID_yield == 100
replace seed_yield_ha_10 = . if ID_yield == 100
replace seed_yield_ha_15 = . if ID_yield == 100
replace seed_yield_ha_20 = . if ID_yield == 100
replace seed_yield_ha_25 = . if ID_yield == 100
replace seed_yield_ha_30 = . if ID_yield == 100
// Calculate missing years
gen fruit_yield_ha_11 = fruit_yield_ha_10 + (1/5) * (fruit_yield_ha_15 - fruit_yield_ha_10)
gen fruit_yield_ha_12 = fruit_yield_ha_10 + (2/5) * (fruit_yield_ha_15 - fruit_yield_ha_10)
gen fruit_yield_ha_13 = fruit_yield_ha_10 + (3/5) * (fruit_yield_ha_15 - fruit_yield_ha_10)
gen fruit_yield_ha_14 = fruit_yield_ha_10 + (4/5) * (fruit_yield_ha_15 - fruit_yield_ha_10)
gen fruit_yield_ha_16 = fruit_yield_ha_15 + (1/5) * (fruit_yield_ha_20 - fruit_yield_ha_15)
gen fruit_yield_ha_17 = fruit_yield_ha_15 + (2/5) * (fruit_yield_ha_20 - fruit_yield_ha_15)
gen fruit_yield_ha_18 = fruit_yield_ha_15 + (3/5) * (fruit_yield_ha_20 - fruit_yield_ha_15)
gen fruit_yield_ha_19 = fruit_yield_ha_15 + (4/5) * (fruit_yield_ha_20 - fruit_yield_ha_15)
gen fruit_yield_ha_21 = fruit_yield_ha_20 + (1/5) * (fruit_yield_ha_25 - fruit_yield_ha_20)
gen fruit_yield_ha_22 = fruit_yield_ha_20 + (2/5) * (fruit_yield_ha_25 - fruit_yield_ha_20)
gen fruit_yield_ha_23 = fruit_yield_ha_20 + (3/5) * (fruit_yield_ha_25 - fruit_yield_ha_20)
gen fruit_yield_ha_24 = fruit_yield_ha_20 + (4/5) * (fruit_yield_ha_25 - fruit_yield_ha_20)
gen fruit_yield_ha_26 = fruit_yield_ha_25 + (1/5) * (fruit_yield_ha_30 - fruit_yield_ha_25)
gen fruit_yield_ha_27 = fruit_yield_ha_25 + (2/5) * (fruit_yield_ha_30 - fruit_yield_ha_25)
gen fruit_yield_ha_28 = fruit_yield_ha_25 + (3/5) * (fruit_yield_ha_30 - fruit_yield_ha_25)
gen fruit_yield_ha_29 = fruit_yield_ha_25 + (4/5) * (fruit_yield_ha_30 - fruit_yield_ha_25)
gen seed_yield_ha_11 = seed_yield_ha_10 + (1/5) * (seed_yield_ha_15 - seed_yield_ha_10)
gen seed_yield_ha_12 = seed_yield_ha_10 + (2/5) * (seed_yield_ha_15 - seed_yield_ha_10)
gen seed_yield_ha_13 = seed_yield_ha_10 + (3/5) * (seed_yield_ha_15 - seed_yield_ha_10)
gen seed_yield_ha_14 = seed_yield_ha_10 + (4/5) * (seed_yield_ha_15 - seed_yield_ha_10)
gen seed_yield_ha_16 = seed_yield_ha_15 + (1/5) * (seed_yield_ha_20 - seed_yield_ha_15)
gen seed_yield_ha_17 = seed_yield_ha_15 + (2/5) * (seed_yield_ha_20 - seed_yield_ha_15)
gen seed_yield_ha_18 = seed_yield_ha_15 + (3/5) * (seed_yield_ha_20 - seed_yield_ha_15)
gen seed_yield_ha_19 = seed_yield_ha_15 + (4/5) * (seed_yield_ha_20 - seed_yield_ha_15)
gen seed_yield_ha_21 = seed_yield_ha_20 + (1/5) * (seed_yield_ha_25 - seed_yield_ha_20)
gen seed_yield_ha_22 = seed_yield_ha_20 + (2/5) * (seed_yield_ha_25 - seed_yield_ha_20)
gen seed_yield_ha_23 = seed_yield_ha_20 + (3/5) * (seed_yield_ha_25 - seed_yield_ha_20)
gen seed_yield_ha_24 = seed_yield_ha_20 + (4/5) * (seed_yield_ha_25 - seed_yield_ha_20)
gen seed_yield_ha_26 = seed_yield_ha_25 + (1/5) * (seed_yield_ha_30 - seed_yield_ha_25)
gen seed_yield_ha_27 = seed_yield_ha_25 + (2/5) * (seed_yield_ha_30 - seed_yield_ha_25)
gen seed_yield_ha_28 = seed_yield_ha_25 + (3/5) * (seed_yield_ha_30 - seed_yield_ha_25)
gen seed_yield_ha_29 = seed_yield_ha_25 + (4/5) * (seed_yield_ha_30 - seed_yield_ha_25)
// Calculate fruit yield for the high yield scenario and seed yields for the low yield scenario
local j = 5
quietly while `j' <= 30 { 
	replace fruit_yield_ha_`j' = (1/seed_fruit_ratio)*seed_yield_ha_`j' if ID_yield == 200
	replace seed_yield_ha_`j' = seed_fruit_ratio* fruit_yield_ha_`j' if ID_yield == 100
	local j = `j' + 1
	}
sum fruit_yield_ha_30 if ID_yield == 100 // Value for all observations now
sum fruit_yield_ha_30 if ID_yield == 200 // Value for all observations now, significantly higher
sum seed_yield_ha_30 if ID_yield == 100 // Value for all observations now
sum seed_yield_ha_30 if ID_yield == 200 // Value for all observations now, significantly higher
// Now create variables for the first 4 years as well, which is better for using while-loops later on
gen fruit_yield_ha_1 = 0
gen fruit_yield_ha_2 = 0
gen fruit_yield_ha_3 = 0
gen fruit_yield_ha_4 = 0
gen seed_yield_ha_1 = 0
gen seed_yield_ha_2 = 0
gen seed_yield_ha_3 = 0
gen seed_yield_ha_4 = 0
}
*

*** DIFFERENTIATE PROCESSING FIGURES FOR THE 7 VALUE CHAIN SCENARIOS
{
gen dec_rate = .
replace dec_rate = dec_rate_manual if ID_proc != 4 & ID_proc != 5
replace dec_rate = dec_rate_mechanical if ID_proc == 4 | ID_proc == 5
gen dec_eff = .
replace dec_eff = dec_eff_manual if ID_proc != 4 & ID_proc != 5
replace dec_eff = dec_eff_mechanical if ID_proc == 4 | ID_proc == 5
gen exp_rate = .
replace exp_rate = exp_rate_village if ID_proc == 1
replace exp_rate = exp_rate_BP if ID_proc > 1 & ID_proc < 6
replace exp_rate = exp_rate_LS if ID_proc > 5
gen exp_oil = .
replace exp_oil = exp_oil_village if ID_proc == 1
replace exp_oil = exp_oil_BPLS if ID_proc != 1
gen conv_rate = .
replace conv_rate = conv_rate_BP if ID_proc == 3 | ID_proc == 5
replace conv_rate = conv_rate_LS if ID_proc == 7
gen conv_cost = .
replace conv_cost = conv_cost_BP if ID_proc == 3 | ID_proc == 5
replace conv_cost = conv_cost_LS if ID_proc == 7
drop dec_rate_manual-conv_cost_LS
}
*

*** DIFFERENTIATE HARVEST RATE FOR HIGH AND LOW YIELD SCENARIO
{
replace harvest_rate_tarpel = harvest_rate_tarpel * harvest_rate_multiplication if ID_yield == 200
sum harvest_rate_tarpel if ID_yield == 100
sum harvest_rate_tarpel if ID_yield == 200
}
*

*** ADD REMAINING NON-STOCHASTIC INPUT PARAMETERS
{
save filetemp1, replace
clear
import excel using "C:\Users\...\Non_stochastic_input_parameters.xlsx", sheet ("Other") firstrow // Replace by working directory
save filetemp2, replace
clear
use filetemp1
cross using filetemp2.dta
quietly compress
save Dataset.dta, replace
erase filetemp1.dta
erase filetemp2.dta
}
*
}
*









/***** PROFITABILITY CALCULATION *****/
{

*** TREE CULTIVATION COSTS
{
// FIELD PREPARATION COSTS - INR/ha
/* Assume hired labour in all scenarios */
gen field_prep = field_prep_cost + labour_wage_men / 8 * field_prep_time // Assume men perform the hired labour.

// PLANTING & SEEDLING COSTS - INR/ha
* Equipment costs = planting_eqp // Assume planting material lasts 1 year
* Time input for family labour
gen planting_HH_time = planting_time * amount_trees_ha
* Hired labour costs
gen planting_hired = planting_work * amount_trees_ha
* Seedling costs
gen seedling = (seedling_price * (1-seedling_payer)) * amount_trees_ha // seedling_payer indicates whether seedlings are externally funded (=1) or not (=0)

// IRRIGATION COSTS & TIME - INR/(ha*year) & hours/(ha*year)
local j = 1
quietly while `j' <= 30 {
	* Water costs
	gen watering_water_`j' = 0
	replace watering_water_`j' = water_area_cost if `j' <= watering_age
	* Time input for family labour
	gen watering_HH_time_`j' = 0
	replace watering_HH_time_`j' = amount_trees_ha * watering_time if `j' <= watering_age
	* Hired labour costs
	gen watering_hired_labour_`j' = 0
	replace watering_hired_labour_`j' = watering_HH_time_`j' * labour_wage_men / 8 if `j' <= watering_age // Assume men perform the hired labour.
	local j = `j' + 1	
	}

// WEEDING COSTS & TIME - INR/(ha*year) & hours/(ha*year)
/* For this I can assume either hired or HH labour. Suppose women do this in both cases */
local j = 1
while `j' <= 30 {
	* Equipment costs
	gen weeding_eqp_`j' = weeding_eqp / 5 // Assume weeding equipment lasts 5 years
	* Time input for family labour
	gen weeding_HH_time_`j' = weeding_hour
	* Hired labour costs
	gen weeding_hired_labour_`j' = weeding_HH_time_`j' * labour_wage_women / 8 // Assume women perform the hired labour
	local j = `j' + 1
	}

// TOTAL TREE CULTIVATION COSTS (EXLUDING INITIAL ESTABLISHMENT COSTS)
local j = 1
quietly while `j' <= 30 { 
	* Fixed costs
	gen tree_cult_fixed_`j' = watering_water_`j' + weeding_eqp_`j' // Fixed costs
	* Time input for family labour
	gen tree_cult_HH_time_`j' = watering_HH_time_`j' + weeding_HH_time_`j'
	* Hired labour costs
	gen tree_cult_hired_labour_`j' = watering_hired_labour_`j' + weeding_hired_labour_`j'
	local j = `j' + 1
	}
}
*

*** TREE YIELDS & HARVESTING COSTS
{
// TIME INPUT & COSTS TO HARVEST A HECTARE - hours/hectare & INR/hectare
local j = 1
quietly while `j' <= 30 { 
	* Equipment costs
	gen harvest_eqp_`j' = tarpel_cost
	replace harvest_eqp_`j' = 0 if `j' < 5 // Geen harvest in de eerste 4 jaar
	* Time input for family labour
	gen harvest_HH_time_`j' = 1000*fruit_yield_ha_`j' * (1 / harvest_rate_tarpel)
	* Hired labour costs
	gen harvest_hired_labour_`j' = harvest_HH_time_`j' * ((labour_wage_men + labour_wage_women)/2) / 8 // Assume women and men perform the hired labour
	local j = `j' + 1
	}
}
*

*** PROCESSING OUTPUTS & COSTS
{
// TIME INPUT & COSTS TO DECORTICATE A HECTARE - hours/hectare & INR/hectare
local j = 1
quietly while `j' <= 30 { 
	* Time input for family labour - If decortication by farmers
	gen dec_HH_time_`j' = 0
	replace dec_HH_time_`j' = 1000*fruit_yield_ha_`j' * (1 / dec_rate) if ID_proc != 4 & ID_proc != 5
	* Hired labour costs - If decortication by farmers
	gen dec_hired_labour_`j' = 0
	replace dec_hired_labour_`j' = dec_HH_time_`j' * labour_wage_women / 8 if ID_proc != 4 & ID_proc != 5 // Assume women perform the hired labour
	* Costs - If decortication by the Biofuel Park
	gen dec_costs_BP_`j' = 0
	replace dec_costs_BP_`j' = (dec_wage/8 + 2*labour_wage_women/8 + dec_elec) * (1 / dec_rate) * (1000 * fruit_yield_ha_`j') if ID_proc == 4 | ID_proc == 5
	local j = `j' + 1
	}

// SEED AMOUNTS ACHIEVED AFTER DECORTICATION - ton/ha
local j = 1
quietly while `j' <= 30 { 
	gen dec_seeds_achieved_`j' = seed_yield_ha_`j' * (1 - dec_eff)
	local j = `j' + 1
	}

// TRANSPORT COSTS PER HECTARE - INR/ha
* ID_proc 1: no transport. ID_proc 2, 3, 6, 7: transport of seeds. ID_proc 4, 5: transport of fruits
local j = 1
quietly while `j' <= 30 { 
	* Fuel costs
	gen transport_vehicle_`j' = 0
	replace transport_vehicle_`j' = 1000*fruit_yield_ha_`j' * trans_vehicle if ID_proc == 4 | ID_proc == 5
	replace transport_vehicle_`j' = 1000*seed_yield_ha_`j' * trans_vehicle if ID_proc == 2 | ID_proc == 3 | ID_proc == 6 | ID_proc == 7
	* Equipment costs
	gen transport_gunny_`j' = 0
	* 1 gunny bag can 25 times move 25 kgs of fruits => 625kg. 25 times 35 kgs of seeds => 875kg
	replace transport_gunny_`j' = 1000*fruit_yield_ha_`j' / 625 * trans_gunny if ID_proc == 4 | ID_proc == 5
	replace transport_gunny_`j' = 1000*seed_yield_ha_`j' / 875 * trans_gunny if ID_proc == 2 | ID_proc == 3 | ID_proc == 6 | ID_proc == 7
	local j = `j' + 1
	}

// TIME INPUT & COSTS TO EXPELL A HECTARE - hours/hectare & INR/hectare
local j = 1
quietly while `j' <= 30 { 
	* Time input for family labour - If expelling by farmers
	gen exp_HH_time_`j' = 0
	replace exp_HH_time_`j' = 1000*dec_seeds_achieved_`j' * (1 / exp_rate) if ID_proc == 1
	* Hired labour costs - If expelling by farmers
	gen exp_hired_labour_`j' = 0
	replace exp_hired_labour_`j' = exp_HH_time_`j' * labour_wage_men / 8 if ID_proc == 1 // Assume men perform the hired labour
	* Costs - If expelling by the Biofuel Park or industrial scale
	gen exp_costs_BP_LS_`j' = 0
	replace exp_costs_BP_LS_`j' = (exp_wage/8 + exp_elec) * (1 / exp_rate) * 1000*dec_seeds_achieved_`j' if ID_proc >= 2 & ID_proc <= 7
	local j = `j' + 1
	}

// OIL & SEED CAKE AMOUNTS ACHIEVED AFTER EXPELLING - l/ha & ton/ha
local j = 1
quietly while `j' <= 30 { 
	gen exp_oil_achieved_`j' = 1000*dec_seeds_achieved_`j' * oil_content * exp_oil
	gen exp_cake_achieved_`j' = dec_seeds_achieved_`j' * (1 - (oil_content * exp_oil + exp_loss))
	local j = `j' + 1
	}
* Production per hectare for low yield <=> high yield
sum exp_oil_achieved_30 if ID_yield == 100 // 730 l/ha
sum exp_oil_achieved_30 if ID_yield == 200 // 2031 l/ha

// TIME INPUT & COSTS TO CONVERT A HECTARE TO BIODIESEL - hours/hectare & INR/hectare
local j = 1
quietly while `j' <= 30 { 
	* Costs for Biofuel Park or industrial scale
	gen conv_costs_BP_LS_`j' = 0
	replace conv_costs_BP_LS_`j' = exp_oil_achieved_`j' * conv_cost if ID_proc == 3 | ID_proc == 5 | ID_proc == 7
	local j = `j' + 1
	}

// BIODIESEL & GLYCEROL AMOUNTS ACHIEVED AFTER CONVERSION - l/ha
local j = 1
quietly while `j' <= 30 { 
	gen conv_dies_achieved_`j' = exp_oil_achieved_`j' * conv_dies_yie
	gen conv_gly_achieved_`j' = exp_oil_achieved_`j' * conv_gly_yie
	local j = `j' + 1
	}
}
*

*** TOTAL COSTS
{
// TOTAL COSTS & TIME INPUT FOR FARMERS - INR/ha & hours/ha
{
// If hired labour
local j = 1
quietly while `j' <= 30 { 
	* Total costs for farmers
	gen total_cost_farmer_1_`j' = 0
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + tree_cult_fixed_`j'
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + tree_cult_hired_labour_`j'
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + harvest_eqp_`j'
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + harvest_hired_labour_`j'
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + dec_hired_labour_`j'
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + transport_vehicle_`j' // Transport fuel costs are usually passed on to farmers through the price offered
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + exp_hired_labour_`j'
	local j = `j' + 1
	}
* Costs in the establishment year
gen total_cost_farmer_1_0 = field_prep + planting_eqp + planting_hired + seedling // Assume farmers bear the seedling costs, if not externally funded

// If family labour
local j = 1
quietly while `j' <= 30 { 
	* Total costs for farmers
	gen total_cost_farmer_2_`j' = 0
	replace total_cost_farmer_2_`j' = total_cost_farmer_2_`j' + tree_cult_fixed_`j'
	replace total_cost_farmer_2_`j' = total_cost_farmer_2_`j' + harvest_eqp_`j'
	replace total_cost_farmer_2_`j' = total_cost_farmer_2_`j' + transport_vehicle_`j'
	* Total time input for family labour
	gen total_HH_time_`j' = 0
	replace total_HH_time_`j' = total_HH_time_`j' + tree_cult_HH_time_`j'	
	replace total_HH_time_`j' = total_HH_time_`j' + harvest_HH_time_`j'	
	replace total_HH_time_`j' = total_HH_time_`j' + dec_HH_time_`j'	
	replace total_HH_time_`j' = total_HH_time_`j' + exp_HH_time_`j'
	local j = `j' + 1
	}	
* Costs & time in the establishment year
gen total_cost_farmer_2_0 = field_prep + planting_eqp + seedling // Assume farmers bear the seedling costs, if not externally funded
gen total_HH_time_0 = planting_HH_time
}

// TOTAL COSTS FOR PROCESSORS - INR/ha
{
// For processors no distinction between hired & family, as they hire all labour
local j = 1
quietly while `j' <= 30 { 
	* Total costs for processors
	gen total_cost_processor_1_`j' = 0
	replace total_cost_processor_1_`j' = total_cost_processor_1_`j' + dec_costs_BP_`j'
	replace total_cost_processor_1_`j' = total_cost_processor_1_`j' + transport_gunny_`j'
	replace total_cost_processor_1_`j' = total_cost_processor_1_`j' + exp_costs_BP_LS_`j'
	replace total_cost_processor_1_`j' = total_cost_processor_1_`j' + conv_costs_BP_LS_`j'
	local j = `j' + 1
	}
* Costs in the establishment year
gen total_cost_processor_1_0 = 0

/* IMPORTANT NOTE: one cost is not yet included for processors, i.e. the procurement of feedstock (fruits or seeds).
	This will be added below as a negative revenue. */
}
*
}
*

*** REVENUES
{
// REVENUES FOR FARMERS - INR/ha
local j = 1
quietly while `j' <= 30 { 
	gen revenues_farmer_`j' = 0
	replace revenues_farmer_`j' = 1000 * fruit_yield_ha_`j' * fruits_price if ID_proc == 4 | ID_proc == 5
	replace revenues_farmer_`j' = 1000 * dec_seeds_achieved_`j' * seeds_price if ID_proc == 2 | ID_proc == 3 | ID_proc == 6 | ID_proc == 7
	replace revenues_farmer_`j' = exp_oil_achieved_`j' * oil_price + 1000 * exp_cake_achieved_`j' * cake_price if ID_proc == 1 
	local j = `j' + 1
	}

// REVENUES FOR PROCESSORS - INR/ha
/* IMPORTANT: see earlier: costs of feedstock (fruits or seeds) should be included as a negative revenue */
local j = 1
quietly while `j' <= 30 { 
	gen revenues_processor_`j' = 0
	replace revenues_processor_`j' = (exp_oil_achieved_`j' * oil_price + 1000 * exp_cake_achieved_`j' * cake_price) ///
		- (1000 * dec_seeds_achieved_`j' * seeds_price) if ID_proc == 2 | ID_proc == 6
	replace revenues_processor_`j' = (exp_oil_achieved_`j' * oil_price + 1000 * exp_cake_achieved_`j' * cake_price) ///
		- (1000 * fruit_yield_ha_`j' * fruits_price) if ID_proc == 4
	replace revenues_processor_`j' = conv_dies_achieved_`j' * biodiesel_price + conv_gly_achieved_`j' * conv_gly_price + 1000 * exp_cake_achieved_`j' * cake_price ///
		- (1000 * dec_seeds_achieved_`j' * seeds_price) if ID_proc == 3 | ID_proc == 7	
	replace revenues_processor_`j' = conv_dies_achieved_`j' * biodiesel_price + conv_gly_achieved_`j' * conv_gly_price + 1000 * exp_cake_achieved_`j' * cake_price ///
		- (1000 * fruit_yield_ha_`j' * fruits_price) if ID_proc == 5
	local j = `j' + 1
	}
}
*

*** PROFITABILITY MEASURES
{
// RETURNS TO LAND/LABOUR FOR FARMERS - INR/ha & INR/hour
local j = 1
quietly while `j' <= 30 {
	* Return to land of biofuel tree cultivation (family land, hired labour)
	gen RetLand_H_`j' = (revenues_farmer_`j' - total_cost_farmer_1_`j') / 1 // This is equation 3 in the article of Dalemans et al. (2019)
	* Return to land of biofuel tree cultivation (family land, family labour)
	gen RetLand_F_`j' = (revenues_farmer_`j' - total_cost_farmer_2_`j') / 1 // This is equation 5 in the article of Dalemans et al. (2019)
	* Return to labour of biofuel tree cultivation (family land, family labour)
	gen RetLabour_`j' = (revenues_farmer_`j' - total_cost_farmer_2_`j') / total_HH_time_`j' // This is equation 4 in the article of Dalemans et al. (2019)
	local j = `j' + 1
	}
* Returns to land/labour in the establishment year
gen RetLand_H_0 = - total_cost_farmer_1_0 / 1
gen RetLand_F_0 = - total_cost_farmer_2_0 / 1
gen RetLabour_0 = - total_cost_farmer_2_0 / total_HH_time_0

// PROFIT FOR PROCESSORS - INR/ha
local j = 1
quietly while `j' <= 30 {
	gen Profit_`j' = revenues_processor_`j' - total_cost_processor_1_`j' // This is equation 1 in the article of Dalemans et al. (2019) [for processors, zero land costs are assumed]
	local j = `j' + 1
	}
* Profit in the establishment year
gen Profit_0 = - total_cost_processor_1_0
}
*

*** NET PRESENT PROFITABILITY MEASURES
{
// NET PRESENT RETURNS TO LAND/LABOUR FOR FARMERS - INR/ha & INR/hour
* Net present return to land of biofuel tree cultivation (family land, hired labour)
gen np_RetLand_H = RetLand_H_0
* Net present return to land of biofuel tree cultivation (family land, family labour)
gen np_RetLand_F = RetLand_F_0
* Net present return to labour of biofuel tree cultivation (family land, family labour)
gen np_RetLabour = RetLabour_0
local j = 1
quietly while `j' <= 30 {
	replace np_RetLand_H = np_RetLand_H + RetLand_H_`j' / (1 + disc_rate)^`j' // This is equation 8 in the article of Dalemans et al. (2019)
	replace np_RetLand_F = np_RetLand_F + RetLand_F_`j' / (1 + disc_rate)^`j' // This is equation 10 in the article of Dalemans et al. (2019)
	replace np_RetLabour = np_RetLabour + RetLabour_`j' / (1 + disc_rate)^`j' if RetLabour_`j' != . // This is equation 9 in the article of Dalemans et al. (2019)
	local j = `j' + 1
	}
// NET PRESENT PROFIT FOR PROCESSORS - INR/ha
gen np_Profit = Profit_0
local j = 1
quietly while `j' <= 30 {
	replace np_Profit = np_Profit + Profit_`j' / (1 + disc_rate)^`j' // This is equation 6 in the article of Dalemans et al. (2019)
	local j = `j' + 1
	}
*
}
*
reorder ID*
drop fruit_yield_ha_11-seed_yield_ha_4 field_prep_cost-revenues_processor_30
quietly compress
save ProfitabilityMeasures.dta, replace
}
*









/***** PROFITABILITY VISUALIZATION *****/
{

*** NET PRESENT PROFITABILITY MEASURES - ESTIMATED KERNEL PROBABILITY DENSITY FUNCTIONS
{

// GRAPHS
{
mat np_above_0 = J(4,7,.) // Rows = 4 profitability measures which prove to be not exlusively positive. Columns = 7 value chain scenarios.

* Farmers: Net present return to land of biofuel tree cultivation (family land, hired labour) - Low yield
twoway (kdensity np_RetLand_H if ID_proc == 1 & ID_yield == 100, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (kdensity np_RetLand_H if (ID_proc == 2 | ID_proc == 3) & ID_yield == 100, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_RetLand_H if (ID_proc == 4 | ID_proc == 5) & ID_yield == 100, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (kdensity np_RetLand_H if (ID_proc == 6 | ID_proc == 7) & ID_yield == 100, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Probability") xtitle("Net present return to land (INR/ha)") ylabel(none) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) ///
	title("Net present return to land for farmers" "Hired labour - Low yield") ///	
	graphregion(color(white)) yscale(titlegap(3)) xscale(range(-2300000) titlegap(3) outergap(3)) legend(region(style(none))) xline(0) ///
	xlabel(-2000000(1000000)2000000) xmtick(-1500000(1000000)1500000) ///
	graphregion(margin(r=10)) ///
	name(np_return_land_LY_H, replace)
graph export "C:\Users\...\np_return_land_LY_H.pdf", replace as(pdf) // Replace by working directory
// What are the fractions above zero for each value chain?
local i = 1 // Processing scenarios
	while `i' <= 7 {
		gen test_`i' = .
		replace test_`i' = 0 if ID_proc == `i' & ID_yield == 100
		replace test_`i' = 1 if np_RetLand_H >=0 & ID_proc == `i' & ID_yield == 100
		sum test_`i'
		mat np_above_0[1,`i'] = r(mean) // This variable will appear in row 1, column 1 to 7
		local i = `i' + 1
	}
drop test_1-test_7

* Farmers: Net present return to land of biofuel tree cultivation (family land, hired labour) - High yield
twoway (kdensity np_RetLand_H if ID_proc == 1 & ID_yield == 200, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (kdensity np_RetLand_H if (ID_proc == 2 | ID_proc == 3) & ID_yield == 200, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_RetLand_H if (ID_proc == 4 | ID_proc == 5) & ID_yield == 200, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (kdensity np_RetLand_H if (ID_proc == 6 | ID_proc == 7) & ID_yield == 200, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Probability") xtitle("Net present return to land (INR/ha)") ylabel(none) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) ///
	title("Net present return to land for farmers" "Hired labour - High yield") ///	
	graphregion(color(white)) yscale(titlegap(3)) xscale(range(-2300000) titlegap(3) outergap(3)) legend(region(style(none))) xline(0) ///
	xlabel(-2000000(1000000)2000000) xmtick(-1500000(1000000)1500000) ///
	graphregion(margin(r=10)) ///
	name(np_return_land_HY_H, replace)
graph export "C:\Users\...\np_return_land_HY_H.pdf", replace as(pdf) // Replace by working directory
// What are the fractions above zero for each value chain?
local i = 1 // Processing scenarios
	while `i' <= 7 {
		gen test_`i' = .
		replace test_`i' = 0 if ID_proc == `i' & ID_yield == 200
		replace test_`i' = 1 if np_RetLand_H >=0 & ID_proc == `i' & ID_yield == 200
		sum test_`i'
		mat np_above_0[2,`i'] = r(mean) // This variable will appear in row 2, column 1 to 7
		local i = `i' + 1
	}
drop test_1-test_7

* Farmers: Net present return to land of biofuel tree cultivation (family land, family labour) - Low yield
twoway (kdensity np_RetLand_F if ID_proc == 1 & ID_yield == 100, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (kdensity np_RetLand_F if (ID_proc == 2 | ID_proc == 3) & ID_yield == 100, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_RetLand_F if (ID_proc == 4 | ID_proc == 5) & ID_yield == 100, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (kdensity np_RetLand_F if (ID_proc == 6 | ID_proc == 7) & ID_yield == 100, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Probability") xtitle("Net present return to land (INR/ha)") ylabel(none) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) ///
	title("Net present return to land for farmers" "Family labour - Low yield") ///	
	graphregion(color(white)) yscale(titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) xline(0) ///
	xlabel(0(500000)2500000) xmtick(250000(500000)2250000) ///
	graphregion(margin(r=10)) ///
	name(np_return_land_LY_F, replace)
graph export "C:\Users\...\np_return_land_LY_F.pdf", replace as(pdf) // Replace by working directory

* Farmers: Net present return to land of biofuel tree cultivation (family land, family labour) - High yield
twoway (kdensity np_RetLand_F if ID_proc == 1 & ID_yield == 200, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (kdensity np_RetLand_F if (ID_proc == 2 | ID_proc == 3) & ID_yield == 200, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_RetLand_F if (ID_proc == 4 | ID_proc == 5) & ID_yield == 200, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (kdensity np_RetLand_F if (ID_proc == 6 | ID_proc == 7) & ID_yield == 200, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Probability") xtitle("Net present return to land (INR/ha)") ylabel(none) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) ///
	title("Net present return to land for farmers" "Family labour - High yield") ///	
	graphregion(color(white)) yscale(titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) xline(0) ///
	xlabel(0(500000)2500000) xmtick(250000(500000)2250000) ///
	graphregion(margin(r=10)) ///
	name(np_return_land_HY_F, replace)
graph export "C:\Users\...\np_return_land_HY_F.pdf", replace as(pdf) // Replace by working directory

* Farmers: Net present return to labour of biofuel tree cultivation (family land, family labour) - Low yield
twoway (kdensity np_RetLabour if ID_proc == 1 & ID_yield == 100, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (kdensity np_RetLabour if (ID_proc == 2 | ID_proc == 3) & ID_yield == 100, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_RetLabour if (ID_proc == 4 | ID_proc == 5) & ID_yield == 100, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (kdensity np_RetLabour if (ID_proc == 6 | ID_proc == 7) & ID_yield == 100, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Probability") xtitle("Net present return to labour (INR)") ylabel(none) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) ///
	title("Net present return to labour for farmers" "Low yield") ///	
	graphregion(color(white)) yscale(titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) xline(0) ///
	xlabel(0(500)2000) xmtick(250(500)1750) ///
	name(np_return_labour_LY, replace)
graph export "C:\Users\...\np_return_labour_LY.pdf", replace as(pdf) // Replace by working directory

* Farmers: Net present return to labour of biofuel tree cultivation (family land, family labour) - High yield
twoway (kdensity np_RetLabour if ID_proc == 1 & ID_yield == 200, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (kdensity np_RetLabour if (ID_proc == 2 | ID_proc == 3) & ID_yield == 200, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_RetLabour if (ID_proc == 4 | ID_proc == 5) & ID_yield == 200, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (kdensity np_RetLabour if (ID_proc == 6 | ID_proc == 7) & ID_yield == 200, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Probability") xtitle("Net present return to labour (INR)") ylabel(none) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) ///
	title("Net present return to labour for farmers" "High yield") ///	
	graphregion(color(white)) yscale(titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) xline(0) ///
	xlabel(0(500)2000) xmtick(250(500)1750) ///
	name(np_return_labour_HY, replace)
graph export "C:\Users\...\np_return_labour_HY.pdf", replace as(pdf) // Replace by working directory

* Processors: net present profit of biofuel tree cultivation - Low yield
twoway (kdensity np_Profit if ID_proc == 2 & ID_yield == 100, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_Profit if ID_proc == 3 & ID_yield == 100, lwidth(medthick) lcolor(orange) lpattern("solid")) ///
	|| (kdensity np_Profit if ID_proc == 4 & ID_yield == 100, lwidth(medthick) lcolor(gs10) lpattern("-")) ///
	|| (kdensity np_Profit if ID_proc == 5 & ID_yield == 100, lwidth(medthick) lcolor(gs10) lpattern("solid")) ///
	|| (kdensity np_Profit if ID_proc == 6 & ID_yield == 100, lwidth(medthick) lcolor(gold) lpattern("-")) ///
	|| (kdensity np_Profit if ID_proc == 7 & ID_yield == 100, lwidth(medthick) lcolor(gold) lpattern("solid")) ///
	, ytitle("Probability") xtitle("Net present profit (INR/ha)") ylabel(none) ///
	legend(label(1 "Farmer-BP-oil chain") label(3 "BP-oil chain") label(5 "Farmer-Industry-oil chain") label(2 "Farmer-BP-biodiesel chain") label(4 "BP-biodiesel chain") label(6 "Farmer-Industry-biodiesel chain")) ///
	title("Net present profit for processors" "Low yield") ///
	graphregion(color(white)) yscale(titlegap(3)) xscale(range(-1200000 1600000) titlegap(3) outergap(3)) legend(region(style(none)) rows(3)) xline(0) ///
	xlabel(-1500000(500000)1500000) xmtick(-750000(500000)1250000) ///
	name(np_prof_LY, replace)
graph export "C:\Users\...\np_prof_LY.pdf", replace as(pdf) // Replace by working directory
// What are the fractions above zero for each value chain?
local i = 2 // Processing scenarios
	while `i' <= 7 {
		gen test_`i' = .
		replace test_`i' = 0 if ID_proc == `i' & ID_yield == 100
		replace test_`i' = 1 if np_Profit >=0 & ID_proc == `i' & ID_yield == 100
		sum test_`i'
		mat np_above_0[3,`i'] = r(mean) // This variable will appear in row 3, column 1 to 7
		local i = `i' + 1
	}
drop test_2-test_7

* Processors: net present profit of biofuel tree cultivation - High yield
twoway (kdensity np_Profit if ID_proc == 2 & ID_yield == 200, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (kdensity np_Profit if ID_proc == 3 & ID_yield == 200, lwidth(medthick) lcolor(orange) lpattern("solid")) ///
	|| (kdensity np_Profit if ID_proc == 4 & ID_yield == 200, lwidth(medthick) lcolor(gs10) lpattern("-")) ///
	|| (kdensity np_Profit if ID_proc == 5 & ID_yield == 200, lwidth(medthick) lcolor(gs10) lpattern("solid")) ///
	|| (kdensity np_Profit if ID_proc == 6 & ID_yield == 200, lwidth(medthick) lcolor(gold) lpattern("-")) ///
	|| (kdensity np_Profit if ID_proc == 7 & ID_yield == 200, lwidth(medthick) lcolor(gold) lpattern("solid")) ///
	, ytitle("Probability") xtitle("Net present profit (INR/ha)") ylabel(none) ///
	legend(label(1 "Farmer-BP-oil chain") label(3 "BP-oil chain") label(5 "Farmer-Industry-oil chain") label(2 "Farmer-BP-biodiesel chain") label(4 "BP-biodiesel chain") label(6 "Farmer-Industry-biodiesel chain")) ///
	title("Net present profit for processors" "High yield") ///
	graphregion(color(white)) yscale(titlegap(3)) xscale(range(-1200000 1600000) titlegap(3) outergap(3)) legend(region(style(none)) rows(3)) xline(0) ///
	xlabel(-1500000(500000)1500000) xmtick(-750000(500000)1250000) ///
	name(np_prof_HY, replace)
graph export "C:\Users\...\np_prof_HY.pdf", replace as(pdf) // Replace by working directory
// What are the fractions above zero for each value chain?
local i = 2 // Processing scenarios
	while `i' <= 7 {
		gen test_`i' = .
		replace test_`i' = 0 if ID_proc == `i' & ID_yield == 200
		replace test_`i' = 1 if np_Profit >=0 & ID_proc == `i' & ID_yield == 200
		sum test_`i'
		mat np_above_0[4,`i'] = r(mean) // This variable will appear in row 4, column 1 to 7
		local i = `i' + 1
	}
drop test_2-test_7
putexcel set "C:\Users\...\Results.xlsx", sheet ("Net present above zero") modify // Replace by working directory
putexcel B2=matrix(np_above_0)
}
*

// VALUE CHAIN COMPARISONS
{
mat VC_comp = J(8,15,.) // Rows = 8 profitability measures. Columns = max 15 comparisons.

// You have to do it separately for low and high yield, because otherwise there are duplicate ID_proc in the reshape command. Start with low yield.
reorder ID_draw ID_proc ID_yield np_RetLand_H np_RetLand_F np_RetLabour np_Profit 
drop amount_trees_ha-Profit_0
drop if ID_yield == 200 // Drop the high yield scenario
reshape wide ID_yield-np_Profit, i(ID_draw) j(ID_proc)

* Farmers: Net present return to land of biofuel tree cultivation (family land, hired labour) - Low yield
list np_RetLand_H1 np_RetLand_H2 np_RetLand_H3 np_RetLand_H4 np_RetLand_H5 np_RetLand_H6 np_RetLand_H7 if _n <= 10
	// 2=3 ; 4=5 ; 6=7
cor np_RetLand_H2 np_RetLand_H3 // 1
cor np_RetLand_H4 np_RetLand_H5 // 1
cor np_RetLand_H6 np_RetLand_H7 // 1
gen better_1_than_23 = 0
gen better_1_than_45 = 0
gen better_1_than_67 = 0
gen better_45_than_23 = 0
gen better_45_than_67 = 0
gen better_23_than_67 = 0
replace better_1_than_23 = 1 if np_RetLand_H1 > np_RetLand_H2
replace better_1_than_45 = 1 if np_RetLand_H1 > np_RetLand_H4
replace better_1_than_67 = 1 if np_RetLand_H1 > np_RetLand_H6
replace better_45_than_23 = 1 if np_RetLand_H4 > np_RetLand_H2
replace better_45_than_67 = 1 if np_RetLand_H4 > np_RetLand_H6
replace better_23_than_67 = 1 if np_RetLand_H2 > np_RetLand_H6
sum better_1_than_23
mat VC_comp[1,1] = r(mean)
sum better_1_than_45
mat VC_comp[1,2] = r(mean)
sum better_1_than_67
mat VC_comp[1,3] = r(mean)
sum better_45_than_23
mat VC_comp[1,4] = r(mean)
sum better_45_than_67
mat VC_comp[1,5] = r(mean)
sum better_23_than_67
mat VC_comp[1,6] = r(mean)
drop better_1_than_23-better_23_than_67

* Farmers: Net present return to land of biofuel tree cultivation (family land, family labour) - Low yield
list np_RetLand_F1 np_RetLand_F2 np_RetLand_F3 np_RetLand_F4 np_RetLand_F5 np_RetLand_F6 np_RetLand_F7 if _n <= 10
	// 2=3 ; 4=5 ; 6=7
cor np_RetLand_F2 np_RetLand_F3 // 1
cor np_RetLand_F4 np_RetLand_F5 // 1
cor np_RetLand_F6 np_RetLand_F7 // 1
gen better_1_than_23 = 0
gen better_1_than_45 = 0
gen better_1_than_67 = 0
gen better_45_than_23 = 0
gen better_45_than_67 = 0
gen better_23_than_67 = 0
replace better_1_than_23 = 1 if np_RetLand_F1 > np_RetLand_F2
replace better_1_than_45 = 1 if np_RetLand_F1 > np_RetLand_F4
replace better_1_than_67 = 1 if np_RetLand_F1 > np_RetLand_F6
replace better_45_than_23 = 1 if np_RetLand_F4 > np_RetLand_F2
replace better_45_than_67 = 1 if np_RetLand_F4 > np_RetLand_F6
replace better_23_than_67 = 1 if np_RetLand_F2 > np_RetLand_F6
sum better_1_than_23
mat VC_comp[3,1] = r(mean)
sum better_1_than_45
mat VC_comp[3,2] = r(mean)
sum better_1_than_67
mat VC_comp[3,3] = r(mean)
sum better_45_than_23
mat VC_comp[3,4] = r(mean)
sum better_45_than_67
mat VC_comp[3,5] = r(mean)
sum better_23_than_67
mat VC_comp[3,6] = r(mean)
drop better_1_than_23-better_23_than_67

* Farmers: Net present return to labour of biofuel tree cultivation (family land, family labour) - Low yield
list np_RetLabour1 np_RetLabour2 np_RetLabour3 np_RetLabour4 np_RetLabour5 np_RetLabour6 np_RetLabour7 if _n <= 10
	// 2=3 ; 4=5 ; 6=7
cor np_RetLabour2 np_RetLabour3 // 1
cor np_RetLabour4 np_RetLabour5 // 1
cor np_RetLabour6 np_RetLabour7 // 1
gen better_1_than_23 = 0
gen better_1_than_45 = 0
gen better_1_than_67 = 0
gen better_45_than_23 = 0
gen better_45_than_67 = 0
gen better_23_than_67 = 0
replace better_1_than_23 = 1 if np_RetLabour1 > np_RetLabour2
replace better_1_than_45 = 1 if np_RetLabour1 > np_RetLabour4
replace better_1_than_67 = 1 if np_RetLabour1 > np_RetLabour6
replace better_45_than_23 = 1 if np_RetLabour4 > np_RetLabour2
replace better_45_than_67 = 1 if np_RetLabour4 > np_RetLabour6
replace better_23_than_67 = 1 if np_RetLabour2 > np_RetLabour6
sum better_1_than_23
mat VC_comp[5,1] = r(mean)
sum better_1_than_45
mat VC_comp[5,2] = r(mean)
sum better_1_than_67
mat VC_comp[5,3] = r(mean)
sum better_45_than_23
mat VC_comp[5,4] = r(mean)
sum better_45_than_67
mat VC_comp[5,5] = r(mean)
sum better_23_than_67
mat VC_comp[5,6] = r(mean)
drop better_1_than_23-better_23_than_67

* Processors: net present profit of biofuel tree cultivation - Low yield
gen better_2_than_3 = 0
gen better_2_than_4 = 0
gen better_2_than_5 = 0
gen better_2_than_6 = 0
gen better_2_than_7 = 0
gen better_3_than_4 = 0
gen better_3_than_5 = 0
gen better_3_than_6 = 0
gen better_3_than_7 = 0
gen better_4_than_5 = 0
gen better_4_than_6 = 0
gen better_4_than_7 = 0
gen better_5_than_6 = 0
gen better_5_than_7 = 0
gen better_6_than_7 = 0
replace better_2_than_3 = 1 if np_Profit2 > np_Profit3
replace better_2_than_4 = 1 if np_Profit2 > np_Profit4
replace better_2_than_5 = 1 if np_Profit2 > np_Profit5
replace better_2_than_6 = 1 if np_Profit2 > np_Profit6
replace better_2_than_7 = 1 if np_Profit2 > np_Profit7
replace better_3_than_4 = 1 if np_Profit3 > np_Profit4
replace better_3_than_5 = 1 if np_Profit3 > np_Profit5
replace better_3_than_6 = 1 if np_Profit3 > np_Profit6
replace better_3_than_7 = 1 if np_Profit3 > np_Profit7
replace better_4_than_5 = 1 if np_Profit4 > np_Profit5
replace better_4_than_6 = 1 if np_Profit4 > np_Profit6
replace better_4_than_7 = 1 if np_Profit4 > np_Profit7
replace better_5_than_6 = 1 if np_Profit5 > np_Profit6
replace better_5_than_7 = 1 if np_Profit5 > np_Profit7
replace better_6_than_7 = 1 if np_Profit6 > np_Profit7
sum better_2_than_3
mat VC_comp[7,1] = r(mean)
sum better_2_than_4
mat VC_comp[7,2] = r(mean)
sum better_2_than_5
mat VC_comp[7,3] = r(mean)
sum better_2_than_6
mat VC_comp[7,4] = r(mean)
sum better_2_than_7
mat VC_comp[7,5] = r(mean)
sum better_3_than_4
mat VC_comp[7,6] = r(mean)
sum better_3_than_5
mat VC_comp[7,7] = r(mean)
sum better_3_than_6
mat VC_comp[7,8] = r(mean)
sum better_3_than_7
mat VC_comp[7,9] = r(mean)
sum better_4_than_5
mat VC_comp[7,10] = r(mean)
sum better_4_than_6
mat VC_comp[7,11] = r(mean)
sum better_4_than_7
mat VC_comp[7,12] = r(mean)
sum better_5_than_6
mat VC_comp[7,13] = r(mean)
sum better_5_than_7
mat VC_comp[7,14] = r(mean)
sum better_6_than_7
mat VC_comp[7,15] = r(mean)

// Now do it for the high yield
clear
use ProfitabilityMeasures.dta
reorder ID_draw ID_proc ID_yield np_RetLand_H np_RetLand_F np_RetLabour np_Profit 
drop amount_trees_ha-Profit_0
drop if ID_yield == 100 // Drop the low yield scenario
reshape wide ID_yield-np_Profit, i(ID_draw) j(ID_proc)

* Farmers: Net present return to land of biofuel tree cultivation (family land, hired labour) - High yield
list np_RetLand_H1 np_RetLand_H2 np_RetLand_H3 np_RetLand_H4 np_RetLand_H5 np_RetLand_H6 np_RetLand_H7 if _n <= 10
	// 2=3 ; 4=5 ; 6=7
cor np_RetLand_H2 np_RetLand_H3 // 1
cor np_RetLand_H4 np_RetLand_H5 // 1
cor np_RetLand_H6 np_RetLand_H7 // 1
gen better_1_than_23 = 0
gen better_1_than_45 = 0
gen better_1_than_67 = 0
gen better_45_than_23 = 0
gen better_45_than_67 = 0
gen better_23_than_67 = 0
replace better_1_than_23 = 1 if np_RetLand_H1 > np_RetLand_H2
replace better_1_than_45 = 1 if np_RetLand_H1 > np_RetLand_H4
replace better_1_than_67 = 1 if np_RetLand_H1 > np_RetLand_H6
replace better_45_than_23 = 1 if np_RetLand_H4 > np_RetLand_H2
replace better_45_than_67 = 1 if np_RetLand_H4 > np_RetLand_H6
replace better_23_than_67 = 1 if np_RetLand_H2 > np_RetLand_H6
sum better_1_than_23
mat VC_comp[2,1] = r(mean)
sum better_1_than_45
mat VC_comp[2,2] = r(mean)
sum better_1_than_67
mat VC_comp[2,3] = r(mean)
sum better_45_than_23
mat VC_comp[2,4] = r(mean)
sum better_45_than_67
mat VC_comp[2,5] = r(mean)
sum better_23_than_67
mat VC_comp[2,6] = r(mean)
drop better_1_than_23-better_23_than_67

* Farmers: Net present return to land of biofuel tree cultivation (family land, family labour) - High yield
list np_RetLand_F1 np_RetLand_F2 np_RetLand_F3 np_RetLand_F4 np_RetLand_F5 np_RetLand_F6 np_RetLand_F7 if _n <= 10
	// 2=3 ; 4=5 ; 6=7
cor np_RetLand_F2 np_RetLand_F3 // 1
cor np_RetLand_F4 np_RetLand_F5 // 1
cor np_RetLand_F6 np_RetLand_F7 // 1
gen better_1_than_23 = 0
gen better_1_than_45 = 0
gen better_1_than_67 = 0
gen better_45_than_23 = 0
gen better_45_than_67 = 0
gen better_23_than_67 = 0
replace better_1_than_23 = 1 if np_RetLand_F1 > np_RetLand_F2
replace better_1_than_45 = 1 if np_RetLand_F1 > np_RetLand_F4
replace better_1_than_67 = 1 if np_RetLand_F1 > np_RetLand_F6
replace better_45_than_23 = 1 if np_RetLand_F4 > np_RetLand_F2
replace better_45_than_67 = 1 if np_RetLand_F4 > np_RetLand_F6
replace better_23_than_67 = 1 if np_RetLand_F2 > np_RetLand_F6
sum better_1_than_23
mat VC_comp[4,1] = r(mean)
sum better_1_than_45
mat VC_comp[4,2] = r(mean)
sum better_1_than_67
mat VC_comp[4,3] = r(mean)
sum better_45_than_23
mat VC_comp[4,4] = r(mean)
sum better_45_than_67
mat VC_comp[4,5] = r(mean)
sum better_23_than_67
mat VC_comp[4,6] = r(mean)
drop better_1_than_23-better_23_than_67

* Farmers: Net present return to labour of biofuel tree cultivation (family land, family labour) - High yield
list np_RetLabour1 np_RetLabour2 np_RetLabour3 np_RetLabour4 np_RetLabour5 np_RetLabour6 np_RetLabour7 if _n <= 10
	// 2=3 ; 4=5 ; 6=7
cor np_RetLabour2 np_RetLabour3 // 1
cor np_RetLabour4 np_RetLabour5 // 1
cor np_RetLabour6 np_RetLabour7 // 1
gen better_1_than_23 = 0
gen better_1_than_45 = 0
gen better_1_than_67 = 0
gen better_45_than_23 = 0
gen better_45_than_67 = 0
gen better_23_than_67 = 0
replace better_1_than_23 = 1 if np_RetLabour1 > np_RetLabour2
replace better_1_than_45 = 1 if np_RetLabour1 > np_RetLabour4
replace better_1_than_67 = 1 if np_RetLabour1 > np_RetLabour6
replace better_45_than_23 = 1 if np_RetLabour4 > np_RetLabour2
replace better_45_than_67 = 1 if np_RetLabour4 > np_RetLabour6
replace better_23_than_67 = 1 if np_RetLabour2 > np_RetLabour6
sum better_1_than_23
mat VC_comp[6,1] = r(mean)
sum better_1_than_45
mat VC_comp[6,2] = r(mean)
sum better_1_than_67
mat VC_comp[6,3] = r(mean)
sum better_45_than_23
mat VC_comp[6,4] = r(mean)
sum better_45_than_67
mat VC_comp[6,5] = r(mean)
sum better_23_than_67
mat VC_comp[6,6] = r(mean)
drop better_1_than_23-better_23_than_67

* Processors: net present profit of biofuel tree cultivation - High yield
list np_Profit2 np_Profit3 np_Profit4 np_Profit5 np_Profit6 np_Profit7 if _n <= 10
gen better_2_than_3 = 0
gen better_2_than_4 = 0
gen better_2_than_5 = 0
gen better_2_than_6 = 0
gen better_2_than_7 = 0
gen better_3_than_4 = 0
gen better_3_than_5 = 0
gen better_3_than_6 = 0
gen better_3_than_7 = 0
gen better_4_than_5 = 0
gen better_4_than_6 = 0
gen better_4_than_7 = 0
gen better_5_than_6 = 0
gen better_5_than_7 = 0
gen better_6_than_7 = 0
replace better_2_than_3 = 1 if np_Profit2 > np_Profit3
replace better_2_than_4 = 1 if np_Profit2 > np_Profit4
replace better_2_than_5 = 1 if np_Profit2 > np_Profit5
replace better_2_than_6 = 1 if np_Profit2 > np_Profit6
replace better_2_than_7 = 1 if np_Profit2 > np_Profit7
replace better_3_than_4 = 1 if np_Profit3 > np_Profit4
replace better_3_than_5 = 1 if np_Profit3 > np_Profit5
replace better_3_than_6 = 1 if np_Profit3 > np_Profit6
replace better_3_than_7 = 1 if np_Profit3 > np_Profit7
replace better_4_than_5 = 1 if np_Profit4 > np_Profit5
replace better_4_than_6 = 1 if np_Profit4 > np_Profit6
replace better_4_than_7 = 1 if np_Profit4 > np_Profit7
replace better_5_than_6 = 1 if np_Profit5 > np_Profit6
replace better_5_than_7 = 1 if np_Profit5 > np_Profit7
replace better_6_than_7 = 1 if np_Profit6 > np_Profit7
sum better_2_than_3
mat VC_comp[8,1] = r(mean)
sum better_2_than_4
mat VC_comp[8,2] = r(mean)
sum better_2_than_5
mat VC_comp[8,3] = r(mean)
sum better_2_than_6
mat VC_comp[8,4] = r(mean)
sum better_2_than_7
mat VC_comp[8,5] = r(mean)
sum better_3_than_4
mat VC_comp[8,6] = r(mean)
sum better_3_than_5
mat VC_comp[8,7] = r(mean)
sum better_3_than_6
mat VC_comp[8,8] = r(mean)
sum better_3_than_7
mat VC_comp[8,9] = r(mean)
sum better_4_than_5
mat VC_comp[8,10] = r(mean)
sum better_4_than_6
mat VC_comp[8,11] = r(mean)
sum better_4_than_7
mat VC_comp[8,12] = r(mean)
sum better_5_than_6
mat VC_comp[8,13] = r(mean)
sum better_5_than_7
mat VC_comp[8,14] = r(mean)
sum better_6_than_7
mat VC_comp[8,15] = r(mean)
mat list VC_comp
putexcel set "C:\Users\...\Results.xlsx", sheet ("VC Comparison") modify // Replace by working directory
putexcel B2=matrix(VC_comp)
clear
use ProfitabilityMeasures.dta
}
*
}
*


*** MEDIAN PROFITABILITY GRAPHS
{

// Calculate and export median patterns, separately for high and low yield scenarios
// Low yield
mat med_LY = J(31,28,.) // Rows = 31 years (including the planting year 0). Columns = 7 value chain scenarios * 4 profitability measures
local i = 1 // Value chain scenarios
while `i' <= 7 {
	local j = 0 // Years
	while `j' <= 30 {
		* Farmers: Median return to land of biofuel tree cultivation (family land, hired labour) - Low yield 
		qui sum RetLand_H_`j' if ID_proc == `i' & ID_yield == 100, d
		qui mat med_LY[`j'+1,`i'] = r(p50) // This variable will appear in columns 1 to 7 => names in excel: MedRetLand_LY_H_1 to MedRetLand_LY_H_7
		* Farmers: Median return to land of biofuel tree cultivation (family land, family labour) - Low yield 
		qui sum RetLand_F_`j' if ID_proc == `i' & ID_yield == 100, d
		qui mat med_LY[`j'+1,`i'+7] = r(p50) // This variable will appear in columns 8 to 14 => names in excel: MedRetLand_LY_F_1 to MedRetLand_LY_F_7
		* Farmers: Median return to labour of biofuel tree cultivation (family land, family labour) - Low yield 
		qui sum RetLabour_`j' if ID_proc == `i' & ID_yield == 100, d
		qui mat med_LY[`j'+1,`i'+14] = r(p50) // This variable will appear in columns 15 to 21 => names in excel: MedRetLab_LY_1 to MedRetLab_LY_7
		* Processors: Median profit of biofuel tree cultivation - Low yield
		qui sum Profit_`j' if ID_proc == `i' & ID_yield == 100, d
		qui mat med_LY[`j'+1,`i'+21] = r(p50) // This variable will appear in columns 22 to 28 => names in excel: MedProfit_LY_1 to MedProfit_LY_7
		di "." _cont
	local j = `j' + 1	
	}
local i = `i' + 1
}
putexcel set "C:\Users\...\Results.xlsx", sheet ("Median pattern") modify // Replace by working directory
putexcel B2=matrix(med_LY)
// High yield
mat med_HY = J(31,28,.) // Rows = 31 years (including the planting year 0). Columns = 7 value chain scenarios * 4 profitability measures
local i = 1 // Value chain scenarios
while `i' <= 7 {
	local j = 0 // Years
	while `j' <= 30 {
		* Farmers: Median return to land of biofuel tree cultivation (family land, hired labour) - High yield 
		qui sum RetLand_H_`j' if ID_proc == `i' & ID_yield == 200, d
		qui mat med_HY[`j'+1,`i'] = r(p50) // This variable will appear in columns 1 to 7 => names in excel: MedRetLand_HY_H_1 to MedRetLand_HY_H_7
		* Farmers: Median return to land of biofuel tree cultivation (family land, family labour) - High yield 
		qui sum RetLand_F_`j' if ID_proc == `i' & ID_yield == 200, d
		qui mat med_HY[`j'+1,`i'+7] = r(p50) // This variable will appear in columns 8 to 14 => names in excel: MedRetLand_HY_F_1 to MedRetLand_HY_F_7
		* Farmers: Median return to labour of biofuel tree cultivation (family land, family labour) - High yield 
		qui sum RetLabour_`j' if ID_proc == `i' & ID_yield == 200, d
		qui mat med_HY[`j'+1,`i'+14] = r(p50) // This variable will appear in columns 15 to 21 => names in excel: MedRetLab_HY_1 to MedRetLab_HY_7
		* Processors: Median profit of biofuel tree cultivation - High yield
		qui sum Profit_`j' if ID_proc == `i' & ID_yield == 200, d
		qui mat med_HY[`j'+1,`i'+21] = r(p50) // This variable will appear in columns 22 to 28 => names in excel: MedProfit_HY_1 to MedProfit_HY_7
		di "." _cont
	local j = `j' + 1	
	}
local i = `i' + 1
}
putexcel set "C:\Users\...\Results.xlsx", sheet ("Median pattern") modify // Replace by working directory
putexcel AD2=matrix(med_HY)
clear

// Import the median data
/* First you have to manually add variable names to the columns in the "Median pattern" sheet in excel (see above in comments)
	You also have to add a variable "year" to column A, which runs from 0 to 30
	Always open, save and close the excel file before proceeding (it needs to update the exported data!!!) */
import excel using "C:\Users\...\Results.xlsx", sheet ("Median pattern") firstrow // Replace by working directory
// Some value chain scenarios will be highly correlated for farmers
cor MedRetLand_LY_H_2 MedRetLand_LY_H_3
cor MedRetLand_LY_H_4 MedRetLand_LY_H_5 
cor MedRetLand_LY_H_6 MedRetLand_LY_H_7 
cor MedRetLand_LY_F_2 MedRetLand_LY_F_3 
cor MedRetLand_LY_F_4 MedRetLand_LY_F_5 
cor MedRetLand_LY_F_6 MedRetLand_LY_F_7 
cor MedRetLab_LY_2 MedRetLab_LY_3
cor MedRetLab_LY_4 MedRetLab_LY_5 
cor MedRetLab_LY_6 MedRetLab_LY_7 
cor MedRetLand_HY_H_2 MedRetLand_HY_H_3
cor MedRetLand_HY_H_4 MedRetLand_HY_H_5 
cor MedRetLand_HY_H_6 MedRetLand_HY_H_7 
cor MedRetLand_HY_F_2 MedRetLand_HY_F_3 
cor MedRetLand_HY_F_4 MedRetLand_HY_F_5 
cor MedRetLand_HY_F_6 MedRetLand_HY_F_7 
cor MedRetLab_HY_2 MedRetLab_HY_3
cor MedRetLab_HY_4 MedRetLab_HY_5 
cor MedRetLab_HY_6 MedRetLab_HY_7 
// In all cases perfect correlation. Let's take averages to use 
gen MedRetLand_LY_H_23 = (MedRetLand_LY_H_2 + MedRetLand_LY_H_3) / 2
gen MedRetLand_LY_H_45 = (MedRetLand_LY_H_4 + MedRetLand_LY_H_5) / 2 
gen MedRetLand_LY_H_67 = (MedRetLand_LY_H_6 + MedRetLand_LY_H_7) / 2 
gen MedRetLand_LY_F_23 = (MedRetLand_LY_F_2 + MedRetLand_LY_F_3) / 2
gen MedRetLand_LY_F_45 = (MedRetLand_LY_F_4 + MedRetLand_LY_F_5) / 2 
gen MedRetLand_LY_F_67 = (MedRetLand_LY_F_6 + MedRetLand_LY_F_7) / 2  
gen MedRetLab_LY_23 = (MedRetLab_LY_2 + MedRetLab_LY_3) / 2 
gen MedRetLab_LY_45 = (MedRetLab_LY_4 + MedRetLab_LY_5) / 2 
gen MedRetLab_LY_67 = (MedRetLab_LY_6 + MedRetLab_LY_7) / 2 
gen MedRetLand_HY_H_23 = (MedRetLand_HY_H_2 + MedRetLand_HY_H_3) / 2
gen MedRetLand_HY_H_45 = (MedRetLand_HY_H_4 + MedRetLand_HY_H_5) / 2 
gen MedRetLand_HY_H_67 = (MedRetLand_HY_H_6 + MedRetLand_HY_H_7) / 2 
gen MedRetLand_HY_F_23 = (MedRetLand_HY_F_2 + MedRetLand_HY_F_3) / 2
gen MedRetLand_HY_F_45 = (MedRetLand_HY_F_4 + MedRetLand_HY_F_5) / 2 
gen MedRetLand_HY_F_67 = (MedRetLand_HY_F_6 + MedRetLand_HY_F_7) / 2  
gen MedRetLab_HY_23 = (MedRetLab_HY_2 + MedRetLab_HY_3) / 2 
gen MedRetLab_HY_45 = (MedRetLab_HY_4 + MedRetLab_HY_5) / 2 
gen MedRetLab_HY_67 = (MedRetLab_HY_6 + MedRetLab_HY_7) / 2 

// Graphs
* Farmers: Median return to land of biofuel tree cultivation (family land, hired labour) - Low yield
twoway (line MedRetLand_LY_H_1 year, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (line MedRetLand_LY_H_23 year, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedRetLand_LY_H_45 year, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (line MedRetLand_LY_H_67 year, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Return to land (INR/(ha*year))") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) xtick(5 15 25) ///
	title("Median return to land for farmers" "Hired labour - Low yield") ///
	graphregion(color(white)) yscale(range(-20000 300000) titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) ///
	ylabel(0(100000)300000) ymtick(0(50000)300000)  ///
	name(median_return_land_LY_H, replace)
graph export "C:\Users\...\median_return_land_LY_H.pdf", replace as(pdf) // Replace by working directory

* Farmers: Median return to land of biofuel tree cultivation (family land, hired labour) - High yield 
twoway (line MedRetLand_HY_H_1 year, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (line MedRetLand_HY_H_23 year, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedRetLand_HY_H_45 year, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (line MedRetLand_HY_H_67 year, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Return to land (INR/(ha*year))") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) xtick(5 15 25) ///
	title("Median return to land for farmers" "Hired labour - High yield") ///
	graphregion(color(white)) yscale(range(-20000 300000) titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none)))  ///
	ylabel(0(100000)300000) ymtick(0(50000)300000)  ///
	name(median_return_land_HY_H, replace)
graph export "C:\Users\...\median_return_land_HY_H.pdf", replace as(pdf) // Replace by working directory	

* Farmers: Median return to land of biofuel tree cultivation (family land, family labour) - Low yield 
twoway (line MedRetLand_LY_F_1 year, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (line MedRetLand_LY_F_23 year, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedRetLand_LY_F_45 year, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (line MedRetLand_LY_F_67 year, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Return to land (INR/(ha*year))") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) xtick(5 15 25) ///
	title("Median return to land for farmers" "Family labour - Low yield") ///
	graphregion(color(white)) yscale(range(-20000 300000) titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) ///
	ylabel(0(100000)300000) ymtick(0(50000)300000)  ///
	name(median_return_land_LY_F, replace)
graph export "C:\Users\...\median_return_land_LY_F.pdf", replace as(pdf) // Replace by working directory	

* Farmers: Median return to land of biofuel tree cultivation (family land, family labour) - High yield 
twoway (line MedRetLand_HY_F_1 year, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (line MedRetLand_HY_F_23 year, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedRetLand_HY_F_45 year, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (line MedRetLand_HY_F_67 year, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Return to land (INR/(ha*year))") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) xtick(5 15 25) ///
	title("Median return to land for farmers" "Family labour - High yield") ///
	graphregion(color(white)) yscale(range(-20000 300000) titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) ///
	ymtick(0(50000)300000)  ///
	name(median_return_land_HY_F, replace)
graph export "C:\Users\...\median_return_land_HY_F.pdf", replace as(pdf) // Replace by working directory	

* Farmers: Median return to labour of biofuel tree cultivation (family land, family labour) - Low yield 
twoway (line MedRetLab_LY_1 year if year >= 5, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (line MedRetLab_LY_23 year if year >= 5, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedRetLab_LY_45 year if year >= 5, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (line MedRetLab_LY_67 year if year >= 5, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Return to labour (INR/hour)") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) xtick(5 15 25) ///
	title("Median return to labour for farmers - Low yield") ///
	graphregion(color(white)) yscale(range(70) titlegap(3)) xscale(range(0) titlegap(3) outergap(3)) legend(region(style(none))) ///
	ylabel(0(15)75) xlabel(0(10)30)  ///
	name(median_return_labour_LY, replace)
graph export "C:\Users\...\median_return_labour_LY.pdf", replace as(pdf) // Replace by working directory	

* Farmers: Median return to labour of biofuel tree cultivation (family land, family labour) - High yield 
twoway (line MedRetLab_HY_1 year if year >= 5, lwidth(medthick) lcolor(midblue) lpattern("_-")) ///
	|| (line MedRetLab_HY_23 year if year >= 5, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedRetLab_HY_45 year if year >= 5, lwidth(medthick) lcolor(gs10) lpattern(solid)) ///
	|| (line MedRetLab_HY_67 year if year >= 5, lwidth(medthick) lcolor(gold) lpattern("_")) ///
	, ytitle("Return to labour (INR/hour)") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-oil chain") label(2 "Farmer-BP chains") label(3 "BP chains") label(4 "Farmer-Industry chains")) xtick(5 15 25) ///
	title("Median return to labour for farmers - High yield") ///
	graphregion(color(white)) yscale(range(70) titlegap(3)) xscale(range(0) titlegap(3) outergap(3)) legend(region(style(none))) ///
	ylabel(0(15)75)  xlabel(0(10)30) ///
	name(median_return_labour_HY, replace)	
graph export "C:\Users\...\median_return_labour_HY.pdf", replace as(pdf) // Replace by working directory

* Processors: Median profit of biofuel tree cultivation - Low yield	
twoway (line MedProfit_LY_2 year, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedProfit_LY_3 year, lwidth(medthick) lcolor(orange) lpattern("solid")) ///
	|| (line MedProfit_LY_4 year, lwidth(medthick) lcolor(gs10) lpattern("-")) ///
	|| (line MedProfit_LY_5 year, lwidth(medthick) lcolor(gs10) lpattern("solid")) ///
	|| (line MedProfit_LY_6 year, lwidth(medthick) lcolor(gold) lpattern("-")) ///
	|| (line MedProfit_LY_7 year, lwidth(medthick) lcolor(gold) lpattern("solid")) ///
	, ytitle("Profit (INR/(ha*year))") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-BP-oil chain") label(2 "Farmer-BP-biodiesel chain") label(3 "BP-oil chain") label(4 "BP-biodiesel chain") label(5 "Farmer-Industry-oil chain") label(6 "Farmer-Industry-biodiesel chain")) xtick(5 15 25) ///
	title("Median profit for processors - Low yield") ///
	graphregion(color(white)) yscale(range(90000) titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) ///
	ylabel(-30000(30000)90000)  ///
	name(median_prof_LY, replace)	
graph export "C:\Users\...\median_prof_LY.pdf", replace as(pdf) // Replace by working directory

* Processors: Median profit of biofuel tree cultivation - High yield
twoway (line MedProfit_HY_2 year, lwidth(medthick) lcolor(orange) lpattern("-")) ///
	|| (line MedProfit_HY_3 year, lwidth(medthick) lcolor(orange) lpattern("solid")) ///
	|| (line MedProfit_HY_4 year, lwidth(medthick) lcolor(gs10) lpattern("-")) ///
	|| (line MedProfit_HY_5 year, lwidth(medthick) lcolor(gs10) lpattern("solid")) ///
	|| (line MedProfit_HY_6 year, lwidth(medthick) lcolor(gold) lpattern("-")) ///
	|| (line MedProfit_HY_7 year, lwidth(medthick) lcolor(gold) lpattern("solid")) ///
	, ytitle("Profit (INR/(ha*year))") xtitle("Years after planting") yline(0) ///
	legend(label(1 "Farmer-BP-oil chain") label(2 "Farmer-BP-biodiesel chain") label(3 "BP-oil chain") label(4 "BP-biodiesel chain") label(5 "Farmer-Industry-oil chain") label(6 "Farmer-Industry-biodiesel chain")) xtick(5 15 25) ///
	title("Median profit for processors - High yield") ///
	graphregion(color(white)) yscale(range(90000) titlegap(3)) xscale(titlegap(3) outergap(3)) legend(region(style(none))) ///
	ylabel(-30000(30000)90000)  ///
	name(median_prof_HY, replace)	
graph export "C:\Users\...\median_prof_HY.pdf", replace as(pdf)	// Replace by working directory
clear
use ProfitabilityMeasures.dta
}
*
}
*









/***** SENSITIVITY ANALYSIS *****/
{
// Principal component analysis for yield-related parameters
pca fruit_yield_ha_5 fruit_yield_ha_6 fruit_yield_ha_7 fruit_yield_ha_8 fruit_yield_ha_9 fruit_yield_ha_10 ///
	fruit_yield_ha_15 fruit_yield_ha_20 fruit_yield_ha_25 fruit_yield_ha_30 ///
	seed_fruit_ratio harvest_rate_tarpel // Iets minder, maar weinig keuze
mat list e(L)
predict yield_pca seed_fruit_ratio_pca harvest_rate_pca
* The harvest_rate_pca has a negative harvest_rate loading = confusing.
replace harvest_rate_pca = -1 * harvest_rate_pca
cor fruit_yield_ha_5 fruit_yield_ha_6 fruit_yield_ha_7 fruit_yield_ha_8 fruit_yield_ha_9 fruit_yield_ha_10 ///
	fruit_yield_ha_15 fruit_yield_ha_20 fruit_yield_ha_25 fruit_yield_ha_30 yield_pca
cor seed_fruit_ratio seed_fruit_ratio_pca
cor harvest_rate_tarpel harvest_rate_pca

// Correlation matrix: are there still significant correlations existing => consider it per value chain (because sensitivity analysis is per value chain)
cor yield_pca seed_fruit_ratio_pca oil_content harvest_rate_pca dec_rate dec_eff exp_rate exp_oil ///
	fruits_price seeds_price oil_price cake_price biodiesel_price labour_wage_men labour_wage_wome if ID_proc == 1
cor yield_pca seed_fruit_ratio_pca oil_content harvest_rate_pca dec_rate dec_eff exp_rate exp_oil ///
	fruits_price seeds_price oil_price cake_price biodiesel_price labour_wage_men labour_wage_wome if ID_proc == 2
cor yield_pca seed_fruit_ratio_pca oil_content harvest_rate_pca dec_rate dec_eff exp_rate exp_oil conv_rate conv_cost ///
	fruits_price seeds_price oil_price cake_price biodiesel_price labour_wage_men labour_wage_wome if ID_proc == 3
cor yield_pca seed_fruit_ratio_pca oil_content harvest_rate_pca dec_rate dec_eff exp_rate exp_oil  ///
	fruits_price seeds_price oil_price cake_price biodiesel_price labour_wage_men labour_wage_wome if ID_proc == 4
cor yield_pca seed_fruit_ratio_pca oil_content harvest_rate_pca dec_rate dec_eff exp_rate exp_oil conv_rate conv_cost ///
	fruits_price seeds_price oil_price cake_price biodiesel_price labour_wage_men labour_wage_wome if ID_proc == 5
cor yield_pca seed_fruit_ratio_pca oil_content harvest_rate_pca dec_rate dec_eff exp_rate exp_oil ///
	fruits_price seeds_price oil_price cake_price biodiesel_price labour_wage_men labour_wage_wome if ID_proc == 6
cor yield_pca seed_fruit_ratio_pca oil_content harvest_rate_pca dec_rate dec_eff exp_rate exp_oil conv_rate conv_cost ///
	fruits_price seeds_price oil_price cake_price biodiesel_price labour_wage_men labour_wage_wome if ID_proc == 7

// Spearman correlations
local i = 1 // Value chain scenarios
while `i' <= 7 {
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour yield_pca if ID_proc == `i' , matrix
mat T = r(Rho)
mat T = T[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour seed_fruit_ratio_pca if ID_proc == `i' , matrix
mat U = r(Rho)
mat U = U[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour oil_content if ID_proc == `i' , matrix
mat V = r(Rho)
mat V = V[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour harvest_rate_pca if ID_proc == `i' , matrix
mat W = r(Rho)
mat W = W[5,1..4]
*spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour harvest_rate_multiplication if ID_proc == `i' , matrix
*mat X = r(Rho)
*mat X = X[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour dec_rate if ID_proc == `i' , matrix
mat Y = r(Rho)
mat Y = Y[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour dec_eff if ID_proc == `i' , matrix
mat Z = r(Rho)
mat Z = Z[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour exp_rate if ID_proc == `i' , matrix
mat AA = r(Rho)
mat AA = AA[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour exp_oil if ID_proc == `i' , matrix
mat AB = r(Rho)
mat AB = AB[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour conv_rate if ID_proc == `i' , matrix
mat AC = r(Rho)
mat AC = AC[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour conv_cost if ID_proc == `i' , matrix
mat AD = r(Rho)
mat AD = AD[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour fruits_price if ID_proc == `i' , matrix
mat AE = r(Rho)
mat AE = AE[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour seeds_price if ID_proc == `i' , matrix
mat AF = r(Rho)
mat AF = AF[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour oil_price if ID_proc == `i' , matrix
mat AG = r(Rho)
mat AG = AG[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour cake_price if ID_proc == `i' , matrix
mat AH = r(Rho)
mat AH = AH[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour biodiesel_price if ID_proc == `i' , matrix
mat AI = r(Rho)
mat AI = AI[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour labour_wage_men if ID_proc == `i' , matrix
mat AJ = r(Rho)
mat AJ = AJ[5,1..4]
spearman np_RetLand_H np_RetLand_F np_Profit np_RetLabour labour_wage_women if ID_proc == `i', matrix
mat AK = r(Rho)
mat AK = AK[5,1..4]
mat spearman_`i' = (T \ U \ V \ W \ Y \ Z \ AA \ AB \ AC \ AD \ AE \ AF \ AG \ AH \ AI \ AJ \ AK)
local i = `i' + 1
}
*
* Farmers: correlations for the return to land of biofuel tree cultivation (family land, hired labour)
mat spearman_RetLand_H = (spearman_1[1..17,1],spearman_2[1..17,1],spearman_3[1..17,1],spearman_4[1..17,1],spearman_5[1..17,1],spearman_6[1..17,1],spearman_7[1..17,1])
* Farmers: correlations for the return to land of biofuel tree cultivation (family land, family labour)
mat spearman_RetLand_F = (spearman_1[1..17,2],spearman_2[1..17,2],spearman_3[1..17,2],spearman_4[1..17,2],spearman_5[1..17,2],spearman_6[1..17,2],spearman_7[1..17,2])
* Farmers: correlations for the return to labour of biofuel tree cultivation (family land, family labour)
mat spearman_RetLabour = (spearman_1[1..17,4],spearman_2[1..17,4],spearman_3[1..17,4],spearman_4[1..17,4],spearman_5[1..17,4],spearman_6[1..17,4],spearman_7[1..17,4])
* Processors: correlations for the profit of biofuel tree cultivation
mat spearman_Profit = (spearman_1[1..17,3],spearman_2[1..17,3],spearman_3[1..17,3],spearman_4[1..17,3],spearman_5[1..17,3],spearman_6[1..17,3],spearman_7[1..17,3])

putexcel set "C:\Users\...\Results.xlsx", sheet ("Sensitivity - RetLand_H") modify // Replace by working directory
putexcel B2=matrix(spearman_RetLand_H)
putexcel set "C:\Users\...\Results.xlsx", sheet ("Sensitivity - RetLand_F") modify // Replace by working directory
putexcel B2=matrix(spearman_RetLand_F)
putexcel set "C:\Users\...\Results.xlsx", sheet ("Sensitivity - RetLabour") modify // Replace by working directory
putexcel B2=matrix(spearman_RetLabour)
putexcel set "C:\Users\...\Results.xlsx", sheet ("Sensitivity - Profit") modify // Replace by working directory
putexcel B2=matrix(spearman_Profit)

// The sensitivity graphs are subsequently made in excel
}	
*
