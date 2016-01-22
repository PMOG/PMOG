function [F1, F2] = TransformBeam(A, E1, E2)
% Transforms vectorial beam E=[E1; E2] according to equation F=A*E
F1=A(1,1)*E1+A(1,2)*E2;
F2=A(2,1)*E1+A(2,2)*E2;
end