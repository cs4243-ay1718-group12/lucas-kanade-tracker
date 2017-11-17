clear
close all

IO_FILENAME = 'assets/submission-video/score.mp4'; 
obj = VideoReader(IO_FILENAME); % Change the file name here to load your own video file. 
vid = obj.read;
[M N C imgNum] = size(vid);
color_imgseq = zeros(M, N, C, imgNum);
for p = 1:imgNum
	img1 = im2double(vid(:,:,:,p));
    color_imgseq(:, :, :, p) = img1;
end
clear vid obj;

File =  'assets/submission-video/score.txt'; %% hange this to load centroid file name related to the video above
f = fopen(File, 'r');
C = textscan(f, '%f%f', 'Delimiter', ',');
xCentroidArray = C{1};
yCentroidArray = C{2};
fclose(f);

left_x = 100;
left_y = 100;

boundary_x = 353; 
boundary_y = 160;

right_x = 353 + 100;
right_y = 100;

for p = 1:imgNum
    A = color_imgseq(:, :, :, p);
    if (xCentroidArray(p)+25 > boundary_x)
        position = [right_x right_y];
        text = 'right';
    else
        position = [left_x left_y];
        text = 'left';
    end
    box_color = {'red'};
    RGB = insertText(A,position,text,'FontSize',28,'BoxColor',box_color,'BoxOpacity',0.4,'TextColor','white');
    imshow(RGB),hold on
    pause(0.02);
end

 
