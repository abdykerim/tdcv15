function out = gaussian_filter(im, dim, sigma)

    ratio_x = floor(dim(1)/2) - (1 - mod(dim(1),2));   
    ratio_y = floor(dim(2)/2) - (1 - mod(dim(2),2));
    if ratio_x == floor(dim(1)/2)
        [X,Y] = meshgrid(-ratio_x : ratio_x , -ratio_y : ratio_y);
    else
        [X,Y] = meshgrid(-ratio_x : ratio_x+1 , -ratio_y : ratio_y+1);
    end
    
    % build gaussian filter
    G = exp(-(X.^2+Y.^2)/(2*sigma^2));
    
    % normalize
    G = G ./ sum(sum(G));
    
    %// Convert filter into a column vector
    G = G(:);

    %// Filter our image
    I_pad = padarray(im, [floor(dim(1)/2) floor(dim(2)/2)], 'symmetric', 'both');
    C = im2col(I_pad, [dim(1) dim(2)], 'sliding');
    C_filter = sum(bsxfun(@times, C, G), 1);
    out = col2im(C_filter, [dim(1) dim(2)], size(I_pad), 'sliding');  
end
