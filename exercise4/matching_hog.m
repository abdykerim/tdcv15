close all;

obj = imread('pot.jpg');
obj = imresize(obj,1/8);
obj = im2single(obj) ;
hogCellSize = 8 ;

scene = imread('test_pot1.jpg');
scene = imresize(scene,1/4);
scene = im2single(scene) ;
hog = vl_hog(scene, hogCellSize) ;

scale = 3;
max_old=0;

for i = 1:scale

    w=vl_hog(obj,hogCellSize);
    scores = vl_nnconv(hog, w, []) ;

    [b, bi] = max(scores(:));
    if max_old < b;%*2*i
        max_old = b;%*2*i;
        maxIndex = bi;
        w_size = w;
        scores_size = scores;
    end
    obj = imresize(obj,1/2);
end


[hy, hx] = ind2sub(size(scores_size), maxIndex) ;
x = (hx - 1) * hogCellSize + 1 ;
y = (hy - 1) * hogCellSize + 1 ;

modelWidth = size(w_size, 2) ;
modelHeight = size(w_size, 1) ;
detection = [
  x - 0.5 ;
  y - 0.5 ;
  x + hogCellSize * modelWidth - 0.5 ;
  y + hogCellSize * modelHeight - 0.5 ;] ;

figure ; clf ;
imagesc(scene) ; axis equal ;
hold on ;
vl_plotbox(detection, 'g', 'linewidth', 2) ;
title('Response scores') ;