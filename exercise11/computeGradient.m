function [ gradientI, Gdir ] = computeGradient(I, treshold)
if(size(I,3)==3)
    % Color Image
    [gradientI, Gdir] = computeGradient_color(I, treshold);
else
    % Grayscale image
    [gradientI, Gdir] = computeGradient_gray(I, treshold);
end
end

function [gradientI, Gdir] = computeGradient_color(I, treshold)
[gradientI_R, Gdir_R ]= computeGradient_gray(I(:,:,1), treshold);
[gradientI_G, Gdir_G ]= computeGradient_gray(I(:,:,2), treshold);
[gradientI_B, Gdir_B ]= computeGradient_gray(I(:,:,3), treshold);
% Choose the max among three channels element-wise
gradientI = max(max(gradientI_R, gradientI_G), gradientI_B);
Gdir = max(max(Gdir_R, Gdir_G), Gdir_B);
end

function [gmag, gdir] = computeGradient_gray(I, treshold)
% Combine the results
[gmag, gdir] = imgradient(I);
%range from 0 to 1
gmag = (gmag-min(gmag(:)))./(max(gmag(:))-min(gmag(:)));
gdir = (gdir-min(gdir(:)))./(max(gdir(:))-min(gdir(:)));
%thresholding
gmag (find(gmag < treshold)) = 0;
end