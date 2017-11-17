function readTextFileAndDraw(file_name) 
    IO_FILENAME = strcat(file_name,'.mp4');
    obj = VideoReader(IO_FILENAME); % Change the file name here to load your own video file. 
    vid = obj.read;
    [M N C imgNum] = size(vid);
    color_imgseq = zeros(M, N, C, imgNum);
    imgseq = zeros(M, N, imgNum);
    for p = 1:imgNum
        img1 = im2double(vid(:,:,:,p));
        color_imgseq(:, :, :, p) = img1;
        imgseq(:, :, p) = rgb2gray(img1);
    end
    clear vid obj;

    File =  strcat(file_name,'.txt');
    f = fopen(File, 'r');
    C = textscan(f, '%f%f', 'Delimiter', ',');
    xCentroidArray = C{1};
    yCentroidArray = C{2};
    fclose(f);
    figure
    C = imread('glasses.png');
    C = rgb2gray(C);
    for p = 1:imgNum
        %A = color_imgseq(:, :, :, p);
        A = imgseq(:, :, p);
        %imshow(imgseq(:,:,p)), hold on
        use_X = yCentroidArray(p);
        use_Y = xCentroidArray(p);
        A((1:size(C,1))+use_X,(1:size(C,2))+use_Y) = C;
        imshow(A),hold on    
        %plot(X(:, p), Y(:, p), 'go'); % tracked points
        %plot(round(mean(X(:, p))), round(mean(Y(:, p))), 'g*'); % centroid of tracked points
        plot(xCentroidArray(1:p),yCentroidArray(1:p),'r*');
        %rectangle('Position', get_bounding_rect(X(:, p), Y(:, p))) % bounding box of tracked points
        pause(0.05);
    end

end