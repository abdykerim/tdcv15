function R = multiscale_harris( inputImg, sigma_i, threshold)

    alpha = 0.06;
    s = 0.7;
    
    sigma_d = s * sigma_i;    
    
    I = imgaussfilt(inputImg,sigma_d);
    [Lx, Ly] = imgradientxy(I);
    
    L2x = Lx .* Lx;
    L2y = Ly .* Ly;
    Lxy = Lx .* Ly;
    
    L2x_g = (sigma_d^2) * imgaussfilt(L2x, sigma_i);
    L2y_g = (sigma_d^2) * imgaussfilt(L2y, sigma_i);
    Lxy_g = (sigma_d^2) * imgaussfilt(Lxy, sigma_i);    

    harris = @ (h, i, j, k) det([h, i; j, k]) - alpha * trace([h, i; j, k])^2;
    
    R = cell2mat(arrayfun(harris, L2x_g, Lxy_g, Lxy_g, L2y_g,'un',0));
    R(R<threshold) = 0;
    R = imregionalmax(R);
    
end