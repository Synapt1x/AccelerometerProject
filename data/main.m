function main
%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
MATLAB code for analyzing acceleration data
measured by my android device.
This is the main function that calls the helper functions
for processing the signals, including calibration with
test data and also running through real data.
%}

params = setup;

%% Calibrate Model to Test Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
[accuracy,meanAcc] = calibrateModel(params);

%% Real data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test some experimental data
data = dlmread('exampleData.txt');

% count the steps in this dataset
[numSteps,mpf] = countSteps(data,params);

disp(['Number of steps counted: ', num2str(numSteps)]);

% calculate confidence interval for this calclation
disp(['Thus the number of steps taken in this signal is ', ...
      'between ', num2str(round(numSteps*(meanAcc/100))), ' and ', ...
      num2str(round(numSteps*(100/meanAcc)))]);
disp(['The Mean Power Frequency (MPF) for this signal is ', ...
      num2str(mpf*params.Fs/22), ' Hz']); 