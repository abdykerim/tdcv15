close all;
lena = imread('lena.gif');
lena = im2double(lena);


figure('Name', 'Exercise 2');
subplot(3,3,2);
imshow(lena);
title('original');

b1 = bilateral_filter(lena, 1, 0.1);
subplot(3,3,4);
imshow(b1);
title('bilateral, S_d=1, S_r=0.1');

b5 = bilateral_filter(lena, 5, 0.1);
subplot(3,3,5);
imshow(b5);
title('bilateral, S_d=5, S_r=0.1');

b10 = bilateral_filter(lena, 10, 0.1);
subplot(3,3,6);
imshow(b10);
title('bilateral, S_d=10, S_r=0.1');

g1 = gaussian_filter(lena, [3, 3], 1);
subplot(3,3,7);
imshow(g1);
title('gaussian s=1');

g5 = gaussian_filter(lena, [15, 15], 5);
subplot(3,3,8);
imshow(g5);
title('gaussian s=5');

g10 = gaussian_filter(lena, [30, 30], 10);
subplot(3,3,9);
imshow(g10);
title('gaussian s=10');