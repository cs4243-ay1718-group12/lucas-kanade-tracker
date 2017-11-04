% Return the best-guess velocity of point (x,y) on img1 to img2
% To be used in a pyramid implementation
function [u v] = LT_Track(img1, img2, win_size, x, y)
    % Constants
    d = [0 0];
    max_steps = 20;
    num_cols = size(img1,2);
    num_rows = size(img1,1);
    accuracy_threshold = 0.05; % purely abbitrary now
    % Intensity derivative matrices
    Iy = double(uint8(zeros(num_rows, num_cols)));
    Ix = double(uint8(zeros(num_rows, num_cols)));
    for row = 1 : num_rows-1
      Ix(row,:) = img1(row+1,:)-img1(row,:);
    end
    Ix(num_rows,:) = 0;
    for col = 1 : num_cols-1
      Iy(:,col) = img1(:,col+1)-img1(:,col);
    end
    Iy(:,num_cols) = 0;
    % square derivatives
    I_xx = Ix.^2;
    I_yy = Iy.^2;
    I_xy = Ix.*Iy;
    % Gaussian smoothing + double summation
    gauss_kern = gausswin(win_size) * gausswin(win_size).';
    W_xx = conv2(gauss_kern, I_xx);
    W_yy = conv2(gauss_kern, I_yy);
    W_xy = conv2(gauss_kern, I_xy);
    Z = [W_xx(x,y) W_xy(x,y); W_xy(x,y) W_yy(x,y)];
    % Iterative improvement of estimation
    % Either run for max_steps times or until error residual smaller than
    % accuracy_threshold
    d_current = [0 0];
    for step = 1 : max_steps
        I_t = img1(x,y) - img2(x+d_current(1)+d(1), y+d_current(2)+d(2));
        b = [I_t*Ix(x,y);I_t*Iy(x,y)];
        guess = Z'*b;
        d_current = d_currebt + guess;
        if (abs(guess) < accuracy_threshold)
            break;
        end
    end
    d = d_current;
    u = d(1);
    v = d(2);
end