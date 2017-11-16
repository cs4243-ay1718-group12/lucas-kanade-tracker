function [ PIP ] = corner_Harris(frame, num_pts)

    % Harris detector
    % The code calculates
    % the Harris Feature Points(FP)
    %
    % When u execute the code, the test image file opened
    % and u have to select by the mouse the region where u
    % want to find the Harris points,
    % then the code will print out and display the feature
    % points in the selected region.
    % You can select the number of FPs by changing the variables
    % max_N & min_N

    win_size = 12; % Abitrary, I have no idea what works :)
    I = double(frame);
    
    
    imshow(frame);
    k = waitforbuttonpress;
    point1 = get(gca,'CurrentPoint');  %button down detected
    rectregion = rbbox;  %%%return figure units
    point2 = get(gca,'CurrentPoint');%%%%button up detected
    point1 = point1(1,1:2); %%% extract col/row min and maxs
    point2 = point2(1,1:2);
    lowerleft = min(point1, point2);
    upperright = max(point1, point2);
    ymin = round(lowerleft(1)); %%% arrondissement aux nombrs les plus proches
    ymax = round(upperright(1));
    xmin = round(lowerleft(2));
    xmax = round(upperright(2));

    Aj = 6;
    cmin = xmin-Aj;
    cmax = xmax+Aj;
    rmin = ymin-Aj;
    rmax = ymax+Aj;
    min_N = 4;
    max_N = num_pts;
    
    threshold = 20;
    r = 6;
    
    kernel_x = [-1 0 1; -1 0 1; -1 0 1];
    gauss_kern = gausswin(win_size) * gausswin(win_size).';

    Ix = conv2(I(cmin:cmax,rmin:rmax), kernel_x, 'same');
    Iy = conv2(I(cmin:cmax,rmin:rmax), kernel_x', 'same');
    
    Ix2 = conv2(Ix.^2, gauss_kern, 'same');
    Iy2 = conv2(Iy.^2, gauss_kern, 'same');
    Ixy = conv2(Ix.*Iy, gauss_kern,'same');

    k = 0.04;
    R11 = (Ix2.*Iy2 - Ixy.^2) - k*(Ix2 + Iy2).^2;
    R11=(1000/max(max(R11)))*R11;
    R=R11;
    ma=max(max(R));
    sze = 2*r+1;
    MX = ordfilt2(R,sze^2,ones(sze));
    R11 = (R==MX)&(R>threshold);
    count=sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));


    i = 0;
    while ((count < min_N || count > max_N) && (i < 30))
        if count > max_N
            threshold = threshold*1.5;
        else
            threshold = threshold*0.5;
        end

        R11 = (R==MX) && (R>threshold);
        count = sum(sum(R11(5:size(R11,1)-5,5:size(R11,2)-5)));
        i = i+1;
    end


    R=R*0;
    R(5:size(R11,1)-5,5:size(R11,2)-5)=R11(5:size(R11,1)-5,5:size(R11,2)-5);
    [r1,c1] = find(R);
    PIP = [r1+cmin, c1+rmin]%% IP

    figure, hold on
    imshow(uint8(I)), hold on
    plot(PIP(:, 2), PIP(:, 1), '*')

end
