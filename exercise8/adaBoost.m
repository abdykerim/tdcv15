close all;

N = 30; % number of weak classifiers

data1 = load('ex08\data1.mat');
% Visualize the data samples before the classification
PlotSimple(data1.dat(:,1:2), data1.dat(:,3));
ada1 = AdaboostClassifier(N);
ada1.Train(data1.dat(:,1:2), data1.dat(:,3));
test_labels1 = ada1.Test(data1.dat(:,1:2));

% Visualize the data samples after the classification (first Plot or second?)
ada1.Plot(data1.dat(:,1:2), data1.dat(:,3));
ada1.Plot(data1.dat(:,1:2), test_labels1);


% data2 = load('ex08\data2.mat');
% PlotSimple(data2.dat(:,1:2), data2.dat(:,3));
% ada2 = AdaboostClassifier(N);
% ada2.Train(data2.dat(:,1:2), data2.dat(:,3));
% test_labels2 = ada2.Test(data2.dat(:,1:2));
% 
% ada2.Plot(data2.dat(:,1:2), data2.dat(:,3));
% ada2.Plot(data2.dat(:,1:2), test_labels2);
% 
% 
% data3 = load('ex08\data3.mat');
% PlotSimple(data3.dat(:,1:2), data3.dat(:,3));
% ada3 = AdaboostClassifier(N);
% ada3.Train(data3.dat(:,1:2), data3.dat(:,3));
% test_labels3 = ada3.Test(data3.dat(:,1:2));
% 
% ada3.Plot(data3.dat(:,1:2), data3.dat(:,3));
% ada3.Plot(data3.dat(:,1:2), test_labels3);

% TODO: need to Visualize the classification error in comparison to the 
% number of the week classiers.