function [] = hologram(N, m, theta, p, l, w)
% Generates Gaussian beam hologram
% N(1), N(2) : number of pixels along each dimension
% m : number of grids
% k : grid orientation
% p : radial Order
% l : topological charge
% w : radius
grid=size(l);
N([1 2])=fliplr(N);
points=N./grid;
range=N/min(N);

p(1:grid(1), 1:grid(2))=p; 
w(1:grid(1), 1:grid(2))=w;
x=linspace(-range(1), range(1), points(1));
y=linspace(-range(2), range(2), points(2));
[yy,xx]=meshgrid(y,x);

A(points(1), grid(1), points(2), grid(2))=uint8(0);
for i=1:grid(1)
    for j=1:grid(2)
        E=HGBeam(p(i,j), l(i,j), w(i,j), xx, yy);
        A(:,i,:,j)=planeWave(E, xx, yy, m, theta, 0);
    end
end
A=reshape(A, N);
figure(2); imshow(A,'Border','tight','InitialMagnification','fit');
map=gray(256); colormap(map); 

%fullscreen(cat(3,A,A,A), 2);
%imwrite(Hol, map, 'Test.png');
end