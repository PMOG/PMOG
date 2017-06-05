function U=LG(X,Y,m,r0)
% U=LG(X,Y,r0,m)
% This function computes a LG mode at the plane z=0 with p=0 and arbitrary
% topological charge m and beam waist r0.
    THETA=atan2(Y,X);
    U= ((sqrt(X.^2 + Y.^2)/r0).^(abs(m))) .* exp(-((X.^2 + Y.^2)/(r0^2))) .* exp(1i.*m.*THETA);