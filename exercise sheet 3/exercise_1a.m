close all

Img_Checkerboard = imread('checkerboard_tunnel.png');

Img_Sample2 = imread('sample2.jpg');
Img_Sample2 = rgb2gray(Img_Sample2);

Img_House = imread('house.tif');
Img_House = Img_House(:,:,1);

Img_Test = imread('test.pgm');

% param
s = 0.7;
k = 1.4; % suggested step size
sigma_0 = 0.5;
threshold_Checkerboard = 0.0009; % 0.0005;
threshold_Sample2 = 0.0005; % 0.0005;
threshold_House = 0.0000002;  % 0.0002;
threshold_Test = 0.00001; % 0.000025;

threshold_Checkerboard_l = 0 ;
threshold_Sample2_l = 0;
threshold_House_l = 0;
threshold_Test_l = 0;

Image = {Img_Checkerboard Img_Sample2 Img_House Img_Test};
names = {'Checkerboard' 'Sample2' 'House' 'Test'};
threshold_h = {threshold_Checkerboard threshold_Sample2 threshold_House threshold_Test} ;
threshold_l = {threshold_Checkerboard_l threshold_Sample2_l threshold_House_l threshold_Test_l};
n = [0 7 17];
sigma_i = sigma_0 * k.^n; 

for j = 1:3
    R = multiscale_harris(im2double(Image{4}), sigma_i(j), ...
        threshold_h{4});
    [r,c] = find(R, size(Image{4}, 2));  % Find row,col coords.
    figure('Name', sprintf('%s, multiscale Harris',names{4})),...
        imagesc(Image{4}), axis image, colormap(gray), hold on
    plot(c,r,'rs'), title(sprintf('corners detected for n = %d', n(j)));
end

for j = 1:3
    R = harris_laplace(im2double(Image{2}), n(j), sigma_0, k,...
        threshold_h{2}, threshold_l{2});
    [r,c] = ind2sub(size(Image{2}), R);
    figure('Name', sprintf('%s, Harris-Laplace',names{2})),...
        imagesc(Image{2}), axis image, colormap(gray), hold on
    plot(c,r,'rs'), title(sprintf('corners detected for n = %d', n(j)));
end
