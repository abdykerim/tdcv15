
lena = imread('lena.gif');
lena = im2double(lena);

figure('Name', 'Original');
imshow(lena);

H = [1 1 1 1 1; 1 1 -14 1 1; 1 1 1 1 1];

C = convolution(lena, H, 'c');

figure('Name', '1.a filter with arbitrary MxN mask');
imshow(C);

C = convolution(lena, mean_kernel(3), 'c');

figure('Name', '1.b filter with normalized mean mask');
imshow(C);