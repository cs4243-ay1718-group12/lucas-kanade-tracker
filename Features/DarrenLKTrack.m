function [dx, dy] = DarrenLKTrack(im1, im2, x, y, w)
    Ix_m = conv2(im1,[-1 1; -1 1], 'valid'); % partial on x
    Iy_m = conv2(im1, [-1 -1; 1 1], 'valid'); % partial on y
    It_m = conv2(im1, ones(2), 'valid') + conv2(im2, -ones(2), 'valid'); % partial on t
        
    %d = zeros(size(x, 1), 2);
    
    dx = zeros(size(x));
    dy = zeros(size(y));
    % perform tracking for each feature coordinate (i,j)
    for k = 1:size(x, 1)
        i = x(k);
        j = y(k);
        
        i_w = i-w;
        j_w = j-w;
        if i-w < 0
            i_w = 0;
        end
        
        if j-w < 0
            j_w = 0;
        end
        Ix = Ix_m(i_w:i+w, j_w:j+w);
        Iy = Iy_m(i_w:i+w, j_w:j+w);
        It = It_m(i_w:i+w, j_w:j+w);

        Ix = Ix(:);
        Iy = Iy(:);
        b = -It(:); % get b here

        A = [Ix Iy]; % get A here
        nu = pinv(A)*b;

        %d(k, 1) = nu(1);
        %d(k, 2) = nu(2);
        
        dx(k) = nu(1);
        dy(k) = nu(2);
    end
end