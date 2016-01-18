function [ hist ] = colorHist( hue )
    
    hist = zeros(1,256);
    
    for value = hue
        bin = floor(value * 255) + 1;
        hist(bin) = hist(bin) + 1;
    end 
end

