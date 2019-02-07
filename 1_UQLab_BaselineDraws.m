%% UQLab is used to draw the Monte Carlo samples for the stochastic input variables.
%% UQLab can be downloaded from https://www.uqlab.com/, and is operated in Matlab.
%% It should be noted that although we have used Stata for profitability modeling and uncertainty quantification, this can also be done with UQLab itself.

%% In this script, the samples for the baseline analysis (!= optimization scenarios) are drawn, and exported to excel files.

rng(99999999) % Set seed
uqlab; % Initialize UQLab

%% Draw Monte Carlo samples for the fruit yield parameters (Low yield scenario)
% Define distributions
Input.Marginals(1).Type = 'Gaussian';
Input.Marginals(1).Parameters = [0.12 0.08]; % Yield at 5 years in ton/ha => name in excel: fruit_yield_ha_5
Input.Marginals(1).Bounds = [0.04 0.20];
Input.Marginals(2).Type = 'Gaussian';
Input.Marginals(2).Parameters = [0.3 0.2]; % Yield at 6 years in ton/ha => name in excel: fruit_yield_ha_6
Input.Marginals(2).Bounds = [0.1 0.5];
Input.Marginals(3).Type = 'Gaussian';
Input.Marginals(3).Parameters = [0.45 0.25]; % Yield at 7 years in ton/ha => name in excel: fruit_yield_ha_7
Input.Marginals(3).Bounds = [0.20 0.70];
Input.Marginals(4).Type = 'Gaussian';
Input.Marginals(4).Parameters = [1 0.5]; % Yield at 8 years in ton/ha => name in excel: fruit_yield_ha_8
Input.Marginals(4).Bounds = [0.5 1.5];
Input.Marginals(5).Type = 'Gaussian';
Input.Marginals(5).Parameters = [1.75 0.75]; % Yield at 9 years in ton/ha => name in excel: fruit_yield_ha_9
Input.Marginals(5).Bounds = [1 2.5];
Input.Marginals(6).Type = 'Gaussian';
Input.Marginals(6).Parameters = [2.35 1.15]; % Yield at 10 years in ton/ha => name in excel: fruit_yield_ha_10
Input.Marginals(6).Bounds = [1.20 3.50];
Input.Marginals(7).Type = 'Gaussian';
Input.Marginals(7).Parameters = [3.5 1.5]; % Yield at 15 years in ton/ha => name in excel: fruit_yield_ha_15
Input.Marginals(7).Bounds = [2 5];
Input.Marginals(8).Type = 'Gaussian';
Input.Marginals(8).Parameters = [5 2]; % Yield at 20 years in ton/ha => name in excel: fruit_yield_ha_20
Input.Marginals(8).Bounds = [3 7];
Input.Marginals(9).Type = 'Gaussian';
Input.Marginals(9).Parameters = [6 3]; % Yield at 25 years in ton/ha => name in excel: fruit_yield_ha_25
Input.Marginals(9).Bounds = [3 9];
Input.Marginals(10).Type = 'Gaussian';
Input.Marginals(10).Parameters = [6 3]; % Yield at 30 years in ton/ha => name in excel: fruit_yield_ha_30
Input.Marginals(10).Bounds = [3 9];
% Define covariance structure
Input.Copula.Type = 'Gaussian';
Input.Copula.Parameters = [ 1 0 0 0 0 0 0 0 0 0 ; 0 1 0 0 0 0 0 0 0 0 ; 0 0 1 0 0 0 0 0 0 0 ; 0 0 0 1 0 0 0 0 0 0 ; 0 0 0 0 1 0 0 0 0 0 ; 0 0 0 0 0 1 0.5 0.2 0 0 ; 0 0 0 0 0 0.5 1 0.5 0.2 0 ; 0 0 0 0 0 0.2 0.5 1 0.5 0.2 ; 0 0 0 0 0 0 0.2 0.5 1 0.5 ; 0 0 0 0 0 0 0 0.2 0.5 1 ];
% Draw samples (50 000 samples per scenario)
InputFruitYield = uq_createInput(Input);
uq_print(InputFruitYield);
X = uq_getSample(50000);
% Save samples in excel file
filename = 'Fruit.xlsx';
xlswrite('Fruit.xlsx',X);
% Now put appropriate variable names to the columns in excel (see comments "name in excel" above)

%% Draw Monte Carlo samples for the seed yield parameters (High yield scenario)
% Define distributions
Input.Marginals(1).Type = 'Gaussian';
Input.Marginals(1).Parameters = [0.25 0.13]; % Yield at 5 years in ton/ha => name in excel: seed_yield_ha_5
Input.Marginals(1).Bounds = [0.12 0.38];
Input.Marginals(2).Type = 'Gaussian';
Input.Marginals(2).Parameters = [0.67 0.54]; % Yield at 6 years in ton/ha => name in excel: seed_yield_ha_6
Input.Marginals(2).Bounds = [0.13 1.21];
Input.Marginals(3).Type = 'Gaussian';
Input.Marginals(3).Parameters = [2 0.58]; % Yield at 7 years in ton/ha => name in excel: seed_yield_ha_7
Input.Marginals(3).Bounds = [1.42 2.58];
Input.Marginals(4).Type = 'Gaussian';
Input.Marginals(4).Parameters = [3 0.47]; % Yield at 8 years in ton/ha => name in excel: seed_yield_ha_8
Input.Marginals(4).Bounds = [2.53 3.47];
Input.Marginals(5).Type = 'Gaussian';
Input.Marginals(5).Parameters = [3.16 0.24]; % Yield at 9 years in ton/ha => name in excel: seed_yield_ha_9
Input.Marginals(5).Bounds = [2.92 3.40];
Input.Marginals(6).Type = 'Gaussian';
Input.Marginals(6).Parameters = [3.66 0.47]; % Yield at 10 years in ton/ha => name in excel: seed_yield_ha_10
Input.Marginals(6).Bounds = [3.19 4.13];
Input.Marginals(7).Type = 'Gaussian';
Input.Marginals(7).Parameters = [5.16 0.67]; % Yield at 15 years in ton/ha => name in excel: seed_yield_ha_15
Input.Marginals(7).Bounds = [4.49 5.83];
Input.Marginals(8).Type = 'Gaussian';
Input.Marginals(8).Parameters = [7.9 0.86]; % Yield at 20 years in ton/ha => name in excel: seed_yield_ha_20
Input.Marginals(8).Bounds = [7.04 8.76];
Input.Marginals(9).Type = 'Gaussian';
Input.Marginals(9).Parameters = [9.16 0.86]; % Yield at 25 years in ton/ha => name in excel: seed_yield_ha_25
Input.Marginals(9).Bounds = [8.3 10.02];
Input.Marginals(10).Type = 'Gaussian';
Input.Marginals(10).Parameters = [9.16 0.86]; % Yield at 30 years in ton/ha => name in excel: seed_yield_ha_30
Input.Marginals(10).Bounds = [8.3 10.02];
% Define covariance structure
Input.Copula.Type = 'Gaussian';
Input.Copula.Parameters = [ 1 0 0 0 0 0 0 0 0 0 ; 0 1 0 0 0 0 0 0 0 0 ; 0 0 1 0 0 0 0 0 0 0 ; 0 0 0 1 0 0 0 0 0 0 ; 0 0 0 0 1 0 0 0 0 0 ; 0 0 0 0 0 1 0.5 0.2 0 0 ; 0 0 0 0 0 0.5 1 0.5 0.2 0 ; 0 0 0 0 0 0.2 0.5 1 0.5 0.2 ; 0 0 0 0 0 0 0.2 0.5 1 0.5 ; 0 0 0 0 0 0 0 0.2 0.5 1 ];
% Draw samples (50 000 samples per scenario)
InputSeedYield = uq_createInput(Input);
uq_print(InputSeedYield);
X = uq_getSample(50000);
% Save samples in excel file
filename = 'Seed.xlsx';
xlswrite('Seed.xlsx',X);
% Now put appropriate variable names to the columns in excel (see comments "name in excel" above)

