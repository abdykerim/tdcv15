I = imread('ex05/2007_000032.jpg');
%computing integral images
integralImg = integral_images(I);

%allocating cells for variables
node_id = cell(1,10);
c_l = cell(1,10);
c_r = cell(1,10);
t = cell(1,10);
x_0 = cell(1,10);
y_0 = cell(1,10);
z_0 = cell(1,10);
x_1 = cell(1,10);
y_1 = cell(1,10);
z_1 = cell(1,10);
s = cell(1,10);

leaf_id = cell(1,10);
p_x = cell(1,10);
p_y = cell(1,10);

% reading values from files
for f = 1:10
    fid=fopen(sprintf('ex05/Tree%d.txt', f-1), 'rt');
    % this is error message for reading the file
    if fid == -1
        error('File could not be opened, check name or path.')
    end
    %
    tline = fgetl(fid);
    n = sscanf(tline,'%d');
    args_n = zeros(1,11);
    node_id{f} = zeros(1,n);
    c_l{f} = zeros(1,n);
    c_r{f} = zeros(1,n);
    t{f} = zeros(1,n);
    x_0{f} = zeros(1,n);
    y_0{f} = zeros(1,n);
    z_0{f} = zeros(1,n);
    x_1{f} = zeros(1,n);
    y_1{f} = zeros(1,n);
    z_1{f} = zeros(1,n);
    s{f} = zeros(1,n);
    for i = 1:n
        line = fgetl(fid);
        % reads a line of data from file.
        args_n(1, :) = sscanf(line, '%d %d %d %f %d %d %d %d %d %d %d');
        node_id{f}(i) = args_n(1,1);
        c_l{f}(i) = args_n(1,2);
        c_r{f}(i) = args_n(1,3);
        t{f}(i) = args_n(1,4);
        x_0{f}(i) = args_n(1,5);
        y_0{f}(i) = args_n(1,6);
        z_0{f}(i) = args_n(1,7);
        %assigning correct rbg channel values
        if z_0{f}(i) == 3 || z_0{f}(i) == 2
            z_0{f}(i) = 1;
        elseif z_0{f}(i) == 1
            z_0{f}(i) = 2;
        elseif z_0{f}(i) == 0
            z_0{f}(i) = 3;
        end
        x_1{f}(i) = args_n(1,8);
        y_1{f}(i) = args_n(1,9);
        z_1{f}(i) = args_n(1,10);
        %assigning correct rbg channel values
        if z_1{f}(i) == 3 || z_1{f}(i) == 2
            z_1{f}(i) = 1;
        elseif z_1{f}(i) == 1
            z_1{f}(i) = 2;
        elseif z_1{f}(i) == 0
            z_1{f}(i) = 3;
        end
        s{f}(i) = args_n(1,11);
    end
    tline = fgetl(fid);
    m = sscanf(tline,'%d');
    args_m = zeros(1,3);
    leaf_id{f} = zeros(1,m);
    p_x{f} = zeros(1,m);
    p_y{f} = zeros(1,m);
    for j = 1:m
        line = fgetl(fid);
        % reads a line of data from file.
        args_m(1,:) = sscanf(line, '%d %f %f');
        leaf_id{f}(j) = args_m(1,1);
        p_x{f}(j) = args_m(1,2);
        p_y{f}(j) = args_m(1,3);
    end
    fclose(fid);
end
tic;

%testing with forest
imHeight = size(I,1);
imWidth = size(I,2);
heat_map = zeros(imHeight, imWidth);
tree_num = 10;
for row = 1:imHeight
    for col = 1:imWidth
        sum_px = 0;
        sum_py = 0;
        for tree = 1:tree_num
            %trying to reach leaf node
            cur_node_id = 0;
            cur_leaf_node = -1;
            while (cur_node_id > -1)
                %computing b_0
                fix_cur_node_id = cur_node_id + 1;
                index_x_0 = getIndexInIntegral(col) + x_0{tree}(fix_cur_node_id);
                index_y_0 = getIndexInIntegral(row) + y_0{tree}(fix_cur_node_id);
                cur_s = s{tree}(fix_cur_node_id);
                cur_z_0 = z_0{tree}(fix_cur_node_id);
                
                y0PlusS = max(min(index_y_0 + cur_s,size(integralImg,1)), 1);
                x0PlusS = max(min(index_x_0 + cur_s,size(integralImg,2)), 1);
                y0MinusS = max(min(index_y_0 - cur_s,size(integralImg,1)), 1);
                x0MinusS = max(min(index_x_0 - cur_s,size(integralImg,2)), 1);
                
                b_0 = integralImg(y0PlusS, x0PlusS, cur_z_0)...
                    - integralImg(y0MinusS, x0PlusS, cur_z_0)...
                    - integralImg(y0PlusS, x0MinusS, cur_z_0)...
                    + integralImg(y0MinusS, x0MinusS, cur_z_0);
                
                %computing b_1
                index_x_1 = getIndexInIntegral(col) + x_1{tree}(fix_cur_node_id);
                index_y_1 = getIndexInIntegral(row) + y_1{tree}(fix_cur_node_id);
                cur_z_1 = z_0{tree}(fix_cur_node_id);
                
                y1PlusS = max(min(index_y_1 + cur_s,size(integralImg,1)), 1);
                x1PlusS = max(min(index_x_1 + cur_s,size(integralImg,2)), 1);
                y1MinusS = max(min(index_y_1 - cur_s,size(integralImg,1)), 1);
                x1MinusS = max(min(index_x_1 - cur_s,size(integralImg,2)), 1);
                
                b_1 = integralImg(y1PlusS, x1PlusS, cur_z_0)...
                    - integralImg(y1MinusS, x1PlusS, cur_z_0)...
                    - integralImg(y1PlusS, x1MinusS, cur_z_0)...
                    + integralImg(y1MinusS, x1MinusS, cur_z_0);
                
                cur_t = t{tree}(fix_cur_node_id);
                cur_c_l = c_l{tree}(fix_cur_node_id);
                cur_c_r = c_r{tree}(fix_cur_node_id);
                
                % decide whether to go to c_l or c_l
                if (b_0 - b_1) < cur_t
                    cur_node_id = cur_c_l;
                else
                    cur_node_id = cur_c_r;
                end
                
                %check whether the next node < 1
                if cur_node_id < 1
                    cur_leaf_node =  abs(cur_node_id); % leaf node is reached
                    cur_node_id = -1; % to exit while loop
                end
            end %end of while loop
            
            %leaf node is found; compute px and py
            sum_px = sum_px + p_x{tree}(cur_leaf_node + 1);
            sum_py = sum_py + p_y{tree}(cur_leaf_node + 1);
        end % end of tree loop
        
        avg_px = round(sum_px/tree_num);
        avg_py = round(sum_py/tree_num);
        xIndex = row + avg_px;
        yIndex = col + avg_py;
        if (xIndex> 0 && yIndex > 0 && xIndex <= imHeight && yIndex <= imWidth)
            heat_map(xIndex, yIndex) = heat_map(xIndex, yIndex) + 1;
        end
    end % end of y loop
end % end of x loop
toc
figure('Name', 'Heat Map'),imshow(heat_map,[]);
% drawing max point of heat map onto the image
[rowMax, columnMax] = find(heat_map == max(max(heat_map)));
figure(2), imagesc(I), axis image, colormap(gray), hold on
plot(columnMax,rowMax,'gs'), title('Center of the plane');