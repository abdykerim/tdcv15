close all;

% Image
% I = im2double(imread('img.jpg'));
I = rgb2gray(im2double(imread('img2.jpg')));
% Template
% T = im2double(imread('template.jpg'));
T = rgb2gray(im2double(imread('template2.jpg')));

tic;
%treshold
t = 0.9;
% [gI, gIDir] = computeGradient(I, 0.1);
% [gT, gTDir] = computeGradient(T, 0.1);
% TODO: difference between orientation and direction?
[GxI, GyI] = imgradientxy(I);
[GmagI, GdirI] = imgradient(GxI, GyI);
orientI = mod(atan2(GyI,GxI)+pi, pi);
orientI (find(GmagI < t)) = cos(pi/2); % does this mean perpendicular ( _|_ )????

[GxT, GyT] = imgradientxy(T);
[GmagT, GdirT] = imgradient(GxT, GyT);
orientT = mod(atan2(GyT,GxT)+pi, pi);
orientT (find(GmagT < t)) = cos(pi/2);
n = size(find(orientT~=0),1);
toc
%TODO: correct, but takes too much time (~2-3 seconds)
tic;
EM_matrix=zeros(size(I,1),size(I,2));
[r1,c1]=size(I);
[r2,c2]=size(T);
for i=1:(r1-r2+1)
    for j=1:(c1-c2+1)
        img_reg=orientI(i:i+r2-1,j:j+c2-1);
        em=sum(sum(abs(cos(orientT - img_reg))));
        EM_matrix(i,j)=em;
    end
end
EM_matrix = EM_matrix/n;
toc
[x4,y4]=find(EM_matrix==max(EM_matrix(:)));
figure,
% I add (T_size/2) because of padding issue , will fix as soon as I find faster
% solution, i hope i get correct output not because of just a coincidence, algorithm
% above seems correct to me
subplot(1,1,1), imshow(I); hold on; plot(y4+size(T,2)/2,x4+size(T,1)/2,'b*'); title('Result');
figure,
subplot(2,2,1), imshow(GxI); title('Gx');
subplot(2,2,2), imshow(GyI); title('Gy');
subplot(2,2,3), imshow(orientI); title('orientI');
subplot(2,2,4), imshow(orientT); title('orientT');