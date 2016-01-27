close all;

% Image
I = im2double(imread('img.jpg'));
% I = rgb2gray(im2double(imread('img.jpg')));
% Template
T = im2double(imread('template.jpg'));
% T = rgb2gray(im2double(imread('template.jpg')));

[gI, gIDir] = computeGradient(I, 0.3);
[gT, gTDir] = computeGradient(T, 0.3);
figure,
subplot(2,2,1), imshow(gI); title('gI mag');
subplot(2,2,2), imshow(gIDir); title('gI dir');
subplot(2,2,3), imshow(gT); title('gT mag');
subplot(2,2,4), imshow(gTDir); title('gT dir');