function [pyramid] = generate_pyramid(raw_img, max_level)

pyramid = cell(1, max_level);
pyramid{1} = im2double(raw_img);

for level = 2 : max_level
    img = pyramid{level - 1};
    % Use same kernel by matlab ipymramid
    % Reference: https://www.mathworks.com/help/images/ref/impyramid.html#bvozh1q
    w = [1/4-0.375/2 1/4 0.375 1/4 1/4-0.375/2];
    gauss_reduce_kern = zeros(5);
    for i = 1:5
        for j = 1:5
            gauss_reduce_kern(i,j) = w(i)*w(j);
        end
    end
    % Convert image to double for processing
    img = im2double(img);
    pyramidized_image = [];
    for frame = 1:size(img,3)
        image_on_frame = img(:,:,frame);
        gaussian_reduced_image = imfilter(image_on_frame,gauss_reduce_kern,'replicate','same');
        % skip every one pixel in between to redyuce the size by half
        pyramidized_image(:,:,frame) = gaussian_reduced_image(1:2:size(image_on_frame,1),1:2:size(image_on_frame,2));
    end
    
	pyramid{level} = pyramidized_image;
end