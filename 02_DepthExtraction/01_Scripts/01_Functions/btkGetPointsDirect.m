function [points,pointsInfo, fileLength] = btkGetPointsDirect(filepath)
% BtkGetPoints: Uses the BTK toolkit
% (https://code.google.com/archive/p/b-tk/) to shorten .c3d marker names
% from optitrack
%
%   INPUTS: 
%   1. data struct with field names
%   2. delimiter that is used to cut off unwanted parts. Optitrack uses '_'
%
%   OUTPUTS: 
%   1. New struct with shortened names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% Disable the warning(s) for the function btkReadAcquisition
warning('OFF', 'btk:ReadAcquisition');
% Read .c3d files
h = btkReadAcquisition(filepath);
% Get number of frames
fileLength = btkGetLastFrame(h) ;
% Read all markers
[points pointsInfo] = btkGetPoints(h);
% Delete Acquisition
btkDeleteAcquisition(h);
end

