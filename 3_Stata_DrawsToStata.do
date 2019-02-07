/* This file is used to convert the .xlsx files containing the Monte Carlo samples to a Stata format

		Input files: 	Fruit.xlsx
						Seed.xlsx
						Other.xlsx
						Optimization.xlsx
		Output files: 	Draws_baseline.dta
						Draws_opt.dta
*/					

clear all
cd "C:\Users\..." // Replace by working directory
version 14
set more off
set min_memory 2g

*** CONVERT THE BASELINE DRAWS

// Import excel files and save as temporary Stata files
set excelxlsxlargefile on
import excel using "C:\Users\...\Fruit.xlsx", sheet ("Sheet1") firstrow
save filetemp1.dta
clear
import excel using "C:\Users\...\Seed.xlsx", sheet ("Sheet1") firstrow
save filetemp2.dta
clear
import excel using "C:\Users\...\Other.xlsx", sheet ("Sheet1") firstrow
save filetemp3.dta
clear

// Merge files and save
use filetemp1.dta
merge 1:1 _n using filetemp2.dta, assert(match) nogenerate
merge 1:1 _n using filetemp3.dta, assert(match) nogenerate
gen ID_draw = _n
quietly compress
save Draws_baseline.dta, replace
erase filetemp1.dta
erase filetemp2.dta
erase filetemp3.dta

*** CONVERT THE OPTIMIZATION DRAWS

clear
set excelxlsxlargefile on
import excel using "C:\Users\...\Optimization.xlsx", sheet ("Sheet1") firstrow
quietly compress
save Draws_opt.dta, replace
