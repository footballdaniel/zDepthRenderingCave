function [outputArg1,outputArg2] = Plot2d3d(points, points_filt,pointsInfo, fileLength, fName, start, actualDir)
%Plot2d3d Summary of this function goes here
%   Detailed explanation goes here
        %% Plot Filtered and raw data
        % 3D Plot the head
        % plot3(points_filt.HeadTop(start:end,1),points_filt.HeadTop(start:end,2),points_filt.HeadTop(start:end,3))

        % 2D Plot the head
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
              
        % Initiate a 2 row plot, 1 column. this is the first plot
        subplot(2,1,2)
        % Now 2D plot the filtered data
        plot(timeVector,points_filt.HeadTop(start:end,3))
        title(['Filtered Z-values:' num2str(fName(end-10:end))])
        xlabel('Seconds');
        ylabel('Meters');
              
        
        
        
            %% save graph
        basename = 'Filter_Head_Height';
        FileName=[basename,num2str(fName(end-7:end))];
        path = fullfile(actualDir, '98_Graphs\');
        filetype = '.jpg';
        figname = [path,FileName,filetype];
        saveas(figure1, figname);
        
        % wash dishes
        close(figure1)
end

