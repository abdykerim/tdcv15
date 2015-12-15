function [H, best_sample] = ransac_homography( pts0, pts1, N, t, T, sample_size )

pts_size = size(pts0, 2);
sample_vector = [pts0(:,1:pts_size);pts1(:,1:pts_size)];
try_count = 0;

sample_size = min(sample_size, pts_size);
T = min(T, pts_size);

% Initialize to minimal set of points
rdm_idx = randperm(pts_size);
best_sample = sample_vector(:,rdm_idx(:,1:4));

while N > try_count && size(pts0, 2) > T
    
    rdm_idx = randperm(pts_size);
    sample = sample_vector(:,rdm_idx(:,1:sample_size));
    
    x0 = sample(1:3,:);
    x1 = sample(4:6,:);
    
    % Instantiate the model
    h = dlt(x0, x1);
        
    % Estimate target points
    x1e = h * x0;
    x0e = h \ x1;
    
    % Calculate distances
    for i = 1:size(x0e, 2)
        x0e(:,i) = x0e(:,i)./x0e(3,i);
        x1e(:,i) = x1e(:,i)./x1e(3,i);
    end
    
    dist = sum((x0 - x0e).^2 + (x1 - x1e).^2);
    inliers = find(abs(dist) < t);
    
    % Update best sample
    if(size(inliers,2) > size(best_sample,2))
        best_sample = sample(:,inliers);
    end
    
    % Terminate when a sample good enough is found    
    if(size(best_sample,2) >= T)
        break;
    end
    try_count = try_count + 1;
end

% Re-estimate homography on the best sample

H = dlt(best_sample(1:3,:), best_sample(4:6,:)); 

end

