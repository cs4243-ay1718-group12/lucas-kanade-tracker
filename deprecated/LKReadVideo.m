clear
close all
%main file (starting file) to showcase the extraction of harris features
%based on bounding box
%% video
obj = VideoReader('C.mov'); % Change the file name here to load your own video file. 
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
imshow(imgseq(:,:,1)),hold on
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

xCentroidArray = zeros(imgNum-1); 
yCentroidArray = zeros(imgNum-1);


for p = 2:imgNum
    [X2(:,p), Y2(:,p)] = LK_Track_Pyramid_Iterative(imgseq(:,:,p-1),imgseq(:,:,p),X2(:,p-1),Y2(:,p-1));
    X2p = X2(:,p); Y2p = Y2(:,p); 
    xCentroidArray(p-1) = round(mean(X2p));
    yCentroidArray(p-1) = round(mean(Y2p));
end
 B = imread('glasses.png');
 B = rgb2gray(B);

figure
for p = 1:imgNum
    A = imgseq(:,:,p);
    
     X2p = X2(:,p); Y2p = Y2(:,p); 
     xCentroid = round(mean(X2p));
     yCentroid = round(mean(Y2p));
    X=yCentroid - 60;
    Y=xCentroid - 50;
    
   
    A((1:size(B,1))+X,(1:size(B,2))+Y,:) = B;
     imshow(A),hold on    
    plot(xCentroidArray(1:p),yCentroidArray(1:p),'r*');
   h = plot(X2p,Y2p,'go');
    pause;
    X2pl = X2p; Y2pl = Y2p;
end

 
