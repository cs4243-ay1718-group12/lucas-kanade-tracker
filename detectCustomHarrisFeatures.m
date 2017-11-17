function [ pts ] = detectCustomHarrisFeatures( imgframe, CORNER_NUM, xmin, ymin, xmax, ymax, CORNER_MIN_QUALITY )

%Harris corner detection will have 5 steps:

%1 - Gradient computation
%2 - Gaussian smoothing
%3 - Harris measure computation
%4 - Non-maximum suppression
%5 - Thresholding

    frame =double(imgframe); % store the first image frame into frame

    win_size = 64; % Abitrary, I have no idea what works :)
    alpha = 8;

    MIN_CORNER_NUM=4; 

    Thrshold=20; 
    block_size=3;  
    dx = [-1 0 1; -1 0 1; -1 0 1]; % The Mask 
    dy = dx';
    %%%%%% Step 1 - Compute x and y derivatives of an image. In this case, bounding box 
    Ix = conv2(frame(ymax:ymin,xmin:xmax), dx, 'same');   
    Iy = conv2(frame(ymax:ymin,xmin:xmax), dy, 'same');
    % Gaussian smoothing + double summation
    gauss = gaussian(win_size,alpha);
    gauss_kern = gauss  * gauss.';
     %%%%% Step 2 - Compute products of derivatives at every pixel
    Ix2 = conv2(Ix.^2, gauss_kern, 'same');  
    Iy2 = conv2(Iy.^2, gauss_kern, 'same');
    Ixy = conv2(Ix.*Iy, gauss_kern,'same');
    %%%%% Step 3 - Compute the response of the detector at each pixel It performs eigen value decomposition. If both
    %%%%% eigen value are large we say it is a corner. Response = Det(H) - k(Trace(H)).^2 -> formulae
    
    RESPONSE = (Ix2.*Iy2 - Ixy.^2) - CORNER_MIN_QUALITY*(Ix2 + Iy2).^2;
    
    %%%% Step 4 - non max suppression
    
    % Imagine the value of R for all the points in a patch that contains a corner: 
    %it is likely that more than one cell > threshold (why? moving the window by one pixel will not change the image much).
    %Thus for each candidate point > threshold, we want to detect if it is the absolute maximum within its window, if not then we discard it.
    max_in_each_row = max(RESPONSE); % maximum in each row of the response matrix
    max_overall = max(max_in_each_row); % maximum value overall 
    A = 1000/max_overall; 
    
    RESPONSE=(A)*RESPONSE;
    R=RESPONSE;
    
    %%ordfilt2 will move over the 2d array R in blocks of the same size as ones(sze).
    %%For each of these szexsze blocks, sort all the elements from smallest to
    %%largest. Now fill in the corresponding block in MX with a bunch
    %%of copies of the sze^2 smallest element.
    MX = ordfilt2(R,block_size^2,ones(block_size));
    RESPONSE = (R==MX)&(R>Thrshold); 
    row = size(RESPONSE,1);
    col = size(RESPONSE,2);
    features_count=sum(sum(RESPONSE(1:row,1:col)));
    
    %%%% Step 5 - Thresholding to get the number of feature above Mininum
    %%%% set feature count
    loop=0;
    while (((features_count<MIN_CORNER_NUM)||(features_count>CORNER_NUM))&&(loop<30))
        if features_count>CORNER_NUM
            Thrshold=Thrshold*1.5;
        elseif features_count < MIN_CORNER_NUM
            Thrshold=Thrshold*0.5;
        end        
        RESPONSE = (R==MX)&(R>Thrshold); 
        features_count=sum(sum(RESPONSE(1:size(RESPONSE,1),1:size(RESPONSE,2))));
        loop=loop+1;
    end
    
	final_Response=R*0; %empty R. Assign the selected features
    final_Response(1:size(RESPONSE,1),1:size(RESPONSE,2))=RESPONSE(1:size(RESPONSE,1),1:size(RESPONSE,2));
	[r,c] = find(final_Response);
    pts = [c+xmin,r+ymax];
    
 
end