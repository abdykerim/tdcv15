close all

Img_Checkerboard = imread('checkerboard_tunnel.png');

Img_Sample2 = imread('sample2.jpg');
Img_Sample2 = rgb2gray(Img_Sample2);

Img_House = imread('house.tif');
Img_House = Img_House(:,:,1);

Img_Test = imread('test.pgm');

I = im2double(Img_House);

% param
s = 0.7;
n = 0;
k = 1.4; % suggested step size
sigma_0 = 0.5;
sigma_i = sigma_0 * k^n;
G_si_size = 5;
threshold_House = 0.0002;
threshold_Sample2 = 0.0005;
threshold_Checkerboard = 0.0005;
threshold_Test = 0.000025;
threshold = threshold_Checkerboard;
threshold_h = 0.0000025;
threshold_l = 0;

R = harris_laplace(I, n, sigma_0, k, G_si_size, threshold_h, threshold_l);
[r,c] = ind2sub(size(I), R);

% R = multiscale_harris(I, sigma_i, G_si_size, threshold_h);
% [r,c] = find(R, size(I, 2));  % Find row,col coords.	

figure, imagesc(I), axis image, colormap(gray), hold on
plot(c,r,'rs'), title('corners detected');