function R = laplacian( inputImage, sigma)

     % filters

    Dx = [-1, 0, 1; -1, 0, 1; -1, 0, 1];
    Dy = Dx';
    G = fspecial('gaussian', 3, sigma);
    
    DoGxx = conv2(conv2(G, Dx, 'same'), Dx, 'same');
    DoGyy = conv2(conv2(G, Dy, 'same'), Dy, 'same');
    
    Lxx = conv2(inputImage, DoGxx, 'same');
    Lyy = conv2(inputImage, DoGyy, 'same');

    R = abs(sigma^2 * (Lxx + Lyy));

end

