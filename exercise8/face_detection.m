close all;

faceA = rgb2gray(imread('ex08\faceA.jpg'));
faceB = rgb2gray(imread('ex08\faceB.jpg'));
faceC = rgb2gray(imread('ex08\faceC.jpg'));

load('ex08\Classifiers.mat'); % variable 'classifiers' defined on load
%deleting column of zeroes
classifiers = classifiers(:, 2:size(classifiers,2));
haar_features = HaarFeatures(classifiers);
haar_features.HaarFeaturesCompute(faceA);

