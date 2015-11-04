function image_out = bilateral_filter( img, dim, sigma_r, sigma_d)

    im_size = size(img);
    img_width = im_size(1);
    img_height = im_size(2);
    
    center_i = floor(dim / 2);
    center_j = floor(dim / 2);

    image_out = [img_width, img_height];
    padImg = padarray(img, [center_i, center_j], 'replicate', 'both');
    
    masks = im2col(padImg, [dim,dim], 'sliding');
        
    for i = 1: img_width 
        for j = 1 : img_height
            
            s = 0;
            s_w = 0;
            
            for k = 1:dim
                for l = 1 : dim
                                       
                    start_index = ((i-1)*img_width+j);
                    
                    mask = masks(1:dim*dim, start_index:start_index);                    
                    mask_matrix = reshape(mask, [dim dim]);
                    
                    r = -(mask_matrix(center_i, center_j) - mask_matrix(k,l))^2 / (2*sigma_r^2);
                    d = -((center_i-k)^2 + (center_j-l)^2) / ((2*sigma_d^2));
                    w = exp( d + r);
                    s = s + mask_matrix(k,l) * w;
                    s_w = w;
                end
            end
            
            image_out(i,j) = s / s_w;
        end
    end
end
