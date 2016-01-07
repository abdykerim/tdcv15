close all;

N = 60; % number of weak classifiers

%% data 1

data = load('ex08\data1.mat');
error = zeros(1,N);

for i=1:N
    ada1 = AdaboostClassifier(i);
    ada1.Train(data.dat(:,1:2), data.dat(:,3));
    test_labels1 = ada1.Test(data.dat(:,1:2));
    
    error(i) = mean(test_labels1 ~= data.dat(:,3));
end

figure;
subplot(2,2,1);
ada1.Plot(data.dat(:,1:2), data.dat(:,3), 0, 0);
subplot(2,2,2);
ada1.Plot(data.dat(:,1:2), test_labels1, 1, 1);
subplot(2,2,3:4);
plot((1:N), error);

%%

%% data 2
data = load('ex08\data2.mat');
error = zeros(1,N);

for i=1:N
    ada1 = AdaboostClassifier(i);
    ada1.Train(data.dat(:,1:2), data.dat(:,3));
    test_labels1 = ada1.Test(data.dat(:,1:2));
    
    error(i) = mean(test_labels1 ~= data.dat(:,3));
end

figure;
subplot(2,2,1);
ada1.Plot(data.dat(:,1:2), data.dat(:,3), 0, 0);
subplot(2,2,2);
ada1.Plot(data.dat(:,1:2), test_labels1, 1, 1);
subplot(2,2,3:4);
plot((1:N), error);
%%

%% data 3
data = load('ex08\data3.mat');
error = zeros(1,N);

for i=1:N
    ada1 = AdaboostClassifier(i);
    ada1.Train(data.dat(:,1:2), data.dat(:,3));
    test_labels1 = ada1.Test(data.dat(:,1:2));
    
    error(i) = mean(test_labels1 ~= data.dat(:,3));
end

figure;
subplot(2,2,1);
ada1.Plot(data.dat(:,1:2), data.dat(:,3), 0, 0);
subplot(2,2,2);
ada1.Plot(data.dat(:,1:2), test_labels1, 1, 1);
subplot(2,2,3:4);
plot((1:N), error);
%%
