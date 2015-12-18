function []=thorcamDemo(m, n)
% Generates a series of holograms with charges given by m(i)
% Capturing n frames
w=0.5;
hologram([1920, 1080],500,0,0,m(1),w(1)); drawnow;

% Open camera
[cam, img]=thorcamOpen(1);
try
    % Create figure
    fig=figure(1); clf; colormap(gray(256));
    h=imshow(img.Data,'Border','tight','InitialMagnification','fit');
    %set(gca, 'YDir', 'reverse'); 
    % Set region of interest
    roi=imellipse();
    thorcamStartLive(cam);
    % Capture and display n frames
    val=zeros(n, numel(m));
    for i=1:numel(m)
        hologram([1920, 1080],500,0,0,m(i),w);
        drawnow; pause(1);
        imdisp(h, cam, img, sprintf('m=%d', m(i)));
        fprintf('Waiting %d ...\n', i);
        wait(roi);
        for j=1:n
            tic;
            I=imdisp(h, cam, img, sprintf('m=%d', m(i)));
            mask=createMask(roi);
            val(j,i)=mean(I(mask));
            set(fig,'Name',sprintf('THORCam %i fps', round(1/toc)));
            drawnow;
        end
    end
    thorcamStopLive(cam);
    set(fig, 'Name', 'THORCam not recording');
    figure(3); plot(val(:));
catch
    disp('Error: you messed up, idiot!');
end
% Stop recording and close camera
thorcamClose(cam);
end

function [I]=imdisp(h, cam, img, caption)
img=thorcamGet(cam, img, 0);
I=insertText(img.Data, [20 20], caption, 'FontSize', 32);
set(h, 'CData', I); drawnow;
end