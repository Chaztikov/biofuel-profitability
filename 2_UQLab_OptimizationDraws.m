%% In this script, additional samples for the optimization scenarios are drawn, and exported to an excel file.

rng(99999999) % Set seed
uqlab; % Initialize UQLab

% Define distributions
Input.Marginals(1).Type = 'Gaussian';
Input.Marginals(1).Parameters = [1.33 0.2]; % Harvest rate - Medium yield multiplication factor => name in excel: harvest_rate_multiplication
Input.Marginals(1).Bounds = [1.13 1.53];
Input.Marginals(2).Type = 'Gaussian';
Input.Marginals(2).Parameters = [25 3]; % Harvest rate - Mechanical village => name in excel: dec_rate_vil_mechanical
Input.Marginals(2).Bounds = [22 28];
% Define covariance structure
Input.Copula.Type = 'Independent';
% Draw samples (50 000 samples per scenario)
Optimization = uq_createInput(Input);
uq_print(Optimization);
X = uq_getSample(50000);
% Save samples in excel file
filename = 'Optimization.xlsx';
xlswrite('Optimization.xlsx',X);
% Now put appropriate variable names to the columns in excel (see comments "name in excel" above)