function params = setup
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

%% Signal Properties
params.Fs = 100; % sampled at 100 Hz
params.cutoffFrequency = 5/params.Fs;
params.thresholdProportion = 1/5;