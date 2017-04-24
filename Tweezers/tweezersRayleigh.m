function [] = tweezersRayleigh(x0)
% Rayleigh regime 2ka(nt-1)<<1

% Everything is in lambda units
N1=20;   % Quiver points
N2=1024; % Plot points
Lr=10;   % Numerical window (r)
Lz=10;   % Numerical window (z)
w0=1;    % Beam waist
a=0.2;   % Particle radius
K=2;     % relative permitivity
nframes=100000;
d=a*2;
ball=cell(size(x0));

% Physics
function U=field(x)
    zr=pi*w0;
    rho=real(x)/w0;
    xi=1./(1+(imag(x)/zr).^2);
    U=xi.*exp(-2*xi.*rho.^2);
end

function F=gradForce(x)
    zr=pi*w0;
    rho=real(x)/w0;
    xi=1./(1+(imag(x)/zr).^2);
    I=xi.*exp(-2*xi.*rho.^2);
    F=((K-1)/(K+2)*a^3)*I.*(-4/w0*rho.*xi+2i*(imag(x)/zr^2).*(-xi+2*(rho.*xi).^2));
end

% User controls
focus=0;
pos0=0;
move=0;
function []=mousePressed(obj, evnt)
    move=1;
    pos0=get(gca, 'CurrentPoint');
end
function []=mouseReleased(obj, evnt)
    move=0;
end
function []=mouseMove(obj, evnt) 
    if(move)
        pos1=get(gca, 'CurrentPoint');
        dpos=pos1-pos0;
        pos0=pos1;
        b=get(obj,'selectiontype');
        if strcmpi(b,'normal')
            focus=focus+dpos(1,1:2)*[1; 1i];
        elseif strcmpi(b,'alt')
            w0=w0*(1-dpos(1,2)./(2*Lz));
        end
        U=field(rr+1i*zz-focus);
        F=gradForce(rq+1i*zq-focus);
        u=F./abs(F);
        set(img, 'CData', U);
        set(qui, 'UData', real(u));
        set(qui, 'VData', imag(u));
    end
end

% Plots
r=linspace(-Lr,Lr,N2);
z=linspace(-Lz,Lz,N2);
[rr,zz]=meshgrid(r,z);
[rq,zq]=meshgrid(linspace(-Lr,Lr,N1),linspace(-Lz,Lz,N1));
U=field(rr+1i*zz);
F=gradForce(rq+1i*zq);
u=F./abs(F);

figure(1); clf;
set(gcf, 'WindowButtonMotionFcn', @mouseMove);
set(gcf,'WindowButtonDownFcn', @mousePressed);
set(gcf,'WindowButtonUpFcn', @mouseReleased);
hold on;
img=imagesc(r,z,U);
colormap(jet(256)); caxis manual;
qui=quiver(rq,zq,real(u),imag(u),'w');
for i=1:length(x0)
    ball{i}=rectangle('Position',[real(x0(i))-a imag(x0(i))-a d d],'Curvature',[1,1],'FaceColor','g');
end
hold off;
axis equal;
xlim([-Lr,Lr]); ylim([-Lz,Lz]);
set(gcf,'DefaultTextInterpreter','latex');
set(gca,'TickLabelInterpreter','latex','fontsize',14);
xlabel('$x/a$');
ylabel('$z/a$');

% Verlet integration
dt=1;
v0=0;
x1=x0+v0*dt+dt^2/2*gradForce(x0);
for t=1:nframes
    temp=x1;
    x1=2*x1-x0+dt^2*gradForce(x1-focus);
    x0=temp;
    for i=1:length(x0)
        set(ball{i},'Position',[real(x1(i))-a imag(x1(i))-a d d]);
    end
    drawnow;
end
end