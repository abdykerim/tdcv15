function K = gaussian_kernel(dim, sigma)

    ratio_x = floor(dim(1)/2) - (1 - mod(dim(1),2));   
    ratio_y = floor(dim(2)/2) - (1 - mod(dim(2),2));
    
    [X,Y] = meshgrid(-ratio_x : ratio_x , -ratio_y : ratio_y);
    
    % build gaussian filter
    
    K = exp(-(X.^2+Y.^2)/(2*sigma^2));
    
    % normalize
    
    K = K ./ sum(sum(K));
    
end

