function [StandingUp] = find_sitting_event(posData,trialname, FileName, pointsInfo, fileLength, head_filt_rec, plotyesno)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This function defines the critical events of oscilatory movements such
%  as heel raises (releves) or jumps (sautes). This function identifies the
%  bottom and top of the movements by using the average of the 4 pelvis
%  markers, breaking the movement up into phases of loweing and lifting (or
%  jumping). Movements will be broken down as follows in the take off and
%  landing phase.
%
%   INPUTS:
%       1. posData: 3d positional data structure of a full body marker set
%           with  marker labels of the Biomechanics Model - mainly needs
%           the 4 pelvis markers RIAS, RIPS, LIAS, and LIPS
%
%   OUTPUTS:
%       1. takeOffSS: a 2 x n matrix with the start and stop time points for the take off phase
%           of the movement. The first column holds the time point at which
%           the estimated COM is at the lowest vertical position. The
%           second column has the time point at which the estimated COM is
%           at the highest vertical position. Each row represents a
%           consecutive movement.
%       2. landingSS: a 2 x n matrix with the stop and starttime points for the landing phase
%           of the movement. The first column holds the time point at which
%           the estimated COM is at the highest vertical position. The
%           second column holds the time point at which the estimated COM
%           is at the lowest vertical position. Each row represents a
%           consecutive movement.
%
%  Written by:CH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% Estimate COM
% % Concatenate all hip markers along 3rd dimension
% if sum(isfield(posData, {'RIAS', 'RIPS', 'LIAS', 'LIPS'})) == 4 && mean(posData.RIAS(:,3))> 0.75 && mean(posData.RIAS(:,3)) < 3
%     if mean(posData.LIAS(:,1)) < 10
%         hip3D = cat(3,posData.RIAS, posData.RIPS, posData.LIAS, posData.LIPS);
%     else
%         hip3D = cat(3, posData.RIPS, posData.LIPS);
%     end
% else %catch for skeletons missing RIAS...
%     hip3D = cat(3, posData.RIPS, posData.LIAS, posData.LIPS);
% end

%% Initiate data
head_top = posData.HeadTop;
maxCrouch = [];


% find minimum values in z direction (lowest point)
negZ = -1* (head_top(:,3));
[Mins(:,1), Mins(:,2)] = findpeaks(negZ);
mins = sortrows(Mins, -1);
thresh = .3; % How much threshold around the deepest crouching position should be calculated.

% select the greatest mins at bottom of plie and delete all other data
for i =  1:length(mins)
    if mins(i,1) < (mins(1,1) - thresh)% arbitrary 8cm diff between each trial
        mins(i:length(mins), :) = [];
        break
    end
end

mins = sortrows(mins,2);




%% Sort out minimums which are too close to each other (within 1 second)

j = 1;
gap = 2000; % 2000 frames equal 10 seconds
deleteMe = [];

% if there are more than 1 minmum points
if size(mins,1) ~= 1
for i =  2: length(mins)
    if mins(i,2) < (mins(i-1,2) + gap)% arbitrary minimum of 10 frames betwen each minimum
        deleteMe(j) = i;
        j = j+1;
    end
end
end


%delete double mins
if isnumeric(deleteMe) == 1
    mins(deleteMe, :) = [];
end

%% Get the values where participant is at lowest crouching point

maxCrouch(:,1) = mins(:,2);

%% Get the first point out of crouch

        peaks = zeros(size(mins,1));
        
        % Thats the threshold after which the person is assumed to stand up
        height_participant = 155;
        for i = 1:size(mins,1)
            peaks(i,2) = head_top(i,3); % Get the z value for the frame 
            peak = mins(i,2); % Get the first peak
            data = head_filt_rec.HeadTop(peak:end,3); %Foster the data from the first peak point
            
            findings = find(data > height_participant, 1, 'first'); % Find the first frame where the height of the participant is reached
            if isempty(findings)
                findings = mins(i,2);
                peaks(i,1) = findings;
            else
                peaks(i,1) = findings;
                peaks(i,1) = peaks(i,1) + mins(i,2); % Save the frame as a peak. take the min value and add the number of frames it takes to get to the peak
            end
        end
 standUp(:,1) = peaks(:,1);  % Get the frames for standing up     
 
%% Plot graph
if plotyesno == 1
    %% visualize gesture toe off and down with marked start/stop trial
    fig = figure();
    hold on
    plot (head_top(:,3),'DisplayName', 'HeadTop_Z');
    % Name Axis
    xlabel('Frames');
    ylabel('Meters');
    
    % take Off start stop
    scatter(maxCrouch(:,1),head_top(maxCrouch(:,1),3),'r','LineWidth',1.5,'DisplayName','Crouch');
    scatter(peaks(:,1),head_top(peaks(:,1),3),'b','LineWidth',3,'DisplayName','Standing_Up');
    title(strcat(' Trial: ',trialname));
    legend ('show', 'Location', 'eastoutside')
    
    
    % save graph
    basename = 'Filter Head Height Tops';
    FileName=[basename,num2str(FileName(end-8:end))];
    path = fullfile(pwd, '98_Graphs\');
    filetype = '.jpg';
    figname = [path,FileName,filetype];
    saveas(fig, figname);
    
    StandingUp = peaks;
end
close all


