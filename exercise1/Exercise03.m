
lena = imread('lena.gif');
lena = im2double(lena);
figure('Name', 'Original');
imshow(lena);

Dx = [-1 0 1; -1 0 1; -1 0 1];
Dy = [-1 -1 -1; 0 0 0; 1 1 1];

%3a
C = convolution(lena, Dx, 'm');
D = convolution(lena, Dy, 'm');
figure('Name', '3.a gradient image in x-direction');
imshow(C);
figure('Name', '3.a gradient image in y-direction');
imshow(D);

%3b
mag = sqrt(C.*C + D.*D);
ori = atan2(D, C);

figure('Name', '3.b gradient magnitude');
imshow(mag);
figure('Name', '3.b gradient orientation');
imshow(ori);

%3c

G = gaussian_kernel([9,9], 3);

GI = convolution(lena, G, 'c');
SmX = convolution(GI, Dx, 'c');
SmY = convolution(GI, Dy, 'c');

magSm = sqrt(SmX.*SmX + SmY.*SmY);
oriSm = atan2(SmY, SmX);

figure('Name', '3.c smoothed gradient magnitude');
imshow(magSm);
figure('Name', '3.c smoothed gradient orientation');
imshow(oriSm);

% associativity
DxG = convolution(G, Dx, 'c');
DyG = convolution(G, Dy, 'c');

SmXv2 = convolution(lena, DxG, 'c');
SmYv2 = convolution(lena, DyG, 'c');

% magSmv2 = sqrt(SmXv2.*SmXv2 + SmYv2.*SmYv2);
% oriSmv2 = atan2(SmYv2, SmXv2);

figure('Name', '3.c Dx * (G * I)');
imshow(SmX);
figure('Name', '3.c (Dx * G) * I');
imshow(SmXv2);

figure('Name', '3.c Dy * (G * I)');
imshow(SmY);
figure('Name', '3.c (Dy * G) * I');
imshow(SmYv2);