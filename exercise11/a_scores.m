close all;
%TODO: Pyramid scheme, resizing image in a loop?
% Image
% I = im2double(imread('img.jpg'));
I = rgb2gray(im2double(imread('img.jpg')));
% Template
% T = im2double(imread('template.jpg'));
T = rgb2gray(im2double(imread('template.jpg')));
% T = imresize(T, 0.65);
% Calculate SSD and NCC between Template and Image
[img_SSD,img_NCC]=ssd_ncc(T,I);
% Find maximum correspondence in SDD image
[x,y]=find(img_SSD==max(img_SSD(:)));
% Find maximum correspondence in NCC image
[x2,y2]=find(img_NCC==max(img_NCC(:)));

% using built-in ncc function for comparison, will be deleted upon
% submission
% tic;
% ncc_basic = normxcorr2 (T, I); % I,T = gray images or only 1 channel of rgb
% ncc_basic = unpadarray(ncc_basic, size(I));
% toc
% [x3,y3]=find(ncc_basic==max(ncc_basic(:)));

% Show result
figure,
subplot(2,2,1), imshow(I); hold on; plot(y2,x2,'b*'); title('Result')
subplot(2,2,2), imshow(T); title('The template');
subplot(2,2,3), imshow(img_SSD); title('SSD');
subplot(2,2,4), imshow(img_NCC); title('NCC');