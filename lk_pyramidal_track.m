function [dx, dy] = lk_pyramidal_track(raw_img1, raw_img2, X, Y, win_rad, accuracy_threshold, max_iterations)
    max_levels = get_max_pyramid_level(raw_img1, 128);
    num_points = size(X,1);
    
    % Get images for each pyramid levels
    img1_pyramidized = generate_pyramid(raw_img1, max_levels);
    img2_pyramidized = generate_pyramid(raw_img2, max_levels);
   
    % begin with most downsampled level
    U = X/2^max_levels;
    V = Y/2^max_levels;

    for level = max_levels:-1:1
        % Get image for this level
        img1 = img1_pyramidized{level};
        img2 = img2_pyramidized{level};
        [num_rows, num_cols] = size(img1);

        % Calculate velocity matrix
        %{ 
        Using estimation method, which is not accurate enough
        img1x = zeros(size(img1,1),size(img1,2));
        img1y = zeros(size(img1,1),size(img1,2));
        img1y(1:size(img1,1)-1,:) = - img1(2:size(img1,1),:) + img1(1:size(img1,1)-1,:);
        img1y(size(img1,1),:) = 0;
        img1x(:,1:size(img1,2)-1) = - img1(:,2:size(img1,2)) + img1(:,1:size(img1,2)-1);
        img1x(:,size(img1,2)) = 0;
        %}
        % Calculate velocity of img1 using sobel kernel for higher accuracy
        vertical_velo_kernel = [1 2 1; 0 0 0; -1 -2 -1];
        I_x = imfilter(img1,vertical_velo_kernel','circular');
        I_y = imfilter(img1,vertical_velo_kernel,'circular');
        I_t = img1 - img2;
        % Square derivatives
        I_xx = I_x .* I_x;
        I_xy = I_x .* I_y;
        I_yy = I_y .* I_y;
        
        gauss_kern = gausswin(win_rad*2) * gausswin(win_rad*2).';
        
        W_xx = conv2(I_xx, gauss_kern, 'same');
        W_xy = conv2(I_xy, gauss_kern, 'same');
        W_yy = conv2(I_yy, gauss_kern, 'same');
        
        W_x = conv2(I_x, gauss_kern, 'same');
        W_y = conv2(I_y, gauss_kern, 'same');
        W_t = conv2(I_t, gauss_kern, 'same');
        
        for point = 1 : num_points
            level_x = round(U(point)*2);
            level_y = round(V(point)*2);
            if (level_x < 1 || level_x > num_rows || level_y < 1 || level_y > num_cols)
                continue;
            end
            G = [W_xx(level_x,level_y) W_xy(level_x, level_y); W_xy(level_x, level_y) W_yy(level_x, level_y)];
            b = [W_t(level_x, level_y).*W_x(level_x, level_y); W_t(level_x, level_y).*W_y(level_x, level_y)];
            velo = G\b;
            U(point) = level_x + velo(1);
            V(point) = level_y + velo(2);
        end
    end
    % Get only one velocity to maintain group structure
    dx = median(U-X);
    dy = median(V-Y);
end