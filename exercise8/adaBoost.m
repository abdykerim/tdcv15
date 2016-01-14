close all;

N = 60; % number of weak classifiers

%% data 1

data = load('ex08\data1.mat');
error = zeros(1,N);

ada = AdaboostClassifier(N);
ada.Train(data.dat(:,1:2), data.dat(:,3));

for i=1:N
    test_labels1 = ada.Test(data.dat(:,1:2), i);    
    error(i) = mean(test_labels1 ~= data.dat(:,3));
end

figure;
subplot(2,2,1);
ada.Plot(data.dat(:,1:2), data.dat(:,3), 0, 0);
subplot(2,2,2);
ada.Plot(data.dat(:,1:2), test_labels1, 1, 1);
subplot(2,2,3:4);
plot((1:N), error);

%%

%% data 2

N = 150;
data = load('ex08\data2.mat');
error = zeros(1,N);

ada = AdaboostClassifier(N);
ada.Train(data.dat(:,1:2), data.dat(:,3));

for i=1:N
    test_labels1 = ada.Test(data.dat(:,1:2), i);    
    error(i) = mean(test_labels1 ~= data.dat(:,3));
end

figure;
subplot(2,2,1);
ada.Plot(data.dat(:,1:2), data.dat(:,3), 0, 0);
subplot(2,2,2);
ada.Plot(data.dat(:,1:2), test_labels1, 1, 1);
subplot(2,2,3:4);
plot((1:N), error);
%%

%% data 3

N = 60;
data = load('ex08\data3.mat');
error = zeros(1,N);

ada = AdaboostClassifier(N);
ada.Train(data.dat(:,1:2), data.dat(:,3));

for i=1:N
    test_labels1 = ada.Test(data.dat(:,1:2), i);    
    error(i) = mean(test_labels1 ~= data.dat(:,3));
end

figure;
subplot(2,2,1);
ada.Plot(data.dat(:,1:2), data.dat(:,3), 0, 0);
subplot(2,2,2);
ada.Plot(data.dat(:,1:2), test_labels1, 1, 1);
subplot(2,2,3:4);
plot((1:N), error);
%%
