function [R,G,B] = integral_images(I)

R = cumsum(cumsum(double(I(:,:,1))')');
G = cumsum(cumsum(double(I(:,:,2))')');
B = cumsum(cumsum(double(I(:,:,3))')');
end