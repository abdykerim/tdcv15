function H = dlt( pts_0, pts_1 )

% normalize

[nrm_pt0, T0] = dlt_normalization(pts_0);
[nrm_pt1, T1] = dlt_normalization(pts_1);

% buid A

A = [];

x = nrm_pt1(1,:);
y = nrm_pt1(2,:);
w = nrm_pt1(3,:);

for i = 1:size(pts_0,2)
    A = [ A;
          zeros(3,1)'           -w(i)*nrm_pt0(:,i)'   y(i)*nrm_pt0(:,i)';
          w(i)*nrm_pt0(:,i)'   zeros(3,1)'           -x(i)*nrm_pt0(:,i)'];
end

% solve for H

[U,D,V] = svd( A );
H = reshape( V(:,9), 3, 3 )';

%denormalize

H = (T1\H)*T0;
H = H / H(3,3);

end

