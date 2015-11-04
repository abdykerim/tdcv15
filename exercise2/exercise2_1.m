lena = imread('lena.gif');
lena = im2double(lena);

figure('Name', 'Exercise 1');
subplot(3,3,1);
imshow(lena);
title('original');

GO = gaussian_filter(lena, [9, 9], 3);
subplot(3,3,4);
imshow(GO);
title('gaussian filter on original');

MO = median_filter(lena, 3);
subplot(3,3,7);
imshow(MO);
title('median filter on original');

SPN = salt_pepper_noise(lena, 0.02);
subplot(3,3,2);
imshow(SPN);
title('salt and pepper noise');

GS = gaussian_filter(SPN, [9, 9], 3);
subplot(3,3,5);
imshow(GS);
title('gaussian filter on salt and pepper');

MS = median_filter(SPN, 3);
subplot(3,3,8);
imshow(MS);
title('median filter on salt and pepper');

GN = gaussian_noise(lena, 0.01, 0);
subplot(3,3,3);
imshow(GN);
title('gassian noise');

GG = gaussian_filter(GN, [9, 9], 3);
subplot(3,3,6);
imshow(GG);
title('gaussian filter on Gaussian');

MG = median_filter(GN, 3);
subplot(3,3,9);
imshow(MG);
title('median filter on Gaussian');