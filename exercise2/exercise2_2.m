
close all;
lena = imread('lena.gif');
lena = im2double(lena);

GN = gaussian_noise(lena, 0.01, 0);

g = bilateral_filter(GN, 10, 1);

figure('Name', 'Exercise 1');
subplot(1,2,1);
imshow(GN), title('noise');

subplot(1,2,2);
imshow(g), title('bilateral filter');
