%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Skript: Z_Depth_Analysis_refined takes .c3d input and transforms the
% relevant part of the timeline to a .txt file.
% Author: 		Daniel Mueller (email.daniel.ch@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Goal of the script:
% 1. Use unprocessed Baseline Optitrack data.
% 2. Filter and interpolate NAN's of the head position
% 3. Detect event when subject triggers the capture by standing up
% 4. Export Translation of the head position with 20 Hertz to CSV
%
% Requirements:
% 1. BTK-Toolkit: https://code.google.com/archive/p/b-tk/
% 2. .c3d file of baseline bodymarker set (must include HeadTop marker)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mise-en-place
close all;
clear all;
clc;
% Add all files in the directory enviornment
addpath(genpath(pwd));

%% Necessary user input
% Set path to the where the .c3d files are stored
pName = fullfile(pwd,'00_Data','day3c3d');


%% Read C3D
% List all files ending with .c3d stored in the pName directory
dir_struct = dir(fullfile(pName,'*.c3d'));
% Sort the files by name and list the filenames
[filenames,~] = sortrows({dir_struct.name}');

for i = 1:length(filenames)                                           
    % Get name of file currently processed
    fName = fullfile(pName,filenames{i});
    % Display name of currently processed file
    disp(sprintf('Currently processing: %s', fName))
    

    
    %% Use BTK-toolkit 
    [points,pointsInfo, fileLength] = btkGetPointsDirect(fName);
    
    %% Cleanly clean marker names
    delimiter = '_'; % Chose a delimiter for the filename. Usually '_'
    points = shortenMarkerNamesOptitrack(points, delimiter);
    
    %% Console display when
    start = sceletonRecognition(points, fileLength, pointsInfo);
    
    %% Butter the data
    % The butter filter smoothes the data with input arguments
    points_filt = filterKinematicsButter(points,pointsInfo.frequency, ...
        10.5,40);
    head_filt_rec.HeadTop = points_filt.HeadTop(start:end,:);
    
    %% Plot Filtered and unfiltered data against each other
    plotFilter(points, points_filt,pointsInfo, fileLength, fName, start, pwd)
    
    %% Find the Event when the subject stands up
    standingUp = findStandingUpEvent(head_filt_rec,fName,pointsInfo, ...
        fileLength,head_filt_rec, 155, 1, 1);
    
    % Start z_depth vector with first standing up
    x_depth = head_filt_rec.HeadTop(standingUp(1,1):end,1);
    y_depth = head_filt_rec.HeadTop(standingUp(1,1):end,3);
    z_depth = head_filt_rec.HeadTop(standingUp(1,1):end,2);
    
    %% Absolute 20 fps data
    % Scale to 20 fps. These are absolute values which are exported for
    % positional data analysis in matlab
    depth_20fps(:,1) = x_depth(1:10:end,:);
    depth_20fps(:,2) = y_depth(1:10:end,:);
    depth_20fps(:,3) = z_depth(1:10:end,:);
    
    %% Frame to frame difference 20 fps data
    % Scale to 20 fps
    z_depth_20fps(:,1) = z_depth(1:10:end,:);
    z_depth_20fps_absolute = z_depth_20fps(:,1);
    
    %% Get only differences from last frame
    z_depth_20fps(:,1) = [0;diff(z_depth_20fps(:,1))];
    z_depth_20fps(:,1) = z_depth_20fps(:,1)*1000;
    z_depth_20fps(:,1) = round(z_depth_20fps(:,1), 0);
    
    %% Adjusting data to desired export
    length =  size(z_depth_20fps,1);
    total_time = length/20;  
    % Write a header
    z_depth_20fps = num2cell(z_depth_20fps);
    
    %% Exporting to text file
    basename1 = 'z_to_Unity_';
    basename2 = 'z_to_Matlab_';
    FileName=[basename1,num2str(fName(end-6:end))];
    FileName2=[basename2,num2str(fName(end-6:end))];
    path = fullfile(pwd, '99_Outputs\');
    filetype = '.csv';
    filename = [path,FileName,filetype];
    filename2 = [path,FileName2,filetype];
    
    % First is to write diff for unity in first column
    dlmwrite(filename,z_depth_20fps,'delimiter',',','newline', 'pc');
    % Write absolute dev from origin for xyz over time for positional data
    % analysis in matlab
    dlmwrite(filename2,depth_20fps,'delimiter',',','newline', 'pc');

    % Wash dishes
    clear z_depth_20fps x_depth y_depth z_depth depth_20fps
    
    
end




