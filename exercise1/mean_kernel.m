function K = mean_kernel(dim)
    
    K = ones(dim,dim);
    
    % normalize
    
    K = K ./ dim^2;
    
end

