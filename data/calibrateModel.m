function [accuracy,meanAcc] = calibrateModel(params)
%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
This function calibrates the model given the parameters
in 'params'. This will be reading in test data and then 
determining the number of steps each test signal is
calculated to represent and contrasted to the 
corresponding known value to calculate accuracy. The
accuracy of the current setup is output during calibration.
IN: 
      --params:
      Structure containing the parameters of the algorithm
OUT:
      --accuracy:
      Vector containing the accuracy values for counting
      the number of steps with each test signal.
      --meanAcc:
      An output float that represents the average accuracy
      of the algorithm given the parameters in 'params'
%}

% get current working directory and change to test folder
curDir = fileparts(which(mfilename));

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
      
      cd(curDir);
      % count the number of steps in this dataset
      numSteps = countSteps(data, params, 'calibrate');

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
cd(curDir); 