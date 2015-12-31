close all;

classifiers = load('ex08\Classifiers.mat');

faceA = rgb2gray(imread('ex08\faceA.jpg'));
faceB = rgb2gray(imread('ex08\faceB.jpg'));
faceC = rgb2gray(imread('ex08\faceC.jpg'));

iiA = buildIntegralImage(faceA);

figure;
imshow(iiA);
