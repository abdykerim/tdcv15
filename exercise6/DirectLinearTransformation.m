function h = DirectLinearTransformation(p1,p2)

% Convert to homogeneous coordinates.
if (size(p1,1) ~= 3)
    p1 = padarray(p1,[1 0],1,'post');
    p2 = padarray(p2,[1 0],1,'post');
end

% Normalization
[p1,t1] = normalize(p1);
[p2,t2] = normalize(p2);

x2 = p2(1,:);
y2 = p2(2,:);
z2 = p2(3,:);

a = [];

% Build A matrix
for i=1:size(p1,2)
    a = [a; ...
         zeros(3,1)'     -z2(i)*p1(:,i)'   y2(i)*p1(:,i)'; ...
         z2(i)*p1(:,i)'   zeros(3,1)'     -x2(i)*p1(:,i)'];
        %-y2*p1     x2*p1      zeros(1,3)
end

[u,d,v] = svd(a);

h = reshape(v(:,9),3,3)';

% Denormalization
h = inv(t2) * h * t1;

