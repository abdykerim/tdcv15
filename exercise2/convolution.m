function cnvImg = convolution(img, H, borderTreatment)

    sizeI = size(img);
    sizeH = size(H);
    
    imgHeight = sizeI (1);
    imgWidth = sizeI (2);
    
    padSizeX = floor (sizeH(1) / 2);
    padSizeY = floor (sizeH(2) / 2);
        
    % allocate result matrix
    
    cnvImg = zeros(imgHeight,imgWidth);
        
    
    % border treatment    
    
    if(borderTreatment == 'm') % mirroring         
        padImg = padarray(img, [padSizeX, padSizeY], 'symmetric', 'both');           
    else % clamping  
        padImg = padarray(img, [padSizeX, padSizeY], 'replicate', 'both');
    end
    
    % convolution operation
    % TODO do we need to invert mask?
    for i = 1 : imgHeight
        for j = 1 : imgWidth
            for h_i = 1 : sizeH(1)
                for h_j = 1 : sizeH(2)
                   cnvImg(i,j) = cnvImg(i,j) + H(h_i,h_j) * padImg(i+h_i-1,j+h_j-1);
                end
            end
        end
    end  
    
end