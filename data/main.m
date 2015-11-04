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

% initialize properties of the algorithm
params = setup;

% initialize variables
data = [];
[numSteps,mpf] = deal(0);

%% Calibrate Model to Test Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,meanAcc] = calibrateModel(params);

%% Real data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test some experimental data
% data = dlmread('walkJogRun.txt');
%
% % count the steps in this dataset
% [numSteps,mpf] = countSteps(data,params);
%
% disp(['Number of steps counted: ', num2str(numSteps)]);
%
% % % calculate confidence interval for this calclation
% disp(['Thus the number of steps taken in this signal is ', ...
%       'between ', num2str(round(numSteps*(meanAcc/100))), ' and ', ...
%       num2str(round(numSteps*(100/meanAcc)))]);
% disp(['The Mean Power Frequency (MPF) for this signal is ', ...
%       num2str(mpf*params.Fs/22), ' Hz']);

%% Experimental Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load all files in experimental directory
allFiles = dir(pwd);
allFiles(1:2) = []; % remove . and .. directory commands

for file = 1:numel(allFiles) % iterate over each signal found in the folder
      data = dlmread(allFiles(file).name);
      
      % count the steps in this file
      [numSteps,mpf] = countSteps(data,params);
      
      disp(['Number of steps counted: ', num2str(numSteps)]);
      
      % calculate confidence interval fo this calculation
      disp(['Thus the number of steps taken in this signal is ', ...
            'between ', num2str(round(numSteps*(meanAcc/100))), ' and ', ...
            num2str(round(numSteps*(100/meanAcc)))]);
      disp(['The Mean Power Frequency (MPF) for this signal is ', ...
            num2str(mpf*params.Fs/22), ' Hz']);      
end