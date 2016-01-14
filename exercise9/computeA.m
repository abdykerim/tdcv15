function [ A ] = computeA( img, t_coords, range_mult)

    %norm_img = (img - mean (img(:)) ) / std (img(:));
     
    count_j = 0;
    % Calculating all the point coords of the grid and storing them in 
    % a homogeneous matrix
    hom_orig_points = ones(3,441);
    x_0 = t_coords(1,1);
    y_0 = t_coords(1,2);
    y_t = y_0;
    c=1;
    for k = 1:21
        x_t = x_0;
        for l = 1:21
            hom_orig_points(1:2,c) = [x_t,y_t];
            x_t = x_t + 5;
            c = c+1;
        end
        y_t = y_t + 5;
    end
    % Calculating grid points' intensities (21x21) from original image
    orig_intensities = ones(21,21); 
    for j = t_coords(1,2):5:t_coords(1,2)+100
        count_j = count_j+1;
        count_i = 0;
        for i = t_coords(1,1):5:t_coords(1,1)+100
            count_i = count_i+1;
            orig_intensities(count_j, count_i) = img(j, i);
        end
    end
    
    % Normalizing original grid points' intensities
    orig_intensities = (orig_intensities - mean (orig_intensities(:)) ) / std (orig_intensities(:));
    % TODO: in the steps above is normalizing image first and taking grid
    % points == taking grid points and normalizing them?
    
    n_g = 441; %441 gridpoints
    n = n_g * 2; % n >= number_of_gridpoints
    I = ones(n_g,n);
    P = ones(8,n);
    range = range_mult * 3;
    for w = 1:n
        
        % Generating random displacement
        rand_displacement = round(rand(4,2)*range*2 - range);
        rand_t_coords = t_coords + rand_displacement;

        % Homogeneous coordinates
        hom_t_coords = [t_coords'; ones(1, size(t_coords, 1))];
        hom_rand_t_coords = [rand_t_coords'; ones(1, size(rand_t_coords, 1))];
        % Applying DLT to get homography
        H = dlt(hom_rand_t_coords, hom_t_coords);

        %warped_img = imwarp(img, projective2d(H'));
        %figure, imshow(warped_img);
        
        % Backwarping
        %TODO: but the backwarped image is not the same size anymore.
        % how to determine:
        % "The location the back-warped point hits determines the intensity of
        % the point in the warped patch"????
        H_inv = inv(H);
        %back_warped_img = imwarp(warped_img, projective2d(H_inv'));
        %figure, imshow(backwarped);
        %TODO: NOT SURE ABOUT NEXT THREE LINES!
        % IS THIS HOW I AM SUPPOSED TO CALCULATE BACKWARP COORDS???
        hom_back_warp_points = H_inv * hom_orig_points;
        hom_back_warp_points = hom_back_warp_points ./ repmat(hom_back_warp_points(3,:), 3,1);
        back_warp_points = round(hom_back_warp_points(1:2,:));
        back_warp_points = back_warp_points';
        
        backwarped_intensities = ones(21,21);
        k=1;
        for j = 1:21
            for i = 1:21
                backwarped_intensities(j,i) = img(back_warp_points(k,1), back_warp_points(k,2));
                k = k + 1;
            end
        end

        % Normalization
        backwarped_intensities = (backwarped_intensities - mean (backwarped_intensities(:)) ) / std (backwarped_intensities(:));

        % Adding random noise
        backwarped_intensities = imnoise(backwarped_intensities,'gaussian',0,rand(1)/1000);
        
        % Calculating I and P
        I (:,w) = orig_intensities(:) - backwarped_intensities(:);
        P (:,w) = t_coords(:) - rand_t_coords(:);
        
        
    end %w

    %A = P * transpose(I) * inv((I * transpose(I)));
    A = P * transpose(I) / (I * transpose(I));
end

