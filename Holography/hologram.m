function [] = hologram(res, k, th, p, l, w)
% Generates Gaussian beam hologram
% res(1), res(2) : number of pixels along each dimension
% m : number of grids
% k : grating
% theta : grid orientation
% p : radial order
% l : topological charge
% w : radius
%
% Example
% hologram([1920,1080],20,0,0,[0,1;2,3],1)

grid=size(l);
res([1 2])=fliplr(res);
points=res./grid;
range=res/min(res);

k(1:grid(1), 1:grid(2))=k;
p(1:grid(1), 1:grid(2))=p;
w(1:grid(1), 1:grid(2))=w;
th(1:grid(1), 1:grid(2))=th;
x=linspace(-range(1), range(1), points(1));
y=linspace(-range(2), range(2), points(2));
[yy,xx]=meshgrid(y,x);

A(points(1), grid(1), points(2), grid(2))=uint8(0);
for i=1:grid(1)
    for j=1:grid(2)
        E=LGBeam(p(i,j), l(i,j), w(i,j), xx, yy);
        A(:,i,:,j)=grating(E, xx, yy, k(i,j), th(i,j), 1);
    end
end
A=reshape(A, res);
imshow(A,'Border','tight','InitialMagnification','fit');
map=gray(256); colormap(map); 

%fullscreen(cat(3,A,A,A), 2);
%imwrite(Hol, map, 'Test.png');
end