function R = laplacian( inputImage, sigma, threshold )

     % filters

    Dx = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    Dy = Dx';
    G = fspecial('gaussian', round(3 * sigma), sigma);
    
    DoGxx = conv2(conv2(G, Dx, 'same'), Dx, 'same');
    DoGyy = conv2(conv2(G, Dy, 'same'), Dy, 'same');
    
    Lxx = conv2(inputImage, DoGxx, 'same');
    Lyy = conv2(inputImage, DoGyy, 'same');
    
    R = abs(sigma^2 * (Lxx + Lyy));
    R(R<threshold) = 0;

end

