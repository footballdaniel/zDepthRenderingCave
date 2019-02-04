function [outputArg1,outputArg2] = plotFilter(points, points_filt,pointsInfo, fileLength, fName, start, actualDir)
% plotFilter: Shows the difference between butter-filtered data and the
% original data in a subplot figure
%
%   INPUTS: 
%   1. points: BTK-processed struct with Optitrack data
%   2. points_filt: Same structure, but with filterKinematicsButter 'ed
%   data
%   3. pointsInfo: The BTK processed secondary information
%   4. fileLength: The BTK file output
%   5. fName: The directory and name of the .c3d file
%   6. start: The frame where the headmarker is first recognized
%   7. actualDir: Directory for saving the files
%
%   OUTPUTS: 
%   1. Plots with two subplots: one for the raw z data and one for the
%   filtered z-data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot the head height over time
% Initiate the figure
figure1 = figure;
% Initiate a 2 row plot, 1 column. this is the first plot
subplot(2,1,1)
% First, Get a time vector for the data in seconds
timeVector = [start:fileLength]./pointsInfo.frequency *.1;
% Now 2D plot
plot(timeVector,points.HeadTop(start:end,3))
% Title the plot
title(['Raw Z-values:  ' num2str(fName(end-10:end))])
% Label axi
xlabel('Seconds');
ylabel('Meters');

%% Initiate a 2 row plot, 1 column. this is the first plot
subplot(2,1,2)
% Now 2D plot the filtered data
plot(timeVector,points_filt.HeadTop(start:end,3))
title(['Filtered Z-values:' num2str(fName(end-10:end))])
xlabel('Seconds');
ylabel('Meters');

%% save graph
basename = 'Filter_Head_Height';
FileName=[basename,num2str(fName(end-7:end))];
path = fullfile(actualDir,'/');
filetype = '.jpg';
figname = [path,FileName,filetype];
saveas(figure1, figname);

% wash dishes
close(figure1)
end

