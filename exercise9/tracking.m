img = imread('seq\im000.pgm');
img_sav = imshow(img);
hold on;
% x-y plotting
plot(250, 280,'r.','MarkerSize',20); % top left
plot(350, 280,'r.','MarkerSize',20); %top right
plot(250, 380,'r.','MarkerSize',20); %bottom left
plot(350, 380,'r.','MarkerSize',20); %bottom right
saveas(img_sav, sprintf('out/000.jpg'));
close all;

t_coords = [280, 250; 280, 350; 380, 250; 380, 350];
%homogeneous template coords
hom_t_coords = [t_coords'; ones(1, size(t_coords, 1))];

% Calculating all the point coords of the grid and storing them in
% a homogeneous matrix
hom_orig_points = ones(3,441);
x_0 = t_coords(1,2);
y_0 = t_coords(1,1);
y_t = y_0;
c=1;
for q = 1:21
    x_t = x_0;
    for l = 1:21
        hom_orig_points(1:2,c) = [y_t, x_t]; % go horizontal then to the next line
        x_t = x_t + 5;
        c = c+1;
    end
    y_t = y_t + 5;
end
    
% Calculating grid points' intensities from original image
orig_intensities = ones(1,441);
for ii = 1:441
    orig_intensities(1,ii) = img(hom_orig_points(1,ii), hom_orig_points(2,ii));
end
    
% Normalizing original grid points' intensities
orig_intensities = (orig_intensities - mean (orig_intensities(:)) ) / std (orig_intensities(:));

% Load update_matrices into variable A
load('updateMatrices.mat');

H_c = eye(3);
%in the beginning they're same
initial_parameter = hom_t_coords;
current_parameter = hom_t_coords;

for image_number = 1:200
    imname = ['seq\im' sprintf('%03d',image_number) '.pgm'];
    cur_img = imread(imname);
    for a_i = 1:10
        cur_A = A{a_i};
        for times = 1:5
            %current homography
            H_c = dlt(initial_parameter, current_parameter);
            % extracting points from cur image warped
            hom_cur_points  = H_c * hom_orig_points;
            hom_cur_points = hom_cur_points ./ repmat(hom_cur_points(3,:), 3,1);
            % extracting cur img intensities
            cur_img_intensities = ones(1,441);
            for ii = 1:441
                y_i = min(max(round(hom_cur_points(1,ii)), 1),512);
                x_i = min(max(round(hom_cur_points(2,ii)), 1),512);
                cur_img_intensities(1,ii) = cur_img(y_i, x_i);
            end

            % Normalization
            cur_img_intensities = (cur_img_intensities - mean (cur_img_intensities(:)) ) / std (cur_img_intensities(:));
            
            %delta_i calculation
            delta_i = cur_img_intensities(:) - orig_intensities(:);
            
            %delta_p calculation and making it homogeneous
            delta_p = cur_A * delta_i;
            P1 = delta_p(1:4,1);
            P2 = delta_p(5:8,1);
            hom_P = [P1 P2 ones(4,1)];
            hom_P = current_parameter + hom_P' - [zeros(4, 1) zeros(4, 1) ones(4,1)]';
            
            % update homography
            H_u = dlt(current_parameter, hom_P);
            
            %new homography
            H_n = H_c * H_u;
            
            % Compute the new parameter vector based on the new homography.
            new_parameter = H_n * initial_parameter;
            new_parameter = new_parameter ./ repmat( new_parameter(3,:), 3, 1 );

            current_parameter = new_parameter;
        end % end of times loop
        
    end % end of a_i loop
    
    %next image will use previous image params
    initial_parameter = current_parameter;
    hom_orig_points = hom_cur_points;
    
    %plotting 
    pos = round(initial_parameter(1:2,:));
    img_sav = imshow(cur_img);
    hold on;
    % x-y plotting
    plot(pos(2,1), pos(1,1),'r.','MarkerSize',20); % top left
    plot(pos(2,2), pos(1,2),'r.','MarkerSize',20); %top right
    plot(pos(2,3), pos(1,3),'r.','MarkerSize',20); %bottom left
    plot(pos(2,4), pos(1,4),'r.','MarkerSize',20); %bottom right
    saveas(img_sav, sprintf('out/%03d.jpg', image_number));
    close all;
end % end of image_number loop