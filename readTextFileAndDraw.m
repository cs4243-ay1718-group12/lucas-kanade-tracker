IO_FILENAME = 'wall_c.mov';
obj = VideoReader(IO_FILENAME); % Change the file name here to load your own video file. 
vid = obj.read;
[M N C imgNum] = size(vid);
color_imgseq = zeros(M, N, C, imgNum);
for p = 1:imgNum
	img1 = im2double(vid(:,:,:,p));
    color_imgseq(:, :, :, p) = img1;
end
clear vid obj;

File =  'centroid.txt';
f = fopen(File, 'r');
C = textscan(f, '%f%f', 'Delimiter', ',');
xCentroidArray = C{1};
yCentroidArray = C{2};
fclose(f);
figure
C = imread('glasses.png');
for p = 1:imgNum
    A = color_imgseq(:, :, :, p);
    %imshow(imgseq(:,:,p)), hold on
    use_X = yCentroidArray(p);
    use_Y = xCentroidArray(p);
    A((1:size(C,1))+use_X,(1:size(C,2))+use_Y,:) = C;
    imshow(A),hold on    
    %plot(X(:, p), Y(:, p), 'go'); % tracked points
    %plot(round(mean(X(:, p))), round(mean(Y(:, p))), 'g*'); % centroid of tracked points
    plot(xCentroidArray(1:p),yCentroidArray(1:p),'r*');
    %rectangle('Position', get_bounding_rect(X(:, p), Y(:, p))) % bounding box of tracked points
    pause(0.05);
end

 
