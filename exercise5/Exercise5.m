clear all
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

%testing with forest
imWidth = size(I,1);
imHeight = size(I,2);
leaf_node_reached = true;
heat_map = zeros(imWidth, imHeight);
for x = 1:imWidth
    for y = 1:imHeight
        %result(x,y) = R(getIndexInIntegral(x), getIndexInIntegral(y))
        sum_px = 0;
        sum_py = 0;
        for tree = 1:10
            %trying to find leaf node
            cur_node_id = 0;
            while (cur_node_id > -1)
                %next_node_id = -1;     
                b_0 = integralImg(getIndexInIntegral(x) + x_0{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_0{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1), z_0{tree}(cur_node_id + 1))...
                    - integralImg(getIndexInIntegral(x)+x_0{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_0{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1), z_0{tree}(cur_node_id + 1))...
                    - integralImg(getIndexInIntegral(x)+x_0{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_0{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1), z_0{tree}(cur_node_id + 1))...
                    + integralImg(getIndexInIntegral(x)+x_0{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_0{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1), z_0{tree}(cur_node_id + 1));

                b_1 = integralImg(getIndexInIntegral(x) + x_1{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_1{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1), z_1{tree}(cur_node_id + 1))...
                    - integralImg(getIndexInIntegral(x)+x_1{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_1{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1), z_1{tree}(cur_node_id + 1))...
                    - integralImg(getIndexInIntegral(x)+x_1{tree}(cur_node_id + 1) + s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_1{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1), z_1{tree}(cur_node_id + 1))...
                    + integralImg(getIndexInIntegral(x)+x_1{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1),...
                    getIndexInIntegral(y)+y_1{tree}(cur_node_id + 1) - s{tree}(cur_node_id + 1), z_1{tree}(cur_node_id + 1));
                
                if b_0 - b_1 < t
                    cur_node_id = c_l{tree}(cur_node_id + 1);
                else cur_node_id = c_r{tree}(cur_node_id + 1);
                end
            end %end of while loop
            
        %leaf node is found
        sum_px = sum_px + p_x{tree}(abs(cur_node_id) + 1);
        sum_py = sum_py + p_y{tree}(abs(cur_node_id) + 1);
        end % end of tree loop
        avg_px = sum_px/10;
        avg_py = sum_py/10;
        heat_map(x+avg_px, y+avg_py) = heat_map(x+avg_px, y+avg_py) + 1; 
    end % end of y loop
end % end of x loop

