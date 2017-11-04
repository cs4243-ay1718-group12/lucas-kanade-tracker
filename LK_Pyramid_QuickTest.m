% Constants
win_size = 10; % Abitrary, I have no idea what works :)
max_level = 4; % Abitrary. Then again Gaussian reduce the image by half each dimension so 4 already means 16*16 times smaller.
img1 = imread('frame1.jpg');
img2 = imread('frame2.jpg');
% Use method
[x,y] = Harris_Corner_Detection(img1); % !!! Need Harris Corner
[u,v] = LK_Track_Pyramid(img1, img2, x, y);
% Print. Verify with eyes
fig1 = figure;
color_image_1 = cat(3,img1,img1,img1);
imshow(color_image_1);
pos_1 = [y - 5 - 3, x - 5 - 3, 6, 6];
rectangle('Position',pos_1,'EdgeColor','r');
fig2 = figure;
color_image_2 = cat(3,img2,img2,img2);
imshow(color_image_2);
pos_2 = [v - 5 - 3, u - 5 - 3, 6, 6];
rectangle('Position',pos_2,'EdgeColor','r');