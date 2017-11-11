clear
close all
%main file (starting file) to showcase the extraction of harris features
%based on bounding box

%%% video
obj = VideoReader('ball_tracker2.mov'); % Change the file name here to load your own video file. 
%Please put the video file in the working directory or add full path.

vid = obj.read;
[M N C imgNum] = size(vid);
imgseq = zeros(M,N,imgNum); 
for p = 1:imgNum
	img1 = im2double(vid(:,:,:,p));
	if C == 3, img1 = rgb2gray(img1); end
	imgseq(:,:,p) = img1; 
end

[ PIP ] = extractFeatures(imgseq(:,:,1)); % This function is called on the first image frame to extract feature

X2 = zeros(length(PIP),imgNum); 
Y2 = zeros(length(PIP),imgNum);
X2(:,1) = PIP(:,2); %transfer all the extracted X coordinates to X2
Y2(:,1) = PIP(:,1); %transfer all the extracted Y coordinates to X2

%Both Darren, You can use X2 and Y2 as the starting point for calling your
%custom LKTracker. 
figure
imshow(imgseq(:,:,1)), hold on
%plot(X2,Y2,'go'); %display the extracted features Uncomment to show the
%tracked point

%draw a bounding box to encompass all the points
% Now use min/max to determine bounding rectangle
min_x = min(X2(:,1));
max_x = max(X2(:,1));
min_y = min(Y2(:,1));
max_y = max(Y2(:,1));
% Use rectangle to draw bounding rectangle
rectangle('Position',[min_x min_y (max_x-min_x) (max_y-min_y)]); %comment to hide the bounding box

%calculate the centoid of a rectangle. We will use this centroid to do air
%writing.
xCentroid = round(mean(X2));
yCentroid = round(mean(Y2));
plot(xCentroid,yCentroid,'r*');

im1 = imgseq(:,:,1);
im2 = imgseq(:,:,2);


x = PIP(:, 1);
y = PIP(:, 2);    
max_level = 3;
% scale image first
% Construct pyramid using gaussian reduction. Level 1 is original
%im1_pyr = zeros([size(im1) max_level]);
%im2_pyr = zeros

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%DENSE LUCAS KANADE PYRAMIDAL + ITERATIVE REFINMENT 
%J.MARZAT - ENSEM / INRIA Rocquencourt (France) julien.marzat@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parameters : levels number, window size, iterations number, regularization
numLevels=3;
window=9;
iterations=1;
alpha = 0.001;

hw = floor(window/2);
t0=clock;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pyramids creation
pyramid1 = im1;
pyramid2 = im2;
%init
for i=2:numLevels
    im1 = impyramid(im1, 'reduce');
    im2 = impyramid(im2, 'reduce');
    pyramid1(1:size(im1,1), 1:size(im1,2), i) = im1;
    pyramid2(1:size(im2,1), 1:size(im2,2), i) = im2;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Processing all levels
for p = 1:numLevels
   
    %current pyramid
    im1 = pyramid1(1:(size(pyramid1,1)/(2^(numLevels - p))), 1:(size(pyramid1,2)/(2^(numLevels - p))), (numLevels - p)+1);
    im2 = pyramid2(1:(size(pyramid2,1)/(2^(numLevels - p))), 1:(size(pyramid2,2)/(2^(numLevels - p))), (numLevels - p)+1);
       
    %init
    if p==1
        u=zeros(size(im1));
        v=zeros(size(im1));
    else  
    %resizing
        u = 2 * imresize(u,size(u)*2,'bilinear');   
        v = 2 * imresize(v,size(v)*2,'bilinear');
    end
    
    %refinment loop
    for r = 1:iterations
   
    u=round(u);
    v=round(v);
    
    %every pixel loop
        for i = 1+hw:size(im1,1)-hw
            for j = 1+hw:size(im2,2)-hw
            patch1 = im1(i-hw:i+hw, j-hw:j+hw);
      
            %moved patch 
            lr = i-hw+v(i,j);
            hr = i+hw+v(i,j);
            lc = j-hw+u(i,j);
            hc = j+hw+u(i,j);
           
                  if (lr < 1)||(hr > size(im1,1))||(lc < 1)||(hc > size(im1,2))  
                  %Regularized least square processing
                  else
                  patch2 = im2(lr:hr, lc:hc);
      
                  fx = conv2(patch1, 0.25* [-1 1; -1 1]) + conv2(patch2, 0.25*[-1 1; -1 1]);
                  fy = conv2(patch1, 0.25* [-1 -1; 1 1]) + conv2(patch2, 0.25*[-1 -1; 1 1]);
                  ft = conv2(patch1, 0.25*ones(2)) + conv2(patch2, -0.25*ones(2));

      
                  Fx = fx(2:window-1,2:window-1)';
                  Fy = fy(2:window-1,2:window-1)';
                  Ft = ft(2:window-1,2:window-1)';

                  A = [Fx(:) Fy(:)];      
                  G=A'*A;
              
                  G(1,1)=G(1,1)+alpha; G(2,2)=G(2,2)+alpha;
                  U=1/(G(1,1)*G(2,2)-G(1,2)*G(2,1))*[G(2,2) -G(1,2);-G(2,1) G(1,1)]*A'*-Ft(:);
                  u(i,j)=u(i,j)+U(1); v(i,j)=v(i,j)+U(2);
                  end
            end
        end
    end
    etime(clock,t0)
end

%resizing
u=u(window:size(u,1)-window+1,window:size(u,2)-window+1);
v=v(window:size(v,1)-window+1,window:size(v,2)-window+1);