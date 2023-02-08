function [f_roi, psdx_roi, rel_power_roi, f_mean, psdx_mean, rel_power_mean, psdx_roi_smooth] = fft_filt_bw_AH2(timeseries, Fs, nr_rois)
% get power spectral density and relative power for all ROIs
% also gives average power spectral density (averaged across ROIs) and relative
% power for that power spectral density
% Tewarie 2021

% check if data is in same format as BrainWave
if size(timeseries,1) ~= 4096
    error('epoch length has to be 4096, same as BrainWave')
end

if Fs ~= 312
    error('Sampling frequency has to be 312, i.e. 4 times downsampled data, same as for BrainWave')
end

% housekeeping
f_roi = zeros(nr_rois,size(timeseries,1)/2+1);
psdx_roi = zeros(nr_rois,size(timeseries,1)/2+1);
psdx_roi_smooth = zeros(nr_rois,size(timeseries,1)/2+1);
rel_power_roi = zeros(nr_rois,6); 
rel_power_mean = zeros(1,6);
frequency_low = [0.5 4 8 10 13 30]; % lower limit frequency bands
frequency_high = [4 8 10 13 30 48]; % upper limit frequency bands

%% get relative power and power spectral density for every ROI
for roi = 1:nr_rois
%    temp = timeseries(:,roi).*hanning(length(timeseries(:,roi)));
    temp = timeseries(:,roi).*rectwin(length(timeseries(:,roi))); % AH, as in Brainwave
    N = length(temp);
    xdft = fft(temp);
    xdft = xdft(1:length(temp)/2+1);
    psdx = (1/(Fs*N)).*abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);    % maybe not even necessary since we are interested in normalised spectra
    %AH: don´t normalise the spectrum, as you want relative power in for the range 0.5-48 Hz
    %   psdx = psdx./sum(psdx);             % normalise spectra
    f_temp = 0:Fs/length(temp):Fs/2;
    
    % get freq and psdx for every ROI
    f_roi(roi,:)= f_temp;
    psdx_roi(roi,:)= psdx;
    psdx_roi_smooth(roi,:) = smooth(psdx,15,'loess');
    
    for freq = 1: numel(frequency_low) 
    
        % get right index to compute relative power    
%         [~,indx_low]  = min(abs(f_temp-frequency_low(freq)));
%         indx_low = indx_low + 1;        % counting otherwise the same bin twice
%         [~,indx_high] = min(abs(f_temp-frequency_high(freq)));
        %AH: better way to define the bands
        indx_low = find(diff(sign(f_temp-frequency_low(freq))))+1;
        indx_high = find(diff(sign(f_temp-frequency_high(freq))));
        %f_temp([indx_low, indx_high])

        % compute relative power
        %rel_power_roi(roi,freq) = sum(psdx(indx_low:indx_high));
        % AH: normalise over 0.5-48Hz band
        indx_low_bb = find(diff(sign(f_temp-0.5)))+1;
        indx_high_bb = find(diff(sign(f_temp-48)));
        rel_power_roi(roi,freq) = sum(psdx(indx_low:indx_high))/sum(psdx(indx_low_bb:indx_high_bb));
    end
end

%% get average spectra and relative power for average spectra
f_mean = mean(f_roi,1);
psdx_mean = mean(psdx_roi,1);


for freq = 1: numel(frequency_low) 
    
        % get right index to compute relative power    
%         [~,indx_low]  = min(abs(f_mean-frequency_low(freq)));
%         indx_low = indx_low + 1;    % counting otherwise the same bin twice
%         [~,indx_high] = min(abs(f_mean-frequency_high(freq)));
        %AH: better way to define the bands
        indx_low = find(diff(sign(f_temp-frequency_low(freq))))+1;
        indx_high = find(diff(sign(f_temp-frequency_high(freq))));
        f_temp([indx_low, indx_high]);
        
        % compute relative power
        %rel_power_mean(freq) = sum(psdx_mean(indx_low:indx_high));
        % AH: normalise over 0.5-48Hz band
        indx_low_bb = find(diff(sign(f_temp-0.5)))+1;
        indx_high_bb = find(diff(sign(f_temp-48)));
        rel_power_mean(freq) = sum(psdx_mean(indx_low:indx_high))/sum(psdx_mean(indx_low_bb:indx_high_bb));
end

