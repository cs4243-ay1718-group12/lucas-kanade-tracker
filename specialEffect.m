clear
close all

IO_FILENAME = 'assets/submission-video/C.mp4'; 
obj = VideoReader(IO_FILENAME); % Change the file name here to load your own video file. 
vid = obj.read;
[M N C imgNum] = size(vid);
color_imgseq = zeros(M, N, C, imgNum);
for p = 1:imgNum
	img1 = im2double(vid(:,:,:,p));
    color_imgseq(:, :, :, p) = img1;
end
clear vid obj;

File =  'assets/submission-video/C.txt'; %% hange this to load centroid file name related to the video above
f = fopen(File, 'r');
C = textscan(f, '%f%f', 'Delimiter', ',');
xCentroidArray = C{1};
yCentroidArray = C{2};
fclose(f);

img_prefix = 'assets/';
img_repo = {'glasses.png','emoji.png'};
img_index = floor(rand()) + 1;

figure
C = imread('assets/glasses.png');

%815 202 933 168

for p = 1:imgNum
    A = color_imgseq(:, :, :, p);
  
    r = randi([10 20],1);
    A((1:size(C,1))+xCentroidArray(1:1)+r ,(1:size(C,2))+yCentroidArray(1:1)-r,:) = C;
    imshow(A),hold on  
  
    plot(xCentroidArray(1:p),yCentroidArray(1:p),'r*');
  
    pause(0.02);
end

 
