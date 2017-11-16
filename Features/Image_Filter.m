function [filtered_image] = Image_Filter(raw_img, kernel)

    % Create boundary image
    img = zeros(size(raw_img)+2);
    img(2:size(img,1)-1,2:size(img,2)-1) = raw_img(1:size(raw_img,1),1:size(raw_img,2));
    % Fill in boundary edge using nearest edge
    img(1,2:size(img,2)-1) = raw_img(1,1:size(raw_img,2));
    img(size(img,1),2:size(img,2)-1) = raw_img(size(raw_img,1),1:size(raw_img,2));
    img(2:size(img,1)-1,1) = raw_img(1:size(raw_img,1),1);
    img(2:size(img,1)-1,size(img,2)) = raw_img(1:size(raw_img,1),size(raw_img,2));
    % Fill in boundary corner using nearest corner
    img(1,1) = raw_img(1,1);
    img(1,size(img,2)) = raw_img(1,size(raw_img,2));
    img(size(img,1),1) = raw_img(size(raw_img,1),1);
    img(size(img,1),size(img,2)) = raw_img(size(raw_img,1),size(raw_img,2));
    
    img_duplicate = img;
    % Apply the kernel on img
    for i = 1 : size(img,1) - 2
        for j = 1 : size(img,2) - 2
            window = img(i:i+2,j:j+2);
            sum_matrix = window .* kernel;
            img_duplicate(i+1,j+1) = sum(sum(sum_matrix));
        end
    end
    
    % Return original-sized imgae
    filtered_image = img_duplicate(2:size(img,1)-1,2:size(img,2)-1);
end

