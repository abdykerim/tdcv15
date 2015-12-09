function H = ransac_homography( pts0, pts1, N, t, T, sample_size )

pts_size = size(pts0, 2);

for j = 1 : N
    
    sample = zeros(6,sample_size);
    best_sample = [];
    
    % Select random sample 
    for i = 1:sample_size
        r = ceil((pts_size-i+1).*rand);
        sample(:,i) = [pts0(:,r);pts1(:,r)];
    end
    
    x0 = sample(1:3,:);
    x1 = sample(4:6,:);
    
    % Instantiate the model
    
    h = dlt(x0, x1);
    
    % Calculate distances
    
    x0e = h * x0;
    x1e = h \ x1;
    
%     for i = 1:size(x0e, 2)
%         x0e(:,i) = x0e(:,i)./x0e(3,i);
%         x1e(:,i) = x1e(:,i)./x1e(3,i);
%     end
    
    dist = sum((x0 - x0e).^2 + (x1 - x1e).^2);
    inliers = find(abs(dist) < t * 1.0e+04);
    
    % Update best sample
    
    if(size(inliers,2) > size(best_sample,2))
        if(size(inliers,2) > T)
            best_sample = sample(:,inliers);   
        end
    end
    
    % Terminate when a sample good enough is found
    
    if(size(best_sample,2) >= T)
        break;
    end    
end

% Re-estimate homography on the best sample

H = dlt(best_sample(1:3,:), best_sample(4:6,:)); %%% Index exceeds matrix dimensions non deterministically!!!!

end

