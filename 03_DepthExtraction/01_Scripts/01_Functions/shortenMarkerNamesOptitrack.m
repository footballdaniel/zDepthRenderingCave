function [ posData_s ] = shortenMarkerNamesOptitrack( data,delimiter)
%SHORTENMARKERNAMES Shorten default Optitrack
%    This function shortens Optitrack marker names.
%
%   INPUTS: 
%   1. data struct with field names
%   2. delimiter that is used to cut off unwanted parts. Optitrack uses '_'
%
%   OUTPUTS: 
%   1. New struct with shortened names
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize posData_s (s for short) variable:
posData_s = data;

% Default marker names:
marker_names = fieldnames(posData_s);

% Initialize new_names variable:
new_names = cell(size(marker_names));

for i_markers = 1: length (marker_names)
    % condition to not read unlabeled markers
    if strncmp(marker_names{i_markers}, 'U',1) == 1 
        posData_s = rmfield(posData_s,marker_names{i_markers});
    else
        % If the marker is correctly labeled
        % Initiate segments variable
        segments = strings(0);
        % Cut off the name at the first delimiter (probably '_')
        [~, remain] = strtok(marker_names{i_markers}, delimiter);
        newSegment = remain; % Save as new segment 
        % If there are still more delimiters in the name, keep cutting
        while (remain ~= "") % Until there are no more strings with '_'
            [token,remain] = strtok(remain, delimiter);
            segments = [segments ; token];
            newSegment = segments(end,1); % Save as new segment
        end
        
        % Save the last segment as the new name
        new_names{i_markers,1} = newSegment;
        
        % Write the name into the new struct
        posData_s.(new_names{i_markers}) = ...
            posData_s.(marker_names{i_markers});
        posData_s = rmfield(posData_s, marker_names{i_markers});
        posData_s.(new_names{i_markers})...
            (posData_s.(new_names{i_markers}) == 0) = nan;
    end
end

end