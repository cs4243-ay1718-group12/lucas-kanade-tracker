%Step 1:
%Read video into the system
vid = VideoReader('C.mov');

%Step 2:
%Total duration of the video
duration = vid.Duration;
%Height of the video frame in pixels
h = vid.Height;
%Width of the video frame in pixels
w = vid.Width;
%bits per pixel of the video data
bpp = vid.BitsPerPixel;
%video format represented in Matlab
format = vid.VideoFormat;
%frame rate of the video in frames/sec
frRate = vid.FrameRate;


%Step 3:
%Using formula on L5, pg 33 
%Mk = 1/k(R1+...+Rk)= M*(k-1)/k + R/k
k = vid.NumberOfFrames;
%M = background
background = double(zeros(h,w,3));
%R = frame
frame = double(zeros(h,w,3));
vid = VideoReader('C.mov');

%Averaging away the foreground objects
for i = 1 : k
	frame = double(readFrame(vid));
    background = ((background*(i-1))/i) + (frame/i);
end

%Step4:
vid = VideoReader('C.mov');
%Extract moving objects from the video for 1st & last frame
firstFrame = double(read(vid,1));
lastFrame = double(read(vid,Inf));
firstObject = abs(firstFrame - background);
lastObject = abs(lastFrame - background);

fig=figure;
imshow(uint8(background));
figName1='backgroundC.jpeg';
print(fig,'-djpeg',figName1);

imshow(uint8(firstObject));
figName2='1st_frameC.jpeg';
print(fig,'-djpeg',figName2);

imshow(uint8(lastObject));
figName3='last_frameC.jpeg';
print(fig,'-djpeg',figName3);