function [query_points_X, query_points_Y] = get_query_points(x, y, win_rad)
% Get coordinates of query points within the window
    left_bound = x - win_rad;   
    right_bound = x + win_rad;
    top_bound = y - win_rad;     
    bottom_bound = y + win_rad;
    win_size = 2 * win_rad + 1;
    X = zeros(win_size);
    Y = zeros(win_size);
    X = repmat(left_bound:right_bound, win_size,1);
    Y = repmat((top_bound:bottom_bound)',1,win_size);
    
    query_points_X = X;
    query_points_Y = Y;
end

