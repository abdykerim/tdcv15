function [ A ] = computeA( img, t_coords, range_mult)

    %norm_img = (img - mean (img(:)) ) / std (img(:));
    % Calculating grid points' intensities (20x20) from original image 
    count_j = 0;
    orig_intensities = ones(21,21); 
    for j = t_coords(1,2):5:t_coords(1,2)+99
        count_j = count_j+1;
        count_i = 0;
        for i = t_coords(1,1):5:t_coords(1,1)+99
            count_i = count_i+1;
            orig_intensities(count_j, count_i) = img(j, i);
        end
    end
    % Normalizing original grid points' intensities
    orig_intensities = (orig_intensities - mean (orig_intensities(:)) ) / std (orig_intensities(:));
    % TODO: in the steps above is normalizing image first and taking grid
    % points == taking grid points and normalizing them?
    
    
    n = 441; % 441 gridpoints, n >= number_of_gridpoints
    I = ones(441,n);
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
        H = dlt(hom_t_coords, hom_rand_t_coords);

        warped_img = imwarp(img, projective2d(H'));
        %figure, imshow(warped_img);
        
        % Backwarping
        %TODO: but the backwarped image is not the same size anymore.
        % how to determine:
        % "The location the back-warped point hits determines the intensity of
        % the point in the warped patch"????
        H_inv = inv(H);
        back_warped_img = imwarp(warped_img, projective2d(H_inv'));
        %figure, imshow(backwarped);
        %TODO: NOT SURE ABOUT NEXT THREE LINES!
        % IS THIS HOW I AM SUPPOSED TO CALCULATE BACKWARP COORDS???
        %hom_back_warp_coords = H_inv * hom_t_coords;
        hom_back_warp_coords = H \ hom_t_coords;
        back_warp_coords = round(hom_back_warp_coords(1:2,:));
        back_warp_coords = back_warp_coords';
        count_j = 0;
        warped_intensities = ones(21,21);
        for j = back_warp_coords(1,2):5:back_warp_coords(1,2)+100
            count_j = count_j+1;
            count_i = 0;
            for i = back_warp_coords(1,1):5:back_warp_coords(1,1)+100
                count_i = count_i+1;
                warped_intensities(count_j, count_i) = back_warped_img(j, i);
            end
        end

        % Normalization
        warped_intensities = (warped_intensities - mean (warped_intensities(:)) ) / std (warped_intensities(:));

        % Adding random noise
        warped_intensities = imnoise(warped_intensities,'gaussian',0,rand(1)/1000);
        
        % Calculating I and P
        I (:,w) = orig_intensities(:) - warped_intensities(:);
        P (:,w) = t_coords(:) - rand_t_coords(:);
        
        
    end %w

    %A = P * transpose(I) * inv((I * transpose(I)));
    A = P * transpose(I) / (I * transpose(I));
end

