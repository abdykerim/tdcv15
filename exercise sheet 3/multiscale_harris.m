function R = multiscale_harris( inputImg, sigma_i, gaussianSize, threshold)

    alpha = 0.06;
    s = 0.7;

    % filters

    Dx = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    Dy = Dx';
        
    sigma_d = s * sigma_i;
    
    Gd = fspecial('gaussian', round(3 * sigma_d), sigma_d);
    Gi = fspecial('gaussian', round(gaussianSize * sigma_i), sigma_i);
    Gi_norm = (sigma_d^2) * Gi;

    % compute autocorrelation matrix
    
%     DoGx = conv2(Gd, Dx, 'same');
%     DoGy = conv2(Gd, Dy, 'same');
%     
%     Lx = conv2(inputImg, DoGx, 'same');
%     Ly = conv2(inputImg, DoGy, 'same');
% 
%     L2x = Lx .* Lx;
%     L2y = Ly .* Ly;
%     Lxy = Lx .* Ly;
% 
%     L2x_g = conv2(L2x, Gi_norm, 'same');
%     L2y_g = conv2(L2y, Gi_norm, 'same');
%     Lxy_g = conv2(Lxy, Gi_norm, 'same');
    
    
    
    I = imgaussfilt(inputImg,sigma_d);
    [Lx, Ly] = imgradientxy(I);
    
    L2x = Lx .* Lx;
    L2y = Ly .* Ly;
    Lxy = Lx .* Ly;
    
    L2x_g = (sigma_d^2) * imgaussfilt(L2x, sigma_i);
    L2y_g = (sigma_d^2) * imgaussfilt(L2y, sigma_i);
    Lxy_g = (sigma_d^2) * imgaussfilt(Lxy, sigma_i);
    

    build_L = @ (h, i, j, k) [h, i; j, k];
    M = arrayfun(build_L, L2x_g, Lxy_g, Lxy_g, L2y_g,'un',0);
    
    % Apply Harris operator
    
    harris = @(M) det(M{1}) - alpha * trace(M{1})^2;
    
    R = arrayfun(harris, M);
    R(R<threshold) = 0;
    R(~imregionalmax(R)) = 0;
    R(R~=0) = 1;
    
end