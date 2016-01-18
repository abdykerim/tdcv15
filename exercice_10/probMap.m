function map = probMap( hue, hist )

    indexes = round(hue * 255) + 1;
    map = hist(indexes);
%     map = map - min(map(:));
    map = map * (256 / max(map(:)));    

end

