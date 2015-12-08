function out = gaussian_noise(im, p4, p3)
    
    out = im + sqrt(p4)*randn(size(im)) + p3;  
end
