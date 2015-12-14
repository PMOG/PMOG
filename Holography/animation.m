function [] = animation(Nx, Ny, m, k, p, w)
for i=0:100
    l=mod(i,11)-5;
    hologram(Nx,Ny,m,k,p,l,w);
    pause(.4);
end
end

