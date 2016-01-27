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
tic;
% SSD
% calculate correlation in frequency domain
FT = fft2(rot90(T,2), outsize(1), outsize(2));
FI = fft2(I, outsize(1), outsize(2));
Icorr = real(ifft2(FI.* FT));

% Calculate Local Quadratic sum of Image and Template
localQSumI = local_sum(I.*I, T_size);
QSumT = sum(T(:).^2);

% SSD between template and image
% SSD = I^2 + T^2 - 2*C(I,T), it is much faster than direct
% application of the formula in the exercise pdf
img_SSD = localQSumI+QSumT-2*Icorr;

% Normalize to range 0..1
img_SSD = img_SSD-min(img_SSD(:));
img_SSD = 1-(img_SSD./max(img_SSD(:)));

% Remove padding
img_SSD = unpadarray(img_SSD, size(I));
toc

tic;
% NCC
%normalizing
T_norm = normalize(T);
I_norm = normalize(I);

% % C(I_norm,T_norm)
% % fast and correct, need to check, there might be bugs
% FT2 = fft2(rot90(T_norm,2), outsize(1), outsize(2));
% FI2 = fft2(I_norm, outsize(1), outsize(2));
% img_NCC = real(ifft2(FI2.* FT2));

% very slow! directly formula from exercise pdf
img_NCC = correlate( T_norm, I_norm );
img_NCC = normalize(img_NCC);

% % from web, I don't completely understand what's happening, but very fast
% % and correct
% % % % % % Normalized cross correlation STD
% % % % % LocalSumI = local_sum(I_norm, T_size);
% % % % %
% % % % % % Standard deviation
% % % % % stdI = sqrt(max(localQSumI-(LocalSumI.^2)/numel(T),0) );
% % % % % stdT = sqrt(numel(T)-1)*std(T(:));
% % % % %
% % % % % % Mean compensation
% % % % % meanIT = LocalSumI*sum(T(:))/numel(T);
% % % % % img_NCC= 0.5+(Icorr-meanIT)./ (2*stdT*max(stdI,stdT/1e5));
% Remove padding
img_NCC = unpadarray(img_NCC, size(I));
toc
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