function U=BesselRing(X,Y,m,kt,delt)
% U=BesselRing(X,Y,m,kt,delt)
% This function generates a ring to create a Bessel beam for a given
% topological charge m, ring radius kt and thickness delt.

THETA=atan2(Y,X);
FCirc = @(x,y,a) 1.*(x.^2 + y.^2<=a.^2);
U = (FCirc(X,Y,kt)-FCirc(X,Y,delt*kt)).*exp(1i.*m.*THETA);