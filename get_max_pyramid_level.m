function [ max_levels ] = get_max_pyramid_level(raw_img, min_dimension)
% raw_img: input image unaltered
% min_dimension: smallest dimension of reduced image allowed to avoid loss
% of details
    smallest_dimension = min(size(raw_img));
    max_reduction = smallest_dimension/min_dimension;
    
    max_levels = floor(log2(max_reduction));
end

