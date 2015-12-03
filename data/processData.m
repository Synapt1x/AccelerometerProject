function [formattedData,t_data] = processData(params,data)
%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
MATLAB code for analyzing accelerattion data and processing
to prepare the signal to be analyzed for counting the number
of steps.

This is used in the class project to process the data prior to
counting steps or splitting the data.
%}

% store all data from the input data set
x_data = data(:,1); % x accel
y_data = data(:,2); % y accel
z_data = data(:,3); % z accel
delta_t_data = data(:,4); % data contains only time steps
t_data = [delta_t_data(1)/1000]; % initialize time vector in seconds

% find euclidean magnitude of vector formed by x, y, z
LinData = sqrt(x_data.^2 + y_data.^2 + z_data.^2);

% loop over all the time steps to create time vector
for index=2:length(delta_t_data)
      t_data(index) = t_data(index-1)+delta_t_data(index);
end

% filter the signal using a low-pass filter
[b,a] = butter(5,params.cutoffFrequency,'low'); %create the butterworth filter
formattedData = filtfilt(b,a,LinData); %apply the filter to the signal