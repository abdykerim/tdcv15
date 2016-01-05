function [] = PlotSimple(dataset, labels)
figure;
hold on;
% Plot predictions

plot_left = dataset(labels < 0,:);
plot_right = dataset(labels >= 0,:);

scatter(plot_left(:,1), plot_left(:,2), 10, 'b', 'x'); % r o
scatter(plot_right(:,1), plot_right(:,2), 10,'r', 'o'); % b x

hold off;
end
