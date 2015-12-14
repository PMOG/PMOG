function [ E ] = propagator( E0, lambda, kt, z )
n=-N/2:N/2-1;
omega=2*pi/(b-a)*n;

kz=sqrt((2*pi/lambda)^2-kt'*kt);
U0=E0/sqrt(2*pi);
U0_hat=fft2(U0);
U=ifft2(U0_hat.*exp(1i*z*kz));
E=2*real(U);
end

