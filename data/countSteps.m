function [numSteps,mpf] = countSteps(data, params, varargin)
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

% store all data from the input data set
x_data = data(:,1);
y_data = data(:,2);
z_data = data(:,3);
delta_t_data = data(:,4); % data contains only time steps
t_data = [delta_t_data(1)]; % initialize time vector

numSteps = 0;

% loop over all the time steps to create time vector
for index=2:length(delta_t_data)
      t_data(index) = t_data(index-1)+delta_t_data(index);
end

% filter the signal using a low-pass filter
[b,a] = butter(5,params.cutoffFrequency,'low'); %create the butterworth filter
z_data_filt = filtfilt(b,a,z_data); %apply the filter to the signal

% analyze filtered signal for steps
threshold = params.thresholdProportion*max(z_data_filt);
for data_point=3:length(z_data_filt) % loop over each z data point
      if (z_data_filt(data_point) > threshold) && ...
                  (z_data_filt(data_point) > z_data_filt(data_point-1)) && ...
                  (z_data_filt(data_point) > z_data_filt(data_point+1))
            % if we find a max, count it as a step and iterate numSteps
            numSteps = numSteps + 1;
      end
end

if ~isempty(varargin) % if it is an experimental signal, plot it
      % plot the raw signal
      figure(1)
      plot(t_data,z_data);
      xlabel('Time (sec)'),ylabel('Acceleration (m/s^2)');
      title('Raw Acceleration Data From The Z-Axis');

      % plot filtered signal
      figure(2)
      plot(t_data,z_data_filt);
      xlabel('Time (sec)'),ylabel('Acceleration (m/s^2)');
      title('Plot of Low-Pass Filtered Acceleration Data From The Z-Axis');

      % plot PSD
      [psd_zz,F_zz] = periodogram(z_data_filt,[],100);

      figure(3)
      plot(F_zz,psd_zz);
      mpf = sum(F_zz.*psd_zz)/sum(psd_zz);
      hold on
      plot([mpf mpf],[0 max(psd_zz)],'r');
      hold off
      xlabel('Normalized Frequency'),ylabel('PSD (dB)');
      title('Power Spectrum Estimate For The Acceleration Data');
end