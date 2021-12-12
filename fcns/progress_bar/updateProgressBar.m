function percent_complete = updateProgressBar(start_time, ...
    progress_percent_step, ...
    percent_complete, ...
    current_iter, ...
    max_iter)


next_percent_step = percent_complete + progress_percent_step;
timer = toc(start_time);

if current_iter == max_iter
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    fprintf('\b\b\b\b\b\b100%%\n')
    percent_complete = 1;
    
elseif (current_iter / max_iter) > next_percent_step
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    fprintf('\b\b\b\b\b\b%3.0f%%\n',floor((current_iter / max_iter)*100))
    fprintf('est. time remaining: %4.0f sec\n', ...
        (timer/(current_iter / max_iter))*(1 - (current_iter / max_iter)))
    
    percent_complete = next_percent_step;
end


end