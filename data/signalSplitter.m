function dataSegs = signalSplitter(params,data)
%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
MATLAB code for splitting a signal text file into separate
signals for analysis.
%}

%% Read the data in the base file

[formattedData,t_data] = processData(params,data);


%% Separate the signal

figure(1)
plot(t_data,formattedData);

dataSegs = formattedData;