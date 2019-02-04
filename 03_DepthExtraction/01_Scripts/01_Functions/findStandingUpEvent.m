function [StandingUp] = findStandingUpEvent(posData, fileName, pointsInfo, fileLength, pointStruct, height_participant, plotyesno, saveyesno)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% findStandingUpEvent: This function takes timeline data and detects the
% time event when a crouching subject stands up for the first time in the
% lab to full body height. This function has private parameters (see
% Section 1 which need to be set!)
%
%   INPUTS:
%       1. posData: 3d positional data structure of a full body marker set
%           with  marker labels of the Biomechanics Model. Mainly needs
%           HeadTop
%       2. fileName: The name of the file as a path
%       3. fileLength: length in frames as defined by btk-Acquisition
%       4. PointStruct: The filtered struct with the HeadTop marker
%       5. height_participand: Is the height of the subject in study [cm]
%       6. plotyesno: Binary toggle plotting. yes = 1
%       7. saveyesno: Binary toggle for saving the plot. yes = 1
% 
%
%   OUTPUTS:
%       1. StandingUp: The timeframe when the Subject got up to a standing
%       position for the first time
%
%  Written by:CH,DM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Private parameters
thresh = .3; % How much threshold around the deepest crouching position 
% should be calculated. Imagine a subject crouching. A default value of .3
% allows the crouching to be happening in +- 30 cm of the position

gap = 2000; % 2000 frames equal 10 seconds. If there is a crouching event 
% found, possibly in the next 10 seconds the subject wont crouch again, 
%since data is collected in this time

%% Initiate data
head_top = posData.HeadTop;
maxCrouch = [];

% get only the filename from the filepath
[~,trialname,~] = fileparts(fileName);

%% find minimum values in z direction (lowest point) - indicator of crouch
% Invert timeline to find a negative peak
negZ = -1* (head_top(:,3));
[Mins(:,1), Mins(:,2)] = findpeaks(negZ);
mins = sortrows(Mins, -1);


% select the greatest mins at bottom of crouch and delete all other data
for i =  1:length(mins)
    if mins(i,1) < (mins(1,1) - thresh)% arbitrary 30 cm diff
        mins(i:length(mins), :) = [];
        break
    end
end
mins = sortrows(mins,2);

%% Sort out minimums which are too close to each other (within 1 second)
j = 1;

deleteMe = [];

% if there are more than 1 minmum points
if size(mins,1) ~= 1
for i =  2: length(mins)
    if mins(i,2) < (mins(i-1,2) + gap)% arbitrary minimum of 10 seconds
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
        
        for i = 1:size(mins,1)
            peaks(i,2) = head_top(i,3); % Get the z value for the frame 
            peak = mins(i,2); % Get the first peak
            %Foster the data from the first peak point
            data = pointStruct.HeadTop(peak:end,3); 
            
            % Find the first frame where the height of the participant 
            % is reached
            findings = find(data > height_participant, 1, 'first'); 
            if isempty(findings)
                findings = mins(i,2);
                peaks(i,1) = findings;
            else
                peaks(i,1) = findings;
                 % Save the frame as a peak. take the min value and add the
                 % number of frames it takes to get to the peak
                peaks(i,1) = peaks(i,1) + mins(i,2);
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
    scatter(maxCrouch(:,1),head_top(maxCrouch(:,1),3),'r', ... 
        'LineWidth',1.5,'DisplayName','Crouch');
    scatter(peaks(:,1),head_top(peaks(:,1),3),'b','LineWidth',3, ... 
        'DisplayName','Standing_Up');
    title(strcat(' Trial: ',trialname));
    legend ('show', 'Location', 'eastoutside')
    
    if saveyesno == 1
        % save graph
        basename = 'Filter Head Height Tops';
        fileName=[basename,num2str(fileName(end-8:end))];
        path = fullfile(pwd, '\');
        filetype = '.jpg';
        figname = [path,fileName,filetype];
        saveas(fig, figname);
    end
    
    StandingUp = peaks;
end
close all


