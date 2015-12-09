clear all;

scn_img = imread('scene.pgm');
obj_img = imread('box.pgm');

scn_img = im2single(scn_img);
obj_img = im2single(obj_img);

display_img = padarray(scn_img, [0 size(obj_img, 2)], 'pre');
display_img(1:size(obj_img, 1), 1:size(obj_img, 2)) = obj_img;

[f_scn, d_scn] = vl_sift(scn_img);
[f_obj, d_obj] = vl_sift(obj_img);
[matches, scores] = vl_ubcmatch(d_obj, d_scn, 3.5);

shift = size(obj_img, 2);

x0 = f_obj(1,matches(1,:));
y0 = f_obj(2,matches(1,:));
x1 = f_scn(1,matches(2,:)) + shift;
y1 = f_scn(2,matches(2,:));


% Make coordinates homogeneous

obj_pts = [f_obj(1,matches(1,:));
           f_obj(2,matches(1,:));
           ones(1,size(matches(1,:), 2))];

scn_pts = [f_scn(1,matches(2,:));
           f_scn(2,matches(2,:));
           ones(1,size(matches(2,:), 2))];
       

% Find homogaphy transformation H

H = dlt(scn_pts, obj_pts);
corrected_image = imwarp(scn_img, projective2d(H'));
figure('Name', 'DLT - 28 correspondences');
imshow(corrected_image);

% Find homogaphy transformation with RANSAC

Hr = ransac_homography(scn_pts, obj_pts, 10, 0.2, 8, 14);
ransacked = imwarp(scn_img, projective2d(Hr'));
figure('Name', 'RANSAC - manual parameters');
imshow(ransacked);


% Find homogaphy transformation with RANSAC using adaptive parameters

Hr = ransac_adaptive(scn_pts, obj_pts, 0.2, 14);
ransacked = imwarp(scn_img, projective2d(Hr'));
figure('Name', 'RANSAC - adaptive parameters');
imshow(ransacked);

