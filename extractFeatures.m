function [ PIP ] = extractFeatures( img)

%this function calls harris corner detector. You can change the value of
%maxPtsNum to change the number of features to be detected
maxPtsNum = 20;
if ~exist('Y1','var')
    [PIP] = corner_Harris(img,maxPtsNum);
end
end