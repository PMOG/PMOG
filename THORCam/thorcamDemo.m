function []=thorcamDemo(n)
% Captures and displays n frames
w=[0.8 0.7 0.6 0.4 0.3 0.3 0.3 0.3 0.3 0.3 0.3];
hologram([1920, 1080],700,45,0,0,w(1)); drawnow;

% Open camera
[cam, img]=thorcamOpen(1);
try
    % Create figure
    fig=figure(1); clf; colormap(gray(256));
    h=imshow(img.Data','Border','tight','InitialMagnification','fit');

    % Set region of interest
    roi=imrect();
    thorcamStartLive(cam);
    
    
    % Capture and display n frames
    val=zeros(1,n);
    for i=0:n-1
        if(mod(10*i/n, 1)==0)
            l=10*i/n;
            hologram([1920, 1080],700,45,0,l,w(l+1));
        end
        
        tic; img=thorcamGet(cam, img, 0);
        set(h, 'CData', img.Data');
        set(fig,'Name',sprintf('THORCam %i fps', round(1/toc)));
        drawnow;
        mask=createMask(roi);
        val(i+1)=mean(img.Data(mask));
        disp(val(i+1)); 
    end
    thorcamStopLive(cam);
    set(fig, 'Name', 'THORCam not recording');
    figure(3); plot(val);
catch
    disp('Error: you messed up, idiot!');
end
% Stop recording and close camera
thorcamClose(cam);
end