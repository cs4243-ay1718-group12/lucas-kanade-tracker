function [velo_x, velo_y] = LK_Track_Pyramid(img1, img2, X, Y, max_level, win_size)
    % Construct pyramid using gaussian reduction. Level 1 is original
    pyramid_img1 = img1;
    pyramid_img2 = img2;
    for level = 2:max_level
        img1 = impyramid(img1, 'reduce');
        img2 = impyramid(img2, 'reduce');
        pyramid_img1(1:size(img1,1), 1:size(img1,2), level) = img1;
        pyramid_img2(1:size(img2,1), 1:size(img2,2), level) = img2;
    end
  
    guess = [0;0];
    x = X(1);
    y = Y(1);
    for level = 1:max_level
        % Get current level images
        level_num_rows_1 = round(size(pyramid_img1,1)/(2^(max_level - level)));
        level_num_cols_1 = round(size(pyramid_img1,2)/(2^(max_level - level)));
        level_num_rows_2 = round(size(pyramid_img2,1)/(2^(max_level - level)));
        level_num_cols_2 = round(size(pyramid_img2,2)/(2^(max_level - level)));
        level_img1 = pyramid_img1(1:level_num_rows_1, 1:level_num_cols_1, max_level-level+1);
        level_img2 = pyramid_img2(1:level_num_rows_2, 1:level_num_cols_2, max_level-level+1);
        % Location of original (x,y) on this level
        level_x = round(x/(2^(max_level-level)));
        level_y = round(y/(2^(max_level-level)));
        if (level_x > 0 && level_y > 0)
            %disp('X:');disp(x);
            %disp('LEVEL_X:');disp(level_x);
            %disp('Y:');disp(y);
            %disp('LEVEL_Y:');disp(level_y);
            [dx, dy] = LK_Track_Point(level_img1, level_img2, level_x, level_y, win_size, guess);
            d = [dx;dy];
            disp(d);
            guess = 2*(guess+d);
        else
            break;
        end
    end

    velo_x = guess(1);
    velo_y = guess(2);
end