close all;

N = 30; % number of weak classifiers

data1 = load('ex08\data1.mat');
data2 = load('ex08\data2.mat');
data3 = load('ex08\data3.mat');

ada = AdaboostClassifier(N);
ada.Train(data1.dat(:,1:2), data1.dat(:,3));
ada.Test(data1.dat(:,1:2));
