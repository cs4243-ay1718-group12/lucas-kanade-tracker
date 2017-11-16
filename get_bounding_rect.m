function [rectangle] = get_bounding_rect(X, Y)
    tolerance = 5; % pixels
    ul_x = min(X);
    ul_y = min(Y); % axes are reversed weirdly???
    w = abs(max(X) - min(X));
    h = abs(max(Y) - min(Y));
    rectangle = [ul_x, ul_y, w, h] + tolerance;
end