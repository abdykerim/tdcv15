function R = harris_laplace( inputImage, scale_level, sigma_0, k, gSize, t )
                         
    % Create scale space
    
    s_i_params = arrayfun( @ (i) sigma_0 * k^i, 0:scale_level );
    
    % Apply Harris to each scale level
        
    harris_f = @ (s_i) multiscale_harris(inputImage, s_i, gSize, t);    
    L_harris = arrayfun(harris_f, s_i_params, 'un',0);
        
    laplace_f = @ (s) laplacian(inputImage, s, t);
    L_laplacian = arrayfun(laplace_f, s_i_params, 'un',0);
    
    feature_points = cell2mat(arrayfun(@ (H) find(H{1}), L_harris, 'un',0)');
    
    l_values = arrayfun(@ (i) ...
        cell2mat(arrayfun(@ (L) L{1}(i), L_laplacian, 'un',0)) ...
        , feature_points, 'un',0);
    
    laplacianMaxs = cell2mat(arrayfun(@ (data) ...
        ~isempty( findpeaks(data{1})), l_values, 'un',0));
    
    R = feature_points(laplacianMaxs);
    
end

