function y = bilateral_filter( im, sigma_d, sigma_r)
       
    [M,N] = size(im);
    y = zeros(size(im));

    r = floor(sigma_d*3/2);     % Adjust for desired window size
    
    im_pad = padarray(im, [r r], 'symmetric', 'both');
    
    for n = 1:N
        for m = 1:M
            % Extract a window of size (2r+1)x(2r+1) around (m,n)
            w = im_pad(m+(0:2*r),n+(0:2*r));
            % The bilateral filter
            [k,j] = meshgrid(-r:r,-r:r);
            h = exp( -(j.^2 + k.^2)/(2*sigma_r^2) ) .* ...
                exp( -(w - w(r+1,r+1)).^2/(2*sigma_d^2) );
            y(m,n) = h(:)'*w(:) / sum(h(:));
        end
    end
end
