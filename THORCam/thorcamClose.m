function [] = thorcamClose(cam)
% Close THORLABS camera. Must be called after the last capture.
% Adapted from Adam Wyatt's code
% Stop Capture
if ~strcmp(char(cam.Acquisition.Stop), 'SUCCESS')
    error('Could stop camera');
end
% Exit
if ~strcmp(char(cam.Exit), 'SUCCESS')
    error('Could not close camera');
end
end

