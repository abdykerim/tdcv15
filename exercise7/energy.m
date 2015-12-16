function energy = energy(A, r_alpha, r_beta,r_gamma,tx,ty,tz , Mi, mi)

    R_alpha = [ cos(r_alpha) -sin(r_alpha) 0; sin(r_alpha) cos(r_alpha) 0; 0 0 1];
    R_beta = [ cos(r_beta) 0 sin(r_beta); 0 1 0 ; -sin(r_beta) 0 cos(r_beta)];
    R_gamma = [ 1 0 0 ; 0 cos(r_gamma) -sin(r_gamma); 0 sin(r_gamma) cos(r_gamma)];
    R = R_alpha * R_beta * R_gamma;

    res = A * [ R , [tx;ty;tz]]* Mi;
    res(1,:) = res(1,:) ./ res(3,:);
    res(2,:) = res(2,:) ./ res(3,:);
    diffMatrix =res  - mi;
    energy = sum(sum(diffMatrix .* diffMatrix));
end


