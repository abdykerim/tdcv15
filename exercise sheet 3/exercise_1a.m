close all

% [tunnel, map, alpha] = imread('checkerboard_tunnel.png', 'png');
% I = im2double(tunnel);
[tunnel, map, alpha] = imread('sample2.jpg', 'jpg');
I = rgb2gray(im2double(tunnel));

% params

sigma_d = 1;
sigma_i = 1;
G_si_size = 9;
threshold = 0.005;

% R = harris_corner_detector(I, sigma_i, sigma_d, G_si_size, threshold);
% R(R<threshold) = 0;
% R = imregionalmax(R);


harris_laplace(I, 4, 2, G_si_size, threshold);




% [r,c] = find(vec2mat(R, size(I, 2)));  % Find row,col coords.	
% figure, imagesc(I), axis image, colormap(gray), hold on
% plot(c,r,'rs'), title('corners detected');




