close all;

hogCellSize = 8 ;
obj = imread('pot.jpg');
obj = imresize(obj,1/8);
obj = im2single(obj) ;
w=vl_hog(obj, hogCellSize);

scene = imread('test_pot1.jpg');
scene = imresize(scene,1/4); %
scene = im2single(scene) ;
final_scene = scene; % to keep the scale with the best match score
scale = 16;
max_old=0;

for i = 1:scale
    hog = vl_hog(scene, hogCellSize) ;

    scores = vl_nnconv(hog, w, []) ;
    [b, bi] = max(scores(:));
    
    if max_old < b
        max_old = b;
        maxIndex = bi;
        final_scene = scene;
        scores_size = scores;
        best_scale = i;
    end
    scene = imresize(scene,0.95);
end
best_scale %printing the best scale

[hy, hx] = ind2sub(size(scores_size), maxIndex) ;
x = (hx - 1) * hogCellSize + 1 ;
y = (hy - 1) * hogCellSize + 1 ;

modelWidth = size(w, 2) ;
modelHeight = size(w, 1) ;
detection = [
  x - 0.5 ;
  y - 0.5 ;
  x + hogCellSize * modelWidth - 0.5 ;
  y + hogCellSize * modelHeight - 0.5 ;] ;

figure('Name','HOG') ; clf ;
imagesc(final_scene) ; axis equal ;
hold on ;
vl_plotbox(detection, 'g', 'linewidth', 2) ;
title('Response scores') ;