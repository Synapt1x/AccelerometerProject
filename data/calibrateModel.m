function [accuracy,meanAcc] = calibrateModel(params)
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

% get current working directory and change to test folder
curdir = fileparts(which(mfilename));

% store all filenames into a cell array
file = {'Datastream3formatted-TwoSteps.txt', ...
      'Datastream4formatted-TwentyOneSteps.txt', ...
      'Datastream5formatted-FiftySteps.txt' ...
      'Datastream6formatted-NinetySixSteps.txt',...
      'Datastream7formatted-OneHundredTwentySteps.txt', ...
      'Datastream8formatted-ThirtyFourSteps.txt'};
% intialize the known amount of steps corresponding to each file
realnum = [2, 21, 50, 96, 120, 34];

% initialize variables
[numSteps, totSteps, accuracy] = deal(0);

for job=1:numel(file) % loop over each test file
     
      cd('testdata');
      % read in the data in the current file
      data = dlmread(file{job});
      
      cd(curdir);
      % count the number of steps in this dataset
      numSteps = countSteps(data, params);

      % accrue total steps counted for all files
      totSteps = totSteps + numSteps;
      
      % calculate the error for each job and the ensemble error
      residual = abs(realnum(job) - numSteps)/realnum(job);
      accuracy = [accuracy, residual];
end

% calculate overall accuracy of the algorithm setup
accuracy = [accuracy, abs(totSteps-sum(realnum))/sum(realnum)];
meanAcc = (1-mean(accuracy))*100;

disp(['The overall accuracy of this algorithm is: ', num2str(meanAcc), ' %']);

%change directory back to original directory
cd(curdir); 