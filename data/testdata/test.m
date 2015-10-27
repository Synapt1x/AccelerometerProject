%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
MATLAB code for analyzing acceleration data
measured by my android device. This is currently
just using test data and will be primarily used for 
testing various algorithms for determining number
of steps based on the filtered (low-pass) signal.

This code will likely be re-formatted once the project
is more sophisticated.
%}
clc, clear

Fs = 100; % sampled at 100 Hz

numSteps = 0;
totSteps = 0;
accuracy = [];
cutoffFrequency = 5/Fs;
thresholdProportion = 1/5;

%% Test Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
file = {'Datastream3formatted-TwoSteps.txt', ...
      'Datastream4formatted-TwentyOneSteps.txt', ...
      'Datastream5formatted-FiftySteps.txt' ...
      'Datastream6formatted-NinetySixSteps.txt',...
      'Datastream7formatted-OneHundredTwentySteps.txt', ...
      'Datastream8formatted-ThirtyFourSteps.txt'};
realNumSteps = {'two','twenty one','fifty','ninety six', ...
      'one hundred and twenty', 'thirty four'};
realnum = [2, 21, 50, 96, 120, 34];

for job=1:numel(file)
      
      numSteps = 0;

      data = dlmread(file{job});
      
      x_data = data(:,1);
      y_data = data(:,2);
      z_data = data(:,3);
      delta_t_data = data(:,4);
      t_data = [delta_t_data(1)];

      for index=2:length(delta_t_data)
            t_data(index) = t_data(index-1)+delta_t_data(index);
      end
      
      % filter the signal using a low-pass filter
      [b,a] = butter(5,cutoffFrequency,'low'); %create the butterworth filter
      z_data_filt = filtfilt(b,a,z_data); %apply the filter to the signal
      
      % analyze filtered signal for steps
      threshold = thresholdProportion*max(z_data_filt);
      for data_point=3:length(z_data_filt)
            if (z_data_filt(data_point) > threshold) && ...
                        (z_data_filt(data_point) > z_data_filt(data_point-1)) && ...
                        (z_data_filt(data_point) > z_data_filt(data_point+1))
                  numSteps = numSteps + 1;
            end
      end

      totSteps = totSteps + numSteps;
      
      disp(['For a signal recording of ', realNumSteps{job}, ' steps the algorthm produces:']);
      disp(['Number of steps counted: ', num2str(numSteps)]);
      
      residual = abs(realnum(job) - numSteps)/realnum(job);
      
      accuracy = [accuracy, residual];
end

accuracy = [accuracy, abs(totSteps-sum(realnum))/sum(realnum)];
meanAcc = (1-mean(accuracy))*100;

disp(['The overall accuracy of this algorithm is: ', num2str(meanAcc), ' %']);

%% Real data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numSteps = 0;

data = dlmread('Datastream9formatted.txt');
disp('Now reading in real data...');

x_data = data(:,1);
y_data = data(:,2);
z_data = data(:,3);
delta_t_data = data(:,4);
t_data = [delta_t_data(1)];

for index=2:length(delta_t_data)
      t_data(index) = t_data(index-1)+delta_t_data(index);
end

t_data = t_data'./1000;

% plot the signal
figure(1)
plot(t_data,z_data);
xlabel('Time (sec)'),ylabel('Acceleration (m/s^2)');
title('Raw Acceleration Data From The Z-Axis');

% filter the signal using a low-pass filter
[b,a] = butter(5,cutoffFrequency,'low'); %create the butterworth filter
z_data_filt = filtfilt(b,a,z_data); %apply the filter to the signal

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

% analyze filtered signal for steps
threshold = thresholdProportion*max(z_data_filt);
for data_point=3:length(z_data_filt)
      if (z_data_filt(data_point) > threshold) && ...
                  (z_data_filt(data_point) > z_data_filt(data_point-1)) && ...
                  (z_data_filt(data_point) > z_data_filt(data_point+1))
            numSteps = numSteps + 1;
      end
end

disp(['Number of steps counted: ', num2str(numSteps)]);

% calculate confidence interval for this calclation
disp(['Thus the number of steps taken in this signal is ', ...
      'between ', num2str(round(numSteps*(meanAcc/100))), ' and ', ...
      num2str(round(numSteps*(100/meanAcc)))]);
disp(['The Mean Power Frequency (MPF) for this signal is ', ...
      num2str(mpf*Fs/22), ' Hz']); 