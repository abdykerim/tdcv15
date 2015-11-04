lena = imread('lena.gif');
lena = im2double(lena);

g = bilateral_filter(lena, 9, 0.1, 3);

figure
imshow(g)