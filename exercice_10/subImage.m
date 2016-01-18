function [i, x, y] = subImage( hsv_img, center, w, h )
    
    h = floor(h/2) + mod(h,2);
    w = floor(w/2) + mod(w,2);
    x = center(1)-h;
    y = center(2)-w;
    i = hsv_img(center(1)-h:center(1)+h, center(2)-w:center(2)+w, :);

end

