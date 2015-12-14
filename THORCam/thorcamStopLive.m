function [] = thorcamStopLive( cam )
% Start live capture
if ~strcmp(char(cam.Acquisition.Stop), 'SUCCESS')
    error('Could not acquire image');
end
end

