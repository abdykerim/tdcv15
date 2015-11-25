function [integralI] = integral_images(I)
% without padding zeros on top and left
% R = cumsum(cumsum(double(I(:,:,1))')');
% G = cumsum(cumsum(double(I(:,:,2))')');
% B = cumsum(cumsum(double(I(:,:,3))')');

% with padded zeros on top and left
integralI = zeros(size(I,1)+1, size(I,2)+1, size(I,3));
integralI (:,:, 1) = integralImage(double(I(:,:,1)));
integralI (:,:, 2) = integralImage(double(I(:,:,2)));
integralI (:,:, 3) = integralImage(double(I(:,:,3)));
end