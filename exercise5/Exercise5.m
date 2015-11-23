I = imread('ex05/2007_000032.jpg');
[R,G,B] = integral_images(I);
% 
% node_id = cell(1,10);
% c_l = cell(1,10);
% c_r = cell(1,10);
% t = cell(1,10);
% x_0 = cell(1,10);
% y_0 = cell(1,10);
% z_0 = cell(1,10);
% x_1 = cell(1,10);
% y_1 = cell(1,10);
% z_1 = cell(1,10);
% s = cell(1,10);
% 
% leaf_id = cell(1,10);
% p_x = cell(1,10);
% p_y = cell(1,10);
% 
% for f = 1:10
%     fid=fopen(sprintf('ex05/Tree%d.txt', f-1), 'rt');
%     % this is error message for reading the file
%     if fid == -1
%         error('File could not be opened, check name or path.')
%     end
%     %
%     tline = fgetl(fid);
%     n = sscanf(tline,'%d');
%     args_n = zeros(1,11);
%     node_id{f} = zeros(1,n);
%     c_l{f} = zeros(1,n);
%     c_r{f} = zeros(1,n);
%     t{f} = zeros(1,n);
%     x_0{f} = zeros(1,n);
%     y_0{f} = zeros(1,n);
%     z_0{f} = zeros(1,n);
%     x_1{f} = zeros(1,n);
%     y_1{f} = zeros(1,n);
%     z_1{f} = zeros(1,n);
%     s{f} = zeros(1,n);
%     for i = 1:n
%         line = fgetl(fid);
%         % reads a line of data from file.
%         args_n(1, :) = sscanf(line, '%d %d %d %f %d %d %d %d %d %d %d');
%         node_id{f}(i) = args_n(1,1);
%         c_l{f}(i) = args_n(1,2);
%         c_r{f}(i) = args_n(1,3);
%         t{f}(i) = args_n(1,4);
%         x_0{f}(i) = args_n(1,5);
%         y_0{f}(i) = args_n(1,6);
%         z_0{f}(i) = args_n(1,7);
%         x_1{f}(i) = args_n(1,8);
%         y_1{f}(i) = args_n(1,9);
%         z_1{f}(i) = args_n(1,10);
%         s{f}(i) = args_n(1,11);
%     end
%     tline = fgetl(fid);
%     m = sscanf(tline,'%d');
%     args_m = zeros(1,3);
%     leaf_id{f} = zeros(1,m);
%     p_x{f} = zeros(1,m);
%     p_y{f} = zeros(1,m);
%     for j = 1:m
%         line = fgetl(fid);
%         % reads a line of data from file.
%         args_m(1,:) = sscanf(line, '%d %f %f');
%         leaf_id{f}(j) = args_m(1,1);
%         p_x{f}(j) = args_m(1,2);
%         p_y{f}(j) = args_m(1,3);
%     end
%     fclose(fid);
% end