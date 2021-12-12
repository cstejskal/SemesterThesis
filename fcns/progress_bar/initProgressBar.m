function [start_time, percent_complete] = initProgressBar(message)

fprintf('%s...   0%%\n',message)
fprintf('est. time remaining: .... sec\n')

percent_complete = 0;
start_time = tic;


end