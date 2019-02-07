/*
IMPORTANT NOTE: the optimization as in Dalemans et al. (2019) is based on a three-step process
	
	(1) changing certain input parameters:
		 ** The effect of fruit / seed / oil / biodiesel price changes is investigated. This entails 4 different input datasets.
		 ** The effect of mechanized deshelling at village level is investigated. This entails 2 different input datasets.
		 ** In combination, there are 8 different input datasets for the optimization exercise. Correspondingly, there are 8 different
			do-files, i.e. they explore:
				1 The effect of fruit price changes, without mechanized deshelling at village level.
				2 The effect of seed price changes, without mechanized deshelling at village level.
				3 The effect of oil price changes, without mechanized deshelling at village level.
				4 The effect of biodiesel price changes, without mechanized deshelling at village level.
				5 The effect of fruit price changes, with mechanized deshelling at village level.
				6 The effect of seed price changes, with mechanized deshelling at village level.
				7 The effect of oil price changes, with mechanized deshelling at village level.
				8 The effect of biodiesel price changes, with mechanized deshelling at village level.
			These do-files are all very similar; therefore only 1 of the 8 is provided below (number 7). The other do-files can be easily derived
			from this one (further clarification is provided in the comments below).
		 ** In all of the 8 do-files, a medium yield scenario is used (instead of a high and low yield scenario)
		 ** In all of the 8 do-files, the processing parameters are fixed at their mean value (except for the deshelling rate)
	
	(2) profitability calculation: this is identical to the baseline analysis (in all 8 do-files) - except for potential electricity costs of deshelling at 
		village level (see lines 345, 430, 445).
		
	(3) profitability visualization: the results from all 8 do-files are exported to excel. Comparative graphs (like Figure 6 in Dalemans et al (2019))
		can be made in excel itself, or the excel files can be imported for visualization in Stata.
		Note: the calculated profitability measures in the optimization do-files are identical to those in the baseline do-file (only the input
		dataset differs). Therefore, one could also apply the profitability visualization code of the baseline do-file to the calculated measures
		of the optimization do-files.
		
	Input files:	Draws_baseline.dta
					Draws_opt.dta
					Non_stochastic_input_parameters.xlsx
	Output files:	Results_optimization.xlsx
*/

clear all
cd "C:\Users\..." // Replace by working directory
version 14
cap log close
log using Opt_Oil_Mechanized, text replace // Replace this for the other optimization do-files
set more off
set min_memory 2g









/***** DEVELOP FULL DATASET *****/
{

*** CREATE OIL PRICE SCENARIOS
{
// Import value chain scenarios & associated non-stochastic input parameters
import excel using "C:\Users\...\Non_stochastic_input_parameters.xlsx", sheet ("Value chain scenarios") firstrow // Replace by working directory
drop value_chain_scenario
/* Oil is only sold in value chains 1, 2, 4 and 6, so for the other value chains oil price changes won't make a difference. Therefore, they can
	be dropped from the simulation.
	NOTE: this is done similarly in the other optimization do-files, although different value chains are irrelevant in those cases:
		** If investigating effect of fruit prices: drop chains 1, 2, 3, 6 and 7
		** If investigating effect of seed prices: drop chains 1, 4 and 5
		** If investigating effect of biodiesel prices: drop chains 1, 2, 4 and 6 */
drop if ID_proc != 1 & ID_proc != 2 & ID_proc != 4 & ID_proc != 6

// Create oil price scenarios
/* Create different oil price scenarios, by using a discrete set of fixed oil price values. The values below are an example, 
	one could analogously use smaller/larger sets.
	NOTE: this is done similarly in the other optimization do-files, although there fruit, seed or biodiesel prices are changed */
expand 14
sort ID_proc
gen ID_oil = .
replace ID_oil = 42 if _n == 1 | _n == 15 | _n == 29 | _n == 43
replace ID_oil = 46 if _n == 2 | _n == 16 | _n == 30 | _n == 44
replace ID_oil = 50 if _n == 3 | _n == 17 | _n == 31 | _n == 45
replace ID_oil = 54 if _n == 4 | _n == 18 | _n == 32 | _n == 46
replace ID_oil = 58 if _n == 5 | _n == 19 | _n == 33 | _n == 47
replace ID_oil = 62 if _n == 6 | _n == 20 | _n == 34 | _n == 48
replace ID_oil = 66 if _n == 7 | _n == 21 | _n == 35 | _n == 49
replace ID_oil = 70 if _n == 8 | _n == 22 | _n == 36 | _n == 50
replace ID_oil = 74 if _n == 9 | _n == 23 | _n == 37 | _n == 51
replace ID_oil = 78 if _n == 10 | _n == 24 | _n == 38 | _n == 52
replace ID_oil = 82 if _n == 11 | _n == 25 | _n == 39 | _n == 53
replace ID_oil = 86 if _n == 12 | _n == 26 | _n == 40 | _n == 54
replace ID_oil = 90 if _n == 13 | _n == 27 | _n == 41 | _n == 55
replace ID_oil = 94 if _n == 14 | _n == 28 | _n == 42 | _n == 56
list ID_proc ID_oil // OK
reorder ID_proc ID_oil
save filetemp1.dta, replace
}
*

*** MERGE WITH AND ADAPT THE MONTE CARLO SAMPLES
{
// Replace stochastic input parameters
clear
use Draws_baseline.dta
/* 	The collection rate multiplication factor of the medium yield scenario should be used now (from Draws_opt.dta), instead of the one of 
	the high yield scenario.
	The mechanized deshelling rate at village level should be used now (from Draws_opt.dta), instead of the manual deshelling rate. NOTE: this 
	is not done in the optimization do-files where mechanized deshelling at village level is not assumed. */
drop harvest_rate_multiplication dec_rate_manual
merge 1:1 _n using Draws_opt.dta, assert(match) nogenerate
drop if _n > 10000 // 10000 Monte Carlo iterations for each fixed oil price value (see further)
save filetemp2.dta

// Merge
clear
use filetemp1.dta
cross using filetemp2.dta
erase filetemp1.dta
erase filetemp2.dta
replace oil_price = ID_oil

// Specify the deshelling rate
gen dec_rate = .
replace dec_rate = dec_rate_vil_mechanical if ID_proc != 4 & ID_proc != 5 /* NOTE: in the do-files where mechanized deshelling at village level is
	not assumed, dec_rate_manual is used instead of dec_rate_vil_mechanical */
replace dec_rate = dec_rate_mechanical if ID_proc == 4 | ID_proc == 5
drop dec_rate_vil_mechanical dec_rate_mechanical

// Specify the collection rate
replace harvest_rate_tarpel = harvest_rate_tarpel * harvest_rate_multiplication
sum harvest_rate_tarpel
drop harvest_rate_multiplication

// Fix stochastic processing factors at their mean (except for deshelling rate)
gen dec_eff = .
sum dec_eff_mechanical // NOTE: in the do-files where mechanized deshelling at village level is not assumed, dec_eff_manual is used
replace dec_eff = r(mean) if ID_proc != 4 & ID_proc != 5
sum dec_eff_mechanical
replace dec_eff = r(mean) if ID_proc == 4 | ID_proc == 5
gen exp_rate = .
sum exp_rate_village
replace exp_rate = r(mean) if ID_proc == 1
sum exp_rate_BP
replace exp_rate = r(mean) if ID_proc > 1 & ID_proc < 6
sum exp_rate_LS
replace exp_rate = r(mean) if ID_proc > 5
gen exp_oil = .
sum exp_oil_village
replace exp_oil = r(mean) if ID_proc == 1
sum exp_oil_BPLS
replace exp_oil = r(mean) if ID_proc != 1
gen conv_rate = .
sum conv_rate_BP
replace conv_rate = r(mean) if ID_proc == 3 | ID_proc == 5
sum conv_rate_LS
replace conv_rate = r(mean) if ID_proc == 7
gen conv_cost = .
sum conv_cost_BP
replace conv_cost = r(mean) if ID_proc == 3 | ID_proc == 5
sum conv_cost_LS
replace conv_cost = r(mean) if ID_proc == 7
drop dec_eff_manual dec_eff_mechanical exp_rate_village exp_rate_BP exp_rate_LS exp_oil_village exp_oil_BPLS conv_rate_BP conv_rate_LS conv_cost_BP conv_cost_LS	
}
*

*** MAKE A MEDIUM YIELD SCENARIO
{
gen amount_trees_ha = (237 + 333) / 2 // This is the mean of the low and high yield scenario
// Temporarily assume a fixed 0.55 seed/fruit ratio
replace fruit_yield_ha_5 = (fruit_yield_ha_5 + seed_yield_ha_5 / 0.55) / 2
replace fruit_yield_ha_6 = (fruit_yield_ha_6 + seed_yield_ha_6 / 0.55) / 2
replace fruit_yield_ha_7 = (fruit_yield_ha_7 + seed_yield_ha_7 / 0.55) / 2
replace fruit_yield_ha_8 = (fruit_yield_ha_8 + seed_yield_ha_8 / 0.55) / 2
replace fruit_yield_ha_9 = (fruit_yield_ha_9 + seed_yield_ha_9 / 0.55) / 2
replace fruit_yield_ha_10 = (fruit_yield_ha_10 + seed_yield_ha_10 / 0.55) / 2
replace fruit_yield_ha_15 = (fruit_yield_ha_15 + seed_yield_ha_15 / 0.55) / 2
replace fruit_yield_ha_20 = (fruit_yield_ha_20 + seed_yield_ha_20 / 0.55) / 2
replace fruit_yield_ha_25 = (fruit_yield_ha_25 + seed_yield_ha_25 / 0.55) / 2
replace fruit_yield_ha_30 = fruit_yield_ha_25
sum fruit_yield_ha_5 // 0.29 0.07
sum fruit_yield_ha_6 // 0.76 0.27
sum fruit_yield_ha_7 // 2.04 0.29
sum fruit_yield_ha_8 // 3.23 0.27
sum fruit_yield_ha_9 // 3.75 0.23
sum fruit_yield_ha_10 // 4.50 0.39
sum fruit_yield_ha_15 // 6.44 0.52
sum fruit_yield_ha_20 // 9.68 0.68
sum fruit_yield_ha_25 // 11.33 0.91
sum fruit_yield_ha_30 // 11.33 0.91
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
// Now calculate seed yields
drop seed_yield_ha*
local j = 5
quietly while `j' <= 30 { 
	gen seed_yield_ha_`j' = seed_fruit_ratio* fruit_yield_ha_`j'
	local j = `j' + 1
	}
// Now create variables for the first 4 years as well, which is better for the loops
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
erase filetemp1.dta
erase filetemp2.dta
}
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
	* There are electricity costs for farmers if mechanized deshelling at village level // Note: the two lines below are not in the do-files who don't assume mechanized deshelling at village level
	gen dec_costs_village_`j' = 0
	replace dec_costs_village_`j' = 24.5 * (1 / dec_rate) * 1000 * fruit_yield_ha_`j' if ID_proc != 4 & ID_proc != 5	
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
	replace total_cost_farmer_1_`j' = total_cost_farmer_1_`j' + dec_costs_village_`j' // Note: this line not in the do-files who don't assume mechanized deshelling at village level
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
	replace total_cost_farmer_2_`j' = total_cost_farmer_2_`j' + dec_costs_village_`j' // Note: this line not in the do-files who don't assume mechanized deshelling at village level
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
}
*









/***** PROFITABILITY VISUALIZATION *****/

*** NET PRESENT PROFITABILITY MEASURES - CALCULATE 10TH PERCENTILES
{
/* Note: the dimensions of the matrix and the code to fill it up, differ across the 8 optimization do-files */
mat ten_percentile = J(14,5,.) // Rows = 14 values. Columns = oil price ; farmer 1 ; processor chain 2 ; processor chain 4; processor chain 6
mat ten_percentile[1,1] == 42
mat ten_percentile[2,1] == 46
mat ten_percentile[3,1] == 50
mat ten_percentile[4,1] == 54
mat ten_percentile[5,1] == 58
mat ten_percentile[6,1] == 62
mat ten_percentile[7,1] == 66
mat ten_percentile[8,1] == 70
mat ten_percentile[9,1] == 74
mat ten_percentile[10,1] == 78
mat ten_percentile[11,1] == 82
mat ten_percentile[12,1] == 86
mat ten_percentile[13,1] == 90
mat ten_percentile[14,1] == 94

// Farmers
local j = 42
while `j' <= 94 {
	qui sum np_RetLand_H if ID_oil == `j' & ID_proc == 1, d
	qui mat ten_percentile[`j'/4+0.5-10,2] = r(p10)
	local j = `j' + 4
	}
mat list ten_percentile

// For processors
local j = 42 // Years
while `j' <= 94 {
	qui sum np_Profit if ID_oil == `j' & ID_proc == 2, d
	qui mat ten_percentile[`j'/4+0.5-10,3] = r(p10)
	qui sum np_Profit if ID_oil == `j' & ID_proc == 4, d
	qui mat ten_percentile[`j'/4+0.5-10,4] = r(p10)
	qui sum np_Profit if ID_oil == `j' & ID_proc == 6, d
	qui mat ten_percentile[`j'/4+0.5-10,5] = r(p10)
	local j = `j' + 4	
	}
mat list ten_percentile

putexcel set "C:\Users\...\Results_optimization.xlsx", sheet ("Opt_Oil_Mechanized") modify // Replace by working directory
putexcel B2=matrix(ten_percentile)
}
