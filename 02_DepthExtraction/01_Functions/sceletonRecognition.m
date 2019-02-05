function [start] = sceletonRecognition(points, fileLength, pointsInfo)
% sceletonRecognition: Calculates and displays time when sceleton head.Top
% marker was first detected
%
%   INPUTS: 
%   1. Points in struct from btk-Acquisition
%   2. The file Lenght as defined in btk-Acquisition
%   3. pointsInfo: as defined in btk-Acquisition
%
%   OUTPUTS: 
%   1. Console display of time. Should be 0 < time < 3s
%   2. start: the first frame when the sceleton head is recognized
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the first sceleton recognition
% Get the first value that is not nan
start = find(isnan(points.HeadTop(1:end,3))==0,1,'first');

% Get the file length in seconds
timeSecondsTotal = fileLength / pointsInfo.frequency;
% Get the file length from sceleton recognition in seconds
timeSecondsSceletons = timeSecondsTotal - ((fileLength-start) / ...
    pointsInfo.frequency);
% Set recognition of sceleton
string = 'Skeleton.HeadTop was recognized after %.2f seconds';
disp(sprintf(string,timeSecondsSceletons))





end