%% Draw Monte Carlo samples for the other stochastic input parameters
% Define distributions
Input.Marginals(1).Type = 'Gaussian';
Input.Marginals(1).Parameters = [0.55 0.14]; % Seed fruit ratio => name in excel: seed_fruit_ratio
Input.Marginals(1).Bounds = [0.34 0.76];
Input.Marginals(2).Type = 'Gaussian';
Input.Marginals(2).Parameters = [7.01 3.55]; % Harvest rate tarpel - Final - Low yield scenario => name in excel: harvest_rate_tarpel
Input.Marginals(2).Bounds = [3.46 10.56];
Input.Marginals(3).Type = 'Gaussian';
Input.Marginals(3).Parameters = [3.6 0.75]; % Decortication rate - Manual - Final => name in excel: dec_rate_manual
Input.Marginals(3).Bounds = [2.85 4.35];
Input.Marginals(4).Type = 'Gaussian';
Input.Marginals(4).Parameters = [50 16.67]; % Decortication rate - Mechanical => name in excel: dec_rate_mechanical
Input.Marginals(4).Bounds = [33.33 66.67];
Input.Marginals(5).Type = 'Gaussian';
Input.Marginals(5).Parameters = [0.05 0.0167]; % Decortication efficiency - Manual => name in excel: dec_eff_manual
Input.Marginals(5).Bounds = [0.0333 0.0667];
Input.Marginals(6).Type = 'Gaussian';
Input.Marginals(6).Parameters = [0.2 0.0667]; % Decortication efficiency - Mechanical => name in excel: dec_eff_mechanical
Input.Marginals(6).Bounds = [0.1333 0.2667];
Input.Marginals(7).Type = 'Gaussian';
Input.Marginals(7).Parameters = [12 4]; % Expeller rate - Village => name in excel: exp_rate_village
Input.Marginals(7).Bounds = [8 16];
Input.Marginals(8).Type = 'Gaussian';
Input.Marginals(8).Parameters = [30 10]; % Expeller rate - BP => name in excel: exp_rate_BP
Input.Marginals(8).Bounds = [20 40];
Input.Marginals(9).Type = 'Gaussian';
Input.Marginals(9).Parameters = [400 50]; % Expeller rate - LS => name in excel: exp_rate_LS
Input.Marginals(9).Bounds = [350 450];
Input.Marginals(10).Type = 'Gaussian';
Input.Marginals(10).Parameters = [0.66 0.0825]; % Expeller efficiency - Village => name in excel: exp_oil_village
Input.Marginals(10).Bounds = [0.5775 0.7425];
Input.Marginals(11).Type = 'Gaussian';
Input.Marginals(11).Parameters = [0.71 0.0888]; % Expeller efficiency - BPLS => name in excel: exp_oil_BPLS
Input.Marginals(11).Bounds = [0.6212 0.7988];
Input.Marginals(12).Type = 'Gaussian';
Input.Marginals(12).Parameters = [12.5 4.17]; % Conversion rate - BP => name in excel: conv_rate_BP
Input.Marginals(12).Bounds = [8.33 16.67];
Input.Marginals(13).Type = 'Gaussian';
Input.Marginals(13).Parameters = [750 250]; % Conversion rate - LS => name in excel: conv_rate_LS
Input.Marginals(13).Bounds = [500 1000];
Input.Marginals(14).Type = 'Gaussian';
Input.Marginals(14).Parameters = [20 2.5]; % Conversion cost - BP => name in excel: conv_cost_BP
Input.Marginals(14).Bounds = [17.5 22.5];
Input.Marginals(15).Type = 'Gaussian';
Input.Marginals(15).Parameters = [10.5 1.31]; % Conversion cost - LS => name in excel: conv_cost_LS
Input.Marginals(15).Bounds = [9.19 11.81];
Input.Marginals(16).Type = 'Gaussian';
Input.Marginals(16).Parameters = [0.3469 0.0285]; % Oil content => name in excel: oil_content
Input.Marginals(17).Type = 'Gaussian';
Input.Marginals(17).Parameters = [7 2]; % Fruits price => name in excel: fruits_price
Input.Marginals(17).Bounds = [5 9];
Input.Marginals(18).Type = 'Gaussian';
Input.Marginals(18).Parameters = [21.3 6.59]; % Seeds price => name in excel: seeds_price
Input.Marginals(18).Bounds = [11.42 31.19];
Input.Marginals(19).Type = 'Gaussian';
Input.Marginals(19).Parameters = [70 10]; % Oil price => name in excel: oil_price
Input.Marginals(19).Bounds = [60 80];
Input.Marginals(20).Type = 'Gaussian';
Input.Marginals(20).Parameters = [21 5]; % Cake price => name in excel: cake_price
Input.Marginals(20).Bounds = [16 26];
Input.Marginals(21).Type = 'Gaussian';
Input.Marginals(21).Parameters = [53 10]; % Biodiesel price => name in excel: biodiesel_price
Input.Marginals(21).Bounds = [43 63];
Input.Marginals(22).Type = 'Gaussian';
Input.Marginals(22).Parameters = [271.8 45.7]; % Labour wage men => name in excel: labour_wage_men
Input.Marginals(22).Bounds = [203.25 340.35];
Input.Marginals(23).Type = 'Gaussian';
Input.Marginals(23).Parameters = [185.1 36.4]; % Labour wage women => name in excel: labour_wage_women
Input.Marginals(23).Bounds = [130.5 239.7];
Input.Marginals(24).Type = 'Gaussian';
Input.Marginals(24).Parameters = [1.5 0.2]; % Harvest rate tarpel - High yield multiplication factor => name in excel: harvest_rate_multiplication
Input.Marginals(24).Bounds = [1.3 1.7];
% Define covariance structure
Input.Copula.Type = 'Independent';
% Draw samples (50 000 samples per scenario)
OtherParameters = uq_createInput(Input);
uq_print(OtherParameters);
X = uq_getSample(50000);
% Save samples in excel file
filename = 'Other.xlsx';
xlswrite('Other.xlsx',X);
% Now put appropriate variable names to the columns in excel (see comments "name in excel" above)