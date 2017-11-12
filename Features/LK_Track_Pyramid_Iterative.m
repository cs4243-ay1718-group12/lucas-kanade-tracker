function [U, V] = LK_Track_Pyramid_Iterative(raw_img1, raw_img2, X, Y)

    % Constants
    win_rad = 5;
    accuracy_threshold = .01;
    max_iterations = 20;
    max_levels = Maximum_Pyramid_Level(raw_img1, 128);
    num_points = size(X,1);
    % Get images for each pyramid levels
    img1_pyramidized = generate_pyramid(raw_img1, max_levels);
    img2_pyramidized = generate_pyramid(raw_img2, max_levels);
   
    U = X/2^max_levels;
    V = Y/2^max_levels;

    for level = max_levels:-1:1
        % Get image for this level
        img1 = img1_pyramidized{level};
        img2 = img2_pyramidized{level};
        [num_rows, num_cols] = size(img1);

        h = fspecial('sobel');
        img1x = imfilter(img1,h','replicate');
        img1y = imfilter(img1,h,'replicate');
        
        for point = 1 : num_points
            xt = U(point)*2;
            yt = V(point)*2;
            [iX, iY, oX, oY, is_out_of_bound] = generate_window(xt, yt, win_rad, num_rows, num_cols);
            if is_out_of_bound 
                continue; 
            end 
            Ix = interp2(iX,iY,img1x(iY,iX),oX,oY);
            Iy = interp2(iX,iY,img1y(iY,iX),oX,oY);
            I1 = interp2(iX,iY,img1(iY,iX),oX,oY);

            for i = 1 : max_iterations
                [iX, iY, oX, oY, is_out_of_bound] = generate_window(xt, yt, win_rad, num_rows, num_cols);
                if is_out_of_bound, break; end
                It = interp2(iX,iY,img2(iY,iX),oX,oY) - I1;
                
                vel = [Ix(:),Iy(:)]\It(:);
                xt = xt+vel(1);
                yt = yt+vel(2);
                if max(abs(vel)) < accuracy_threshold
                    break; 
                end
            end
            U(point) = xt;
            V(point) = yt;
        end

    end

end

function [cols_range, rows_range, oX, oY, is_out_of_bound] = generate_window(x, y, win_rad, num_rows, num_cols)
    % Get window size
    left_bound = x - win_rad;   
    right_bound = x + win_rad;
    top_bound = y - win_rad;     
    bottom_bound = y + win_rad;  
    % x and y can be non-integers because U=X/2^level AND V=Y/2^level
    fl = floor(left_bound);
    cr = ceil(right_bound);
    ft = floor(top_bound);
    cb = ceil(bottom_bound);
    
    % Get the range of cols and rows in the window
    cols_range = fl:cr;
    rows_range = ft:cb;

    % Get ... considering using our own method for meshgrid
    [oX,oY] = meshgrid(left_bound:right_bound,top_bound:bottom_bound);
    
    % Check if the window is outside the image
    if (fl < 1 || ft < 1 || cr > num_cols || cb > num_rows)
        is_out_of_bound = true;
    else
        is_out_of_bound = false;
    end
end