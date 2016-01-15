function [ A ] = computeA( img, t_coords, range)

    % Calculating all the point coords of the grid and storing them in 
    % a homogeneous matrix
    hom_orig_points = ones(3,441);
    x_0 = t_coords(1,2);
    y_0 = t_coords(1,1);
    y_t = y_0;
    c=1;
    for k = 1:21
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
    
    n_g = 441; %441 gridpoints
    n = 4000; % n > number_of_gridpoints
    I = ones(n_g,n);
    P = ones(8,n);

    for w = 1:n
        % Generating random displacement
        rand_displacement = rand(4,2)*range*2 - range;
        rand_t_coords = t_coords + rand_displacement;

        % Homogeneous coordinates
        hom_t_coords = [t_coords'; ones(1, size(t_coords, 1))];
        hom_rand_t_coords = [rand_t_coords'; ones(1, size(rand_t_coords, 1))];
        % Applying DLT to get homography
        H = dlt(hom_t_coords, hom_rand_t_coords);
        
        % Backwarping
        % H_inv = inv(H);
        % hom_back_warp_points  = H_inv * hom_orig_points;
        hom_back_warp_points  = H \ hom_orig_points;
        hom_back_warp_points = hom_back_warp_points ./ repmat(hom_back_warp_points(3,:), 3,1);

        backwarped_intensities = ones(1,441); 
        for ii = 1:441
            y_i = min(max(round(hom_back_warp_points(1,ii)), 1),512);
            x_i = min(max(round(hom_back_warp_points(2,ii)), 1),512);
            backwarped_intensities(1,ii) = img(y_i, x_i);
        end
        % Normalization
        backwarped_intensities = (backwarped_intensities - mean (backwarped_intensities(:)) ) / std (backwarped_intensities(:));

        % Adding random noise
        rand_noise = 0.002.*rand(1, size(backwarped_intensities,2)) -0.001;
        backwarped_intensities = backwarped_intensities + rand_noise;
        
        % Calculating I and P
        I (:,w) = backwarped_intensities(:) - orig_intensities(:);
        P (:,w) = rand_t_coords(:) - t_coords(:);  
    end %w

    %A = P * transpose(I) * inv((I * transpose(I)));
    A = (P * I.') / (I * I.');
end
