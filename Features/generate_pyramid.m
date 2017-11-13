function [pyramid] = Generate_Pyramid(raw_img, max_level)

pyramid = cell(1, max_level);
pyramid{1} = im2double(raw_img);

for level = 2 : max_level
    img = pyramid{level - 1};
    % Build gaussian reduction kernel
    central_weight = .375;
    ker1d = [.25-central_weight/2 .25 central_weight .25 .25-central_weight/2];
    kernel = kron(ker1d,ker1d');
    % Convert image to double for processing
    img = im2double(img);
    result = [];
    for p = 1:size(img,3)
        img1 = img(:,:,p);
        imgFiltered = imfilter(img1,kernel,'replicate','same');
        result(:,:,p) = imgFiltered(1:2:size(img,1),1:2:size(img,2));
    end
    
	pyramid{level} = result;
end