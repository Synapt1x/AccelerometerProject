function params = setup
%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
This function contains the setup function to control
various characteristics for my BME 7022 project.

Setup is called with the structure 'params' as output, 
which henceforth carries all parameters of the project
as parameters in the structure 'params'.
OUT:
      --params:
      Output structure containing the parameters
      for use in the number of steps calculating algorithm
%}

%% Signal Properties
params.Fs = 100; % sampled at 100 Hz
params.cutoffFrequency = 5/params.Fs;