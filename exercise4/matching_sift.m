Ia_orig = imread('test_pot1.jpg') ;
Ia = im2single(rgb2gray(Ia_orig)) ;
[fa,da] = vl_sift(Ia) ; 
%[fa,da] = vl_sift(Ia, 'PeakThresh', 0.0001) ;
% perm = randperm(size(fa,2)) ;
% sel = perm(1:size(fa,2)) ;
% imagesc(Ia_orig);
% h1 = vl_plotframe(fa(:,sel)) ;
% h2 = vl_plotframe(fa(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;
% h3 = vl_plotsiftdescriptor(da(:,sel),fa(:,sel)) ;
% set(h3,'color','g') ;

Ib_orig = imread('pot.jpg') ;
Ib = im2single(rgb2gray(Ib_orig)) ;
[fb,db] = vl_sift(Ib) ;
%[fb,db] = vl_sift(Ib, 'PeakThresh', 0.0001) ;
% perm2 = randperm(size(fb,2)) ;
% sel2 = perm2(1:50) ;
% h12 = vl_plotframe(fb(:,sel2)) ;
% h22 = vl_plotframe(fb(:,sel2)) ;
% set(h12,'color','k','linewidth',3) ;
% set(h22,'color','y','linewidth',2) ;

[matches, scores] = vl_ubcmatch(da, db, 2.5); % 6.9

% [drop, perm] = sort(scores, 'descend') ;
% matches = matches(:, perm) ;
% scores  = scores(perm) ;

figure(1) ; clf ;
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
