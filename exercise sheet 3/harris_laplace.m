function R = harris_laplace( inputImage, scale_level, sigma_0, gSize, t )
                            
    k = 1.4; % suggested step size
    
    % Create scale space
    
    s_i_params = arrayfun( @ (i) sigma_0 * k^i, 1:scale_level );
    
    % Apply Harris to each scale level
        
    harris_f = @ (s_i) multiscale_harris(inputImage, s_i, gSize, t);    
    L_harris = arrayfun(harris_f, s_i_params, 'un',0);
    
    
    
    figure;
    imshow(deepH);
    
    laplace_f = @ (s) laplacian(inputImage, s);
    L_laplacian = arrayfun(laplace_f, s_i_params, 'un',0);
                
    figure;
    for i = 1:size(L_laplacian,2)
        subplot(2,size(L_laplacian,2) / 2,i);
        imshow(cell2mat(L_laplacian(i)));
    end    
    
    figure;
    for i = 1:size(L_harris,2)
        subplot(2,size(L_harris,2) / 2,i);
        imshow(100*cell2mat(L_harris(i)));
    end  
    
end

