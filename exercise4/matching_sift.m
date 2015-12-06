Ia_orig = imread('test_pot1.jpg') ;
Ia = im2single(rgb2gray(Ia_orig)) ;
[fa,da] = vl_sift(Ia) ; 

Ib_orig = imread('pot.jpg') ;
Ib = im2single(rgb2gray(Ib_orig)) ;
[fb,db] = vl_sift(Ib) ;

[matches, scores] = vl_ubcmatch(da, db, 6.9); % 6.9 best threshold for shell pic

figure('Name', 'SIFT') ; clf ;
C = padarray(Ia_orig, [0 size(Ib_orig,2)], 'post');
C(1:size(Ib_orig, 1), (1+size(Ia_orig, 2)):(size(Ia_orig, 2)+size(Ib_orig,2)), 1:size(Ia_orig, 3)) = Ib_orig;
imagesc(C) ;

xa = fa(1,matches(1,:)) ;
xb = fb(1,matches(2,:)) + size(Ia,2) ;
ya = fa(2,matches(1,:)) ;
yb = fb(2,matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(fa(:,matches(1,:))) ;
fb(1,:) = fb(1,:) + size(Ia,2) ;
vl_plotframe(fb(:,matches(2,:))) ;
axis image off ;