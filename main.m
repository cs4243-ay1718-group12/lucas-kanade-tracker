clear
close all

% PARAMETERS
IO_FILENAME = 'C.mov';
CORNER_TYPE = 'custom_harris';
CORNER_NUM = 10;
CORNER_FILTER_SIZE = 13;
CORNER_MIN_QUALITY = 0.04; % default is 0.01, must be in [0, 1]
LK_WIN_RADIUS = 5;
LK_ACCURACY = 0.01;
LK_MAX_ITER = 20;
PLOT_INITIAL = true;

obj = VideoReader(IO_FILENAME); % Change the file name here to load your own video file. 

vid = obj.read;
[M N C imgNum] = size(vid);
imgseq = zeros(M,N,imgNum); 
for p = 1:imgNum
	img1 = im2double(vid(:,:,:,p));
	if C == 3, img1 = rgb2gray(img1); end
	imgseq(:,:,p) = img1; 
end

% get corner coordinates
[xmin, ymin, xmax, ymax, w, h] = poll_area_of_interest(imgseq(:, :, 1));
if strcmp(CORNER_TYPE, 'harris')
    detector = detectHarrisFeatures(imgseq(:, :, 1), 'FilterSize', CORNER_FILTER_SIZE, 'ROI', [xmin, ymax, w, h], 'MinQuality', CORNER_MIN_QUALITY);
    corners = double(detector.selectStrongest(CORNER_NUM).Location);
elseif strcmp(CORNER_TYPE, 'custom_harris')
    detector = detectCustomHarrisFeatures(imgseq(:, :, 1), CORNER_NUM, xmin, ymin, xmax, ymax, CORNER_MIN_QUALITY); 
    corners = detector;
else        
    detector = detectMinEigenFeatures(imgseq(:, :, 1), 'FilterSize', CORNER_FILTER_SIZE, 'ROI', [xmin, ymax, w, h], 'MinQuality', CORNER_MIN_QUALITY);
    corners = double(detector.selectStrongest(CORNER_NUM).Location);
end
% separate X and Y components of corner coordinate
X = zeros(length(corners), imgNum);
Y = zeros(length(corners), imgNum);
X(:, 1) = corners(:, 1);
Y(:, 1) = corners(:, 2);

if PLOT_INITIAL
    % plot initial corners
    figure;
    imshow(imgseq(:, :, 1)), hold on;

    % draw a bounding box to encompass all the corners
    rectangle('Position', get_bounding_rect(X(:, 1), Y(:, 1))) %comment to hide the bounding box
    plot(X(:, 1), Y(:, 1), '*');
    % calculate the centoid of a rectangle. We will use this centroid to do air writing.
    plot(round(mean(X(:, 1))), round(mean(Y(:, 1))), 'r*');
end

for p = 2:imgNum
    % get displacement between the p and (p-1)th frames of the video
    [dx, dy] = lk_pyramidal_track(imgseq(:,:,p-1), imgseq(:,:,p), X(:,p-1), Y(:,p-1), LK_WIN_RADIUS, LK_ACCURACY, LK_MAX_ITER);
    X(:, p) = X(:, p-1) + dx;
    Y(:, p) = Y(:, p-1) + dy;
    xCentroidArray(p-1) = round(mean(X(:, p)));
    yCentroidArray(p-1) = round(mean(Y(:, p)));
end
 
figure
% B = imread('emoji_glass.png');
% B = rgb2gray(B);
% C = imread('glasses.png');
% C = rgb2gray(C);
for p = 1:imgNum
    A = imgseq(:,:,p);
    %imshow(imgseq(:,:,p)), hold on
    xCentroid = round(mean(X(:, p)));
    yCentroid = round(mean(Y(:, p)));
    use_X=yCentroid - 80 ;
    use_Y=xCentroid - 120;
%     if p>20
%         A((1:size(C,1))+use_X,(1:size(C,2))+use_Y,:) = C;
%     end
%     if p>60
%         A((1:size(B,1))+use_X,(1:size(B,2))+use_Y,:) = B;
%     end
%     if p>90
%         A((1:size(C,1))+use_X,(1:size(C,2))+use_Y,:) = C;
%     end
        imshow(A),hold on    
    %plot(X(:, p), Y(:, p), 'go'); % tracked points
    plot(round(mean(X(:, p))), round(mean(Y(:, p))), 'g*'); % centroid of tracked points
    plot(xCentroidArray(1:p),yCentroidArray(1:p),'r*');
    %rectangle('Position', get_bounding_rect(X(:, p), Y(:, p))) % bounding box of tracked points
    pause(0.05);
end

 
