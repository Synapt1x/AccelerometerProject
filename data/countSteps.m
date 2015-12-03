function [numSteps,mpf] = countSteps(data, params, varargin)
%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
This function carries out the actual algorithm for counting
the number of steps in a given signal.

The input signal is passed in to 'countSteps' as the first
input, 'data'. The params structure is naturally passed
to the second input, and varargin allows for countSteps
to be called with intent signalled to the program.

If varargin is non-empty, then the signal passsed into
the program as 'data' is test data. If varargin is empty,
then the signal is experimental.
IN:
      --data:
      The input data signal containing raw accelerometer data
      --params:
      Structure containing the parameters of the algorithm
      --varargin:
      empty if experimental signal
OUT:
      --numSteps:
      The number of steps calculated by the algorithm given
      the parameters found in 'params'
      --mpf:
      The calculated mean power frequency for the provided
      input data signal
%}

[formattedData,t_data] = processData(params,data);

numSteps = 0;

% analyze filtered signal for steps
threshold = params.thresholdProportion*max(formattedData);
for data_point=3:length(formattedData)-1 % loop over each z data point
      if (formattedData(data_point) > threshold) && ...
                  (formattedData(data_point) > formattedData(data_point-1)) && ...
                  (formattedData(data_point) > formattedData(data_point+1))
            % if we find a max, count it as a step and iterate numSteps
            numSteps = numSteps + 1;
      end
end

if isempty(varargin) % if it is an experimental signal, plot it
      % plot the raw signal
      figure(1)
      plot(t_data,formattedData);
      xlabel('Time (sec)'),ylabel('Acceleration (m/s^2)');
      title('Raw Acceleration Data From The Z-Axis');

      % plot filtered signal
      figure(2)
      plot(t_data,formattedData);
      xlabel('Time (sec)'),ylabel('Acceleration (m/s^2)');
      title('Plot of Low-Pass Filtered Acceleration Data From The Z-Axis');

      % plot PSD
      [psd_zz,F_zz] = periodogram(formattedData,[],100);

      figure(3)
      plot(F_zz,psd_zz);
      mpf = sum(F_zz.*psd_zz)/sum(psd_zz);
      hold on
      plot([mpf mpf],[0 max(psd_zz)],'r');
      hold off
      xlabel('Normalized Frequency'),ylabel('PSD (dB)');
      title('Power Spectrum Estimate For The Acceleration Data');
end