
lena = imread('lena.gif');
lena = im2double(lena);

figure('Name', 'Original');
imshow(lena);



%%%%%% 2.a) %%%%%%

Gaussian2D = gaussian_kernel([3,3], 1);
tic;
G1 = convolution(lena, Gaussian2D , 'm');
toc;

figure('Name', '2.a 2D gaussian filter with sigma =  1');
imshow(G1);

Gaussian2D = gaussian_kernel([9,9], 3);
tic;
G3 = convolution(lena, Gaussian2D , 'm');
toc;

figure('Name', '2.a 2D gaussian filter with sigma =  3');
imshow(G3);



%%%%%% 2.b) %%%%%


% sigma = 1

horizontalGauss = gaussian_kernel([3,1], 1);
verticalGauss = gaussian_kernel([1,3], 1);

tic;
convSum_s1 = convolution(convolution(lena, horizontalGauss, 'm'), verticalGauss , 'm');
toc;

figure('Name', '2.b 1D linear combination sigma =  1');
imshow(convSum_s1);


% sigma = 3

horizontalGauss = gaussian_kernel([9,1], 3);
verticalGauss = gaussian_kernel([1,9], 3);

tic;
convSum_s3 = convolution(convolution(lena, horizontalGauss, 'm'), verticalGauss , 'm');
toc;

figure('Name', '2.b 1D linear combination sigma =  3');
imshow(convSum_s3);


%%% squared difference

sq = convSum_s1 - G1;
ssd = sq * sq;

figure('Name', '2.b squared difference sigma = 1');
imshow(ssd);


sq = convSum_s3 - G3;
ssd = sq * sq;

figure('Name', '2.b squared difference sigma = 3');
imshow(ssd);
