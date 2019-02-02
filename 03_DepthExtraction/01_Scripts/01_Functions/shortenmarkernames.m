function [ posData_s ] = shortenmarkernames( posData, cutoff )
%SHORTENMARKERNAMES Shorten default Vicon marker names
%    This function shortens Vicon marker names (because default names are unnecessarily repetitive)

% Initialize posData_s (s for short) variable:
posData_s = posData;

% Default marker names:
marker_names = fieldnames(posData_s);

% Initialize new_names variable:
new_names = cell(size(marker_names));

for i_markers = 1: length (marker_names)
    if strncmp(marker_names{i_markers}, 'U',1) == 1 % condition to not read unlabeled markers
        posData_s = rmfield(posData_s,marker_names{i_markers});
    else
        [~, remain] = strtok(marker_names{i_markers}, '_');
        % edit here  for percision of cut off
        new_names{i_markers,1} = remain(cutoff:end);
        posData_s.(new_names{i_markers}) = posData_s.(marker_names{i_markers});
        posData_s = rmfield(posData_s, marker_names{i_markers});
        posData_s.(new_names{i_markers})(posData_s.(new_names{i_markers}) == 0) = nan;
    end
end

end