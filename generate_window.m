function [cols_range, rows_range, is_out_of_bound] = Generate_Window(x, y, win_rad, num_rows, num_cols)
    % Get window size
    left_bound = x - win_rad;   
    right_bound = x + win_rad;
    top_bound = y - win_rad;     
    bottom_bound = y + win_rad;  
    % x and y can be non-integers because U=X/2^level AND V=Y/2^level
    min_left = floor(left_bound);
    max_right = ceil(right_bound);
    min_top = floor(top_bound);
    max_bottom = ceil(bottom_bound);
    % Get the range of cols and rows in the window
    cols_range = min_left:max_right;
    rows_range = min_top:max_bottom;
    % Check if the window is outside the image
    if (min_left < 1 || min_top < 1 || max_right > num_cols || max_bottom > num_rows)
        is_out_of_bound = true;
    else
        is_out_of_bound = false;
    end
end