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

% process the signal
[formattedData,t_data] = processData(params,data);

%% Separate the signal

% initialize matrix for storing all data segments
dataSegs = {};
indices = [];

% show a 
figure(1)
plot(t_data,formattedData);

% ask the user to define where each segment begins
strsegs = inputdlg('How many segments are there in this signal?');
numSegs = str2num(strsegs{1});
[tStarts,~] = ginput(numSegs);

% break the signal into 180 second segments starting at
% each t defined by user input
tEnds = tStarts+180;

% loop through each designated segments and extract the data
for segment = 1:numSegs
      % find the zero time point based on where the user clicked
      startTimeIndex = max(find(t_data < tStarts(segment)));
      startTime = t_data(startTimeIndex);
 
      % find all the indices for this segment
      indices = find(t_data > tStarts(segment) & t_data < tEnds(segment));
      
      % store the time data and formatted data based on indices
      dataSegs{segment,1} = t_data(indices) - startTime;
      dataSegs{segment,2} = formattedData(indices);
      
      % identify whether this segment is light or heavy
      segmentType = inputdlg(['What type of exercise is section number ', num2str(segment), ...
            '? Light or Heavy?']);
      if strcmpi('light',segmentType)
            dataSegs{segment,3} = 'light';
      else
            dataSegs{segment,3} = 'heavy';
      end
      
end