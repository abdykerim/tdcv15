%close all;
%clear;

imgpath = 'img_sequence\';
outpath = 'output\';

I_0 = im2single(rgb2gray(imread([imgpath '0000.png'])));

% Initial rotation and translation
R_0 = eye(3);
T_0 = [0; 0; 0];
inliers = cell(1,44);

% Camera intrinsic parameters
A = [472.3  0.64  329.0;
     0      471.0 268.3;
     0      0     1    ]; 

 % find feature points
[f_0, d_0] = vl_sift(I_0, 'PeakThresh', 0.03, 'EdgeThresh', 2);

% Initial object coordinates
m_0 = [f_0(1:2,:); ones(1, size(f_0, 2))];
M_0 = A \ m_0;
Ainv = inv(A);
fig = figure('Visible','off');
positions = zeros(44,3);
initVal=double([0,0,0,0,0,0]);
% find correspondences
for i=1:44
    
    imname = [sprintf('%04d',i) '.png'];
    
    I_t = im2single(rgb2gray(imread([imgpath imname])));
    [f_t, d_t] = vl_sift(I_t, 'PeakThresh', 0.03, 'EdgeThresh', 2);
    [matches, scores] = vl_ubcmatch(d_0, d_t, 5);    
        
    display_img = padarray(I_0, [0 size(I_t, 2)], 'pre');
    display_img(1:size(I_t, 1), 1:size(I_t, 2)) = I_t;
    
    if(size(matches, 2) < 4)
        imshow(display_img);
        saveas(fig, fullfile(outpath, imname), 'jpg');
        continue;
    end
    
    obj_pts = [f_0(1,matches(1,:));
           f_0(2,matches(1,:));
           ones(1,size(matches(1,:), 2))];

    scn_pts = [f_t(1,matches(2,:));
           f_t(2,matches(2,:));
           ones(1,size(matches(2,:), 2))];
    
    [Hr, best_sample] = ransac_homography(scn_pts, obj_pts, 10, 0.2, 6, 20);
    
    f_o = bsxfun(@plus,f_0,[size(I_t, 2) 0 0 0]');
    r_matches_x_t = bsxfun(@plus,best_sample(4,:),size(I_t, 2));
    
    r_matches_x = [best_sample(1,:); r_matches_x_t];
    r_matches_y = [best_sample(2,:); best_sample(5,:)];
    
    imshow(display_img);
    set(vl_plotframe(f_o),'color','g', 'linewidth', 1);
    set(vl_plotframe(f_t),'color','y', 'linewidth', 1);
    set(line(r_matches_x, r_matches_y),'color',[0.5 1 0.5]);
    
    saveas(fig, fullfile(outpath, imname), 'jpg');
    
    %calculating the camera position
    % TODO: must be something wrong here, since fminsearch always produces 0
    m_i = double(best_sample(1:3,:));
    inliers{i} = m_i;
    %I am recalculating M_i since we have less points than M_0, so we cannot
    %use M_0
    M_i = A \ m_i;
    M_i_h = double([M_i; ones(1,size(M_i,2))]);
    g = @(p) energy(A,p(1), p(2),p(3), p(4),p(5),p(6), M_i_h,m_i);
    %TODO: this gives 0 at the moment
    res_min = fminsearch(g, initVal);
    initVal = res_min;
    
    positions(i,:)= determineCamCoords(res_min(1), res_min(2),res_min(3), res_min(4:6)');
end
positions = [0 0 0;positions]; 
%positions
figure;
hold on;
grid on;
plot3(positions(:,1),positions(:,2),positions(:,3));
text(positions(:,1),positions(:,2),positions(:,3), num2str((0:i)'))
hold off;






