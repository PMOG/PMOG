function [img] = thorcamGet(cam, img, freeze)
% Captures frame from THORLABS camera. The data is stored in img.Data
% Adapted from Adam Wyatt's code
if(nargin<3)
    freeze=0;
end
if(freeze) 
    % Acquire image
    if ~strcmp(char(cam.Acquisition.Freeze(true)), 'SUCCESS')
    error('Could not acquire image');
    end
end
% Extract image
[ErrChk, tmp] = cam.Memory.CopyToArray(img.ID); 
if ~strcmp(char(ErrChk), 'SUCCESS')
  error('Could not obtain image data');
end
% Reshape image
img.Data = reshape(uint8(tmp), [img.Width, img.Height, img.Bits/8]);
end

