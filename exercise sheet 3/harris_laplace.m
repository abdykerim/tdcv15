function R = harris_laplace( inputImage, scale_level, sigma_0, k, t_h, t_l )

    R = [];

    % Apply Harris to each scale level
    
    s_i_params = arrayfun( @ (i) sigma_0 * k^i, 0:scale_level);        
    harris_f = @ (s_i) multiscale_harris(inputImage, s_i, t_h);    
    L_harris = arrayfun(harris_f, s_i_params, 'un',0);
    
    feature_points = arrayfun(@ (H) find(H{1}), L_harris, 'un',0);
    
    w = size(inputImage,2);
    offset_n = [-1, 0, 1];
    offset_m = [-w, 0, w];
    neighborhood = @ (x) inputImage(bsxfun(@plus, (x+offset_n)', offset_m));    
    
    if(scale_level > 0) 
        for n = 1: scale_level

            s_i_params = arrayfun(@ (i) sigma_0 * k^i, max(n-1,0): min(n+1,scale_level));

            for i = 1:size(feature_points{n})

                laplace_f = @ (s) laplacian(neighborhood(feature_points{n}(i)), s);
                L_laplacian = arrayfun(laplace_f, s_i_params, 'un',0);

                current_laplace = laplace_f(sigma_0 * k^n);
                current_value = current_laplace(2,2);

                maxim = arrayfun(@ (lap) max(max(lap{1})), L_laplacian);
                max_3d = max(maxim);

                if(current_value == max_3d)
                    if(current_value > t_l)
                        R(end+1) = feature_points{n}(i);
                    end
                end
            end
        end
    else
        R = feature_points{1};
    end
end


