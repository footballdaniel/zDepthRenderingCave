%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function:		Z-Depth skript
% Version: 		001
% Author: 		Daniel
% Creation: 	Yesterday night
% Last Change: 	This morning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Goal of the script: 
% 1. Use unprocessed Baseline Optitrack data.
% 2. Filter and interpolate NAN's of the head position
% 3. Export Translation of the head position with 20 Hertz to CSV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Aufräumen
close all;
clear all;
clc;

% Informationen über die Ausführungsumgebung
actualDir = cd;

% Pfadinformationen hinzufügen, damit Matlab weiss, wo die verwendeten
% Funktionen zu finden sind.
addpath(genpath(actualDir));

% Pfad zu den Daten um die VPN anschliessend herauszulesen
pName = fullfile(actualDir,'00_Data','day3c3d');

% Auslesen der Infos: Gibt an wie viele VPNS im Ordner ist
dir_struct = dir (fullfile(pName));
[VPNfolder,sorted_index] = sortrows({dir_struct(3:end).name}');

% Ergebniszähler initialisieren (erste Zeile = header)
counter = 2;

% für die erste VPN: welche trials gibt es?
for m = 1:length(VPNfolder)                                               
    % Interessierende Files auswählen, alle files die mit .c3d enden
    dir_struct = dir(fullfile(pName,VPNfolder{m},'*.c3d'));
    [filenames,sorted_index] = sortrows({dir_struct.name}');
    
    for l = 1:length(filenames)                                             % do to get all files
        %jeweiligen Filename erzeugen
        fName = fullfile(pName,VPNfolder{m},filenames{l});

        %gibt aus, was für ein File er gerade liest
        fName

        % Lese File: einlesen des c3d files. das btk read - toolkit liest
        % diese binären daten ein
        h = btkReadAcquisition(fName);

        %herausfinden, wie viele frames da drin sind.
        fileLength = btkGetLastFrame(h) ;
        
        %die markernamen herauslesen.
        % z.b. alle head-marker lesen und dann plot > headmarker um die
        % verschiebung der Headmarker über die Zeit zu kriegen.
        [points pointsInfo] = btkGetPoints(h);
        % pointsInfo.residuals."markername"
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %hier machts den zugriff der btk-funktion wieder zu. ab hier sind
        %die daten als "markername" vorhanden.
        btkDeleteAcquisition(h);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ab hier: für jeden einzelnen Versuch jeder Person
        % können aus der Variable points die Trajektorien der Marker in
        % Matlab verarbeitet werden
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Cleanly clean marker names
        cutoff = 4; % Cutoff 6 digits after the first underline of the name
        points = shortenmarkernames(points, cutoff);
        
        %% Raw Z-Plots        
        % Find the first sceleton recognition
        % Get the first value that is not nan 
        start = find(isnan(points.HeadTop(1:end,3))==0,1,'first');
        
        % Get the file length in seconds
        timeSecondsTotal = fileLength / pointsInfo.frequency;
        % Get the file length from sceleton recognition in seconds
        timeSecondsSceletons = timeSecondsTotal - ((fileLength-start) / pointsInfo.frequency);
        % Set recognition of sceleton
        string = 'Skeleton was recognized after %.2f seconds';
        SceletonRecognition = sprintf(string,timeSecondsSceletons);
        %SceletonRecognitionAfterSeconds = {timeSecondsSceletons 'Seconds'}
        
        %% Butter the data
        points_filt = filterKinematicsButter(points,pointsInfo.frequency,10.5,40);
        head_filt_rec.HeadTop = points_filt.HeadTop(start:end,:);
        
        %% Plot Filtered and unfiltered data against each other
        Plot2d3d(points, points_filt,pointsInfo, fileLength, fName, start, actualDir)


        %% Peak finder and next value at head hight!
        StandingUp = find_sitting_event(head_filt_rec,num2str(fName(end-8:end)),fName,pointsInfo, fileLength,head_filt_rec, 1); 
        
        % Start z_depth vector with first standing up
        x_depth = head_filt_rec.HeadTop(StandingUp(1,1):end,1);
        y_depth = head_filt_rec.HeadTop(StandingUp(1,1):end,3);
        z_depth = head_filt_rec.HeadTop(StandingUp(1,1):end,2);
        
        
        % Scale to 20 fps
        depth_20fps(:,1) = x_depth(1:10:end,:);
        depth_20fps(:,2) = y_depth(1:10:end,:);
        depth_20fps(:,3) = z_depth(1:10:end,:);
        

        
        % Create simple z-depth-vector (without having a timeline in first
        % column)
        z_depth_simple = z_depth(1:10:end,:);
        % Get only differences from last frame
        z_depth_simple = [0;diff(z_depth_simple)]; 
        z_depth_simple = z_depth_simple*1000;
        z_depth_simple = round(z_depth_simple, 0);

         
        % Catch as backup
        z_depth_20fps(:,1) = z_depth(1:10:end,:);
        z_depth_20fps_absolute = z_depth_20fps(:,1);
        
        %% Get only differences from last frame
        z_depth_20fps(:,1) = [0;diff(z_depth_20fps(:,1))];     
        z_depth_20fps(:,1) = z_depth_20fps(:,1)*1000;
        z_depth_20fps(:,1) = round(z_depth_20fps(:,1), 0);
        
        
        %% Adjusting data to desired export
        length =  size(z_depth_20fps,1);
        total_time = length/20;

        
        %% Write a header
        z_depth_20fps = num2cell(z_depth_20fps);

        
 
         
        %% Exporting to text file


        basename1 = 'z_to_Unity_';
        basename2 = 'z_to_Matlab_';
        FileName=[basename1,num2str(fName(end-6:end))];
        FileName2=[basename2,num2str(fName(end-6:end))];
        path = fullfile(actualDir);
        filetype = '.csv';
        filename = [path,FileName,filetype];
        filename2 = [path,FileName2,filetype];
        
        
        %% First is to write diff for unity in first column
        dlmwrite(filename,z_depth_20fps,'delimiter',',','newline', 'pc');
        
        % Write absolute dev from origin for xyz over time
        dlmwrite(filename2,depth_20fps,'delimiter',',','newline', 'pc');
        
%         dlmwrite(filename,z_depth_20fps_absolute,'delimiter',',','newline', 'pc');
%         cell2csv(filename, z_depth_simple, ',');
%         cell2csv(filename, z_depth_20fps, ',');
        
        % Wash dishes
        clear z_depth_20fps x_depth y_depth z_depth depth_20fps
        

    end
end




