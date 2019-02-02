function [filtKinData, n_butt] = filterKinematicsButter(kinData,f,f_cutoff,f_stop)
        filtKinData = kinData;
%         f = pointsInfo.frequency;%  sampling frequency
%         f_cutoff = 5; % cutoff frequency
%         f_stop = 8;
        %erzeuge Filter
        
        Wp = f_cutoff/f; %pass band/ cut off frequency
        Ws = f_stop /f; %stop band frequency
        [n_butt,Wn] = buttord(Wp,Ws,3,60); %3dB ripple in passband max / 60db attenuation in stopband
        
        
        ftype = 'low';
        
        [z, p, k_f] = butter(n_butt,Wn,ftype);
        [sos,g]=zp2sos(z,p,k_f);

        % hier werden die verdeckten Markerbereiche so behandelt, dass es
        % keinenEinfluss auf die sichtbaren Bereiche gibt
        allfields = fieldnames(kinData);
        for k = 1:length(allfields)
            % nicht sichtbare Marker werden mit 0 ausgegeben, gleich NaN setzen
            temp = getfield(kinData,allfields{k});
            temp (temp ==0) = NaN;
            % an den nicht sichtbaren stellen spline interpolieren
            temp = naninterp(temp );
            % filtere diese (zero lag butterworth)
            temp = filtfilt(sos,g, temp );
            % wieder rückersetzen
            temp (isnan(temp )) = NaN;
            filtKinData = setfield(filtKinData,allfields{k},temp);
        end
                
end