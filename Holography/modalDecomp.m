function [] = modalDecomp(Nx, Ny, p1, l1, p2, l2, w)
x=linspace(-Nx/Ny,Nx/Ny,Nx);
y=linspace(-1,1,Ny);
[xx, yy]=meshgrid(x, y);
E1=LGBeam(p1,l1,w,xx,yy);
E2=LGBeam(p2,l2,w,xx,yy);
E=E1.*conj(E2); 
E_hat=fftshift(fft2(E));
figure(1); colormap(gray(256));
subplot(2,2,1); imagesc(x,y,abs(E1).^2);
subplot(2,2,2); imagesc(x,y,abs(E2).^2);
subplot(2,2,3); imagesc(x,y,abs(E).^2);
subplot(2,2,4); imagesc(x,y,abs(E_hat).^2);
end
