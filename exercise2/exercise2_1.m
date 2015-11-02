lena = imread('lena.gif');
lena = im2double(lena);
%figure('Name', 'original');
%imshow(lena);
%SPN2 = imnoise(lena,'salt & pepper',0.05);  <- FUNCTION PROVIDED BY MATLAB
SPN = salt_pepper_noise(lena, 0.05);
C = median_filter(SPN, 3);
figure('Name', '1.a salt-pepper noise and median filter');
imshowpair(SPN,C,'montage')

GN = gaussian_noise(lena, 0.02, 0);
Gaussian2D = gaussian_kernel([9,9], 3);
G1 = convolution(GN, Gaussian2D , 'm');
figure('Name', '1.a gaussian noise and gaussian filter');
imshowpair(GN,G1,'montage')