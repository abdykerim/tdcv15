
close all;

image_path = 'sequence/2043_000';
I = imread([image_path '140.jpeg']);
hsv = rgb2hsv(I);
hue_channel = hsv(:,:,1);

center = [325,518];
w = 40;
h = 20;

figure;

for i=141:190
    shift = w + h;
    tries = 0;       
    while(tries < 20 && shift > 1)        
        
        [box,xt,yt] = subImage(hue_channel, center, w, h);
        winPdist = probMap(box, colorHist(box));        
        [X,Y] = size(winPdist);

        M0 = sum(sum(winPdist));    
        Mx = sum((1:X)*winPdist);
        My = sum(winPdist*(1:Y)');
        
        centroid = [round(Mx/M0) round(My/M0)];
        shifted_center = [xt yt] + centroid;
        shift = m_distance(center, shifted_center);
        
        center = shifted_center;
        tries = tries + 1; 
    end
    
    imshow(I);
    r = rectangle('Position', [yt xt w h], 'EdgeColor','g');
    r.LineWidth = 2;
    drawnow;
        
    % update scale
    
    s = 2*sqrt(M0/256);
    w = s;
    h = 0.4 * s;
    
    % load next frame
    
    I = imread([image_path sprintf('%03d',i) '.jpeg']);
    hsv = rgb2hsv(I);
    hue_channel = hsv(:,:,1);
               
end