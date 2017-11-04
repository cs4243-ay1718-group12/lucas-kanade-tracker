function [x_new, y_new] = LK_Track_Pyramid(img1, img2, x, y, max_level, win_size)
    % Construct pyramid using gaussian reduction. Level 1 is original
    pyramid_img1 = img1;
    pyramid_img2 = img2;
    for level = 2:max_level
        img1 = impyramid(img1, 'reduce');
        img2 = impyramid(img2, 'reduce');
        pyramid_img1(1:size(img1,1), 1:size(img1,2), level) = img1;
        pyramid_img2(1:size(img2,1), 1:size(img2,2), level) = img2;
    end
    d = [0;0];
    for level = 1:max_level
        % Get current level images
        level_num_rows_1 = size(pyramid_img1,1)/(2^(max_level - level));
        level_num_cols_1 = size(pyramid_img1,2)/(2^(max_level - level));
        level_num_rows_2 = size(pyramid_img2,1)/(2^(max_level - level));
        level_num_cols_2 = size(pyramid_img2,2)/(2^(max_level - level));
        level_img1 = pyramid_img1(1:level_num_rows_1, 1:level_num_cols_1, max_level - level + 1);
        level_img2 = pyramid_img2(1:level_num_rows_2, 1:level_num_cols_2, max_level - level + 1);
        % Init guess velocity
        % Location of original (x,y) on this level
        level_x = x/2^(max_level-level);
        level_y = y/2^(max_level-level);
        [dx, dy] = LK_Track_Point(level_img1, level_img2, level_x, level_y, win_size);
        d = 2*(d+[dx;dy]);
    end
    x_new = x + d(1);
    y_new = y + d(2);
end
