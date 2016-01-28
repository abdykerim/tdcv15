function [img_SSD,img_NCC]=ssd_ncc(T, I)

if(size(T,3)==3)
    % Color Image
    [img_SSD,img_NCC] = ssd_ncc_color(T, I);
else
    % Grayscale image
    [img_SSD,img_NCC] = ssd_ncc_gray(T, I);
end
end

function [img_SSD,img_NCC]=ssd_ncc_color(T, I)
% Split color image, and do template matching on R,G and B image
[img_SSD_R,img_NCC_R] = ssd_ncc_gray(T(:,:,1),I(:,:,1));
[img_SSD_G,img_NCC_G] = ssd_ncc_gray(T(:,:,2),I(:,:,2));
[img_SSD_B,img_NCC_B] = ssd_ncc_gray(T(:,:,3),I(:,:,3));
% Combine the results
img_SSD = (img_SSD_R+img_SSD_G+img_SSD_B)/3;
img_NCC = (img_NCC_R+img_NCC_G+img_NCC_B)/3;
end

function [img_SSD,img_NCC] = ssd_ncc_gray(T, I)
% Calculate correlation output size  = input size + padding template
T_size = size(T); I_size = size(I);
outsize = I_size + T_size-1;

% SSD, 1st way with manual fft computation without imfilter, fastest
% calculate correlation in frequency domain
FT = fft2(rot90(T,2), outsize(1), outsize(2));
FI = fft2(I, outsize(1), outsize(2));
Icorr = real(ifft2(FI.* FT));

% Calculate Local Quadratic sum of Image and Template
localQSumI = local_sum(I.*I, T_size);
QSumT = sum(T(:).^2);

% SSD = I^2 + T^2 - 2*C(I,T), it is much faster than direct
% application of the formula in the exercise pdf
img_SSD = localQSumI+QSumT-2*Icorr;

% Normalize to range 0..1
img_SSD = (img_SSD-min(img_SSD(:)))./(max(img_SSD(:))-min(img_SSD(:)));
img_SSD = 1 - img_SSD; % need to invert

% Remove padding
img_SSD = unpadarray(img_SSD, size(I));

% %SSD 2nd way, using imfilter (4 times slower than manual fft computation above)
% % SSD
% Icorr2 = imfilter(I, T, 'corr');
% 
% % Calculate Local Quadratic sum of Image and Template
% localQSumI = local_sum(I.*I, T_size);
% %remove padding
% localQSumI = unpadarray(localQSumI, size(I));
% QSumT = sum(T(:).^2);
% 
% % SSD = I^2 + T^2 - 2*C(I,T), it is much faster than direct
% % application of the formula in the exercise pdf
% img_SSD = localQSumI+QSumT-2*Icorr2;
% % Normalize to range 0..1
% img_SSD = (img_SSD-min(img_SSD(:)))./(max(img_SSD(:))-min(img_SSD(:)));
% img_SSD = 1 - img_SSD; % need to invert


% NCC
%normalizing
T_norm = normalize(T);
I_norm = normalize(I);

img_NCC = imfilter(I_norm, T_norm, 'corr');
%ranging from 0 to 1
img_NCC = (img_NCC-min(img_NCC(:)))./(max(img_NCC(:))-min(img_NCC(:)));
end

function local_sum_I = local_sum(I, T_size)
% Add padding to the image
B = padarray(I, T_size);

% Calculate for each pixel the sum of the region around it,
% with the region the size of the template.
s = cumsum(B,1);
c = s(1+T_size(1):end-1,:)-s(1:end-T_size(1)-1,:);
s = cumsum(c,2);
local_sum_I = s(:,1+T_size(2):end-1)-s(:,1:end-T_size(2)-1);
end