function [ norm_pts, T ] = dlt_normalization( pts )

% Find centroid

    c = [mean(pts(1,:)), mean(pts(2,:))];
    
    translation = [1  0 -c(1); 0 1 -c(2); 0 0 1];

% Find scale

    centered = translation * pts;
    ecl_dists = sqrt( sum( centered(1:2,:).^2 ));
    s = sqrt(2) / mean(ecl_dists);

% Build transformation matrix

    scale = [s 0 0; 0 s 0; 0 0 1];
    
    T = scale * translation;

% apply transformation

    norm_pts = T * pts;

end

