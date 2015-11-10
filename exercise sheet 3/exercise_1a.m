close all

% [tunnel, map, alpha] = imread('checkerboard_tunnel.png', 'png');
% I = im2double(tunnel);
% 
% [testImg, map, alpha] = imread('sample2.jpg', 'jpg');
% I = rgb2gray(im2double(testImg));
% 
I = imread('test.pgm');
I = im2double(I);

% I = imread('house.tif', 'tif');
% I = im2double(I);
% I = rgb2gray(im2double(testImg));

% param

sigma_d = 1;
sigma_i = 2;
G_si_size = 9;
threshold = 0.00005;

R = harris_laplace(I, 7, 2, G_si_size, threshold);
[r,c] = ind2sub(size(I), R);

% R = multiscale_harris(I, sigma_i, G_si_size, threshold);
% [r,c] = find(vec2mat(R, size(I, 2)));  % Find row,col coords.	

figure, imagesc(I), axis image, colormap(gray), hold on
plot(c,r,'rs'), title('corners detected');




