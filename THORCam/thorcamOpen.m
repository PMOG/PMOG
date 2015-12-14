function [cam, img] = thorcamOpen(id)
% Initialize THORLABS camera. Must be called before the first caputre.
% Adapted from Adam Wyatt's cod
if(nargin==0)
    id=1;
end
% Add NET assembly if it does not exist
% May need to change specific location of library
asm = System.AppDomain.CurrentDomain.GetAssemblies;
if ~any(arrayfun(@(n) strncmpi(char(asm.Get(n-1).FullName), ...
        'uEyeDotNet', length('uEyeDotNet')), 1:asm.Length))
    NET.addAssembly(...
        'C:\Program Files (x86)\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\signed\uc480DotNet.dll');
end
% Create camera object handle
cam = uc480.Camera;
% Open camera with specified id
% Returns if unsuccessful
if ~strcmp(char(cam.Init(id)), 'SUCCESS')
    error('Could not initialize camera');
end
% Set display mode to bitmap (DiB)
if ~strcmp(char(cam.Display.Mode.Set(uc480.Defines.DisplayMode.DiB)), ...
        'SUCCESS')
    error('Could not set display mode');
end
% Set colormode to 8-bit RAW
if ~strcmp(char(cam.PixelFormat.Set(uc480.Defines.ColorMode.SensorRaw8)), ...
        'SUCCESS')
    error('Could not set pixel format');
end
% Set trigger mode to software (single image acquisition)
if ~strcmp(char(cam.Trigger.Set(uc480.Defines.TriggerMode.Software)), 'SUCCESS')
    error('Could not set trigger format');
end
% Allocate image memory
[ErrChk, img.ID] = cam.Memory.Allocate(true);
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not allocate memory');
end
% Obtain image information
[ErrChk, img.Width, img.Height, img.Bits, img.Pitch] ...
    = cam.Memory.Inquire(img.ID);
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not get image information');
end
% Acquire image
if ~strcmp(char(cam.Acquisition.Freeze(true)), 'SUCCESS')
    error('Could not acquire image');
end
% Extract image
[ErrChk, tmp] = cam.Memory.CopyToArray(img.ID); 
if ~strcmp(char(ErrChk), 'SUCCESS')
    error('Could not obtain image data');
end
% Reshape image
img.Data = reshape(uint8(tmp), [img.Width, img.Height, img.Bits/8]);
end