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

% define test values for testing the algorithm
testvalues = [0.1, 0.2, 0.25, 0.33, 0.45, 0.5, 0.55, 0.67, 0.75, 0.8, 0.9, 1.0];
params.thresholdProportion = 0;
bestAcc = 0;

% Test the different values for threshold proportion and check for accuracy
% on test signals
for testval = 1:numel(testvalues)
      params.thresholdProportion = testvalues(testval);
      [~,meanAcc] = calibrateModel(params);
      if meanAcc > bestAcc
            bestAcc = meanAcc;
            bestIndex = testval;
      end
end

disp(['The overall accuracy of this algorithm is: ', num2str(bestAcc), ' %']);

% set thresholdProportion to the test value that produced the best acc
params.thresholdProportion = testvalues(bestIndex);

%% Experimental Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load all files in experimental directory
allFiles = dir('FullData/*.txt');

for file = 1:numel(allFiles) % iterate over each signal found in the folder
    
      cd('FullData');
      data = dlmread(allFiles(file).name);
      cd('..');
      
      % first separate the signal in the text file into
      % the separate segments for light and heavy ambulation
      dataSegs = waitfor(signalSplitter(params,data));
      
      % count the steps in this file
      [numSteps,mpf] = countSteps(data,params);
      
      disp(['The name of this file is :', allFiles(file).name, ...
            ' which was recorded on ', allFiles(file).date, '.']);
      disp(['Number of steps counted: ', num2str(numSteps)]);
      
      % calculate confidence interval fo this calculation
      disp(['Thus the number of steps taken in this signal is ', ...
            'between ', num2str(round(numSteps*(meanAcc/100))), ' and ', ...
            num2str(round(numSteps*(100/meanAcc)))]);
      disp(['The Mean Power Frequency (MPF) for this signal is ', ...
            num2str(mpf*params.Fs/22), ' Hz']);      
end