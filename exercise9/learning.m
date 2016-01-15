clear all;
close all;
img = imread('seq\im000.pgm');

% figure, imshow(img);
% hold on;
% % x-y plotting
% plot(250, 280,'r.','MarkerSize',20); % top left
% plot(350, 280,'r.','MarkerSize',20); %top right
% plot(250, 380,'r.','MarkerSize',20); %bottom left
% plot(350, 380,'r.','MarkerSize',20); %bottom right

% Template must be 100x100!
%y-x coords
t_coords = [280, 250; 280, 350; 380, 250; 380, 350];
A = cell (1,10);
range = 30;
for i = 1:10
    A{i} = computeA(img, t_coords, range);
    i
    range = range - 3;
end
save updateMatrices.mat A;
