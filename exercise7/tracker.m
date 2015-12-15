close all;
clear;

imgpath = 'img_sequence\';
outpath = 'output\';

I_0 = im2single(rgb2gray(imread([imgpath '0000.png'])));

% Initial rotation and translation
R_0 = eye(3);
T_0 = [0 0];

% Camera intrinsic parameters
A = [472.3  0.64  329.0;
     0      471.0 268.3;
     0      0     1    ]; 

 % find feature points
[f_0, d_0] = vl_sift(I_0, 'PeakThresh', 0.03, 'EdgeThresh', 2);

% Initial object coordinates
m_0 = [f_0(1:2,:); ones(1, size(f_0, 2))];
M_0 = A \ m_0;

fig = figure('Visible','off');
v = VideoWriter(fullfile(outpath, 'matcher.avi'),'Uncompressed AVI');
open(v);

% find correspondences
for i=1:44
    
    imname = [sprintf('%04d',i) '.png'];
    
    I_t = im2single(rgb2gray(imread([imgpath imname])));
    [f_t, d_t] = vl_sift(I_t, 'PeakThresh', 0.03, 'EdgeThresh', 2);
    [matches, scores] = vl_ubcmatch(d_0, d_t, 15);
        
    display_img = padarray(I_0, [0 size(I_t, 2)], 'pre');
    display_img(1:size(I_t, 1), 1:size(I_t, 2)) = I_t;
    
    f_o = bsxfun(@plus,f_0,[size(I_t, 2) 0 0 0]');    
    matches_x = [f_o(1,matches(1,:)); f_t(1,matches(2,:))];
    matches_y = [f_o(2,matches(1,:)); f_t(2,matches(2,:))];
    
    imshow(display_img);
    set(vl_plotframe(f_o),'color','g', 'linewidth', 1);
    set(vl_plotframe(f_t),'color','y', 'linewidth', 1);
    set(line(matches_x, matches_y),'color',[1 0.5 0.2]);
    
    saveas(fig, fullfile(outpath, imname), 'jpg');
    writeVideo(v, getframe(fig));
end

close(v);






