function [] = thorcamStartLive( cam )
% Start live capture
if ~strcmp(char(cam.Acquisition.Capture(false)), 'SUCCESS')
    error('Could not acquire image');
end
end

