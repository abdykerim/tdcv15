close all;

N = 30; % number of weak classifiers

data1 = load('ex08\data1.mat');
data2 = load('ex08\data2.mat');
data3 = load('ex08\data3.mat');



ada = AdaboostClassifier(N);
ada.Train(data1.dat(:,1:2), data1.dat(:,3));
test_labels = ada.Test(data1.dat(:,1:2));

ada.Plot(data1.dat(:,1:2), data1.dat(:,3));
ada.Plot(data1.dat(:,1:2), test_labels);



%% ada = AdaboostClassifier(N);
% ada.Train(data2.dat(:,1:2), data2.dat(:,3));
% test_labels = ada.Test(data2.dat(:,1:2));
% 
% ada.Plot(data2.dat(:,1:2), data2.dat(:,3));
% ada.Plot(data2.dat(:,1:2), test_labels);
% 
% 
% 
% ada = AdaboostClassifier(N);
% ada.Train(data3.dat(:,1:2), data3.dat(:,3));
% test_labels = ada.Test(data3.dat(:,1:2));
% 
% ada.Plot(data3.dat(:,1:2), data3.dat(:,3));
% ada.Plot(data3.dat(:,1:2), test_labels);
%%