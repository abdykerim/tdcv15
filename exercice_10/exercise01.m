close all;

I = rgb2hsv(imread('sequence/2043_000140.jpeg'));
hue = I(:,:,1);

center = [325, 531];
w = 50;
h = 50;

box = subImage(hue, center, w, h);

hist = colorHist(box);

figure;
bar(linspace(0, 1, 256), hist);

colorMap = probMap(box, hist);

figure;
bar3(colorMap);