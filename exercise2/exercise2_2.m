lena = imread('lena.gif');
lena = im2double(lena);



figure('Name', 'Exercise 2');
subplot(1,2,1);
imshow(lena);
title('original');

sigma_d = 3;
sigma_r = 100;
res = bilateral_filter( lena, sigma_d, sigma_r);
subplot(1,2,2);
imshow(res);
title('bilateral filter');