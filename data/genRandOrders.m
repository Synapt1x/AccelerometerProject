function genRandOrders
%{
========================================
Created by: Chris Cadonic
For: BME 7022 (ECE 4610)
Class Project
========================================
Generates a .txt file that contains a randomized order using
MATLAB's pseudorandom number generator.

The seed is arbitrarily chosen to be seed = 81, and the
rng is chosen to be the Mersenne twister. These are chosen
so that when randperm is called, they will always provide the
same results and will only vary if the seed is varied.
%}

% set up for rng
choices = {'Foot','Thigh','Wrist','Bicep'};
seed = 81; % set the seed for rng
generator = rng(seed,'twister');

% initialize variables
randNums = [0 0 0 0];
order = {};

% properties for writing to the text file
fileID = fopen('sessionOrders.txt','w');
formatSpec = '%s %s %s %s\n';

for session=1:20 % generate a random order for each session
      randNums = randperm(4,4);
      order = choices([randNums]);
      
      %print the generated order to a text file
      fprintf(fileID,['session #', num2str(session), ': %s %s %s %s\n'], ...
            order{:});
end

