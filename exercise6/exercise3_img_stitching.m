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

imshow(display_img);
hold on;
h = line([x0 ; x1], [y0 ; y1]);
axis image off;

