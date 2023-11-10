%% Load Data in and verify details
%doc McsHDF5
clear all; clc; close all; 

data = McsHDF5.McsData('20230815_WT.NM_mwd.h5');

HighPassOnData = data.Recording{1, 1}.AnalogStream{1, 1}.Info.HighPassFilterCutOffFrequency(1);
LowPassOnData = data.Recording{1, 1}.AnalogStream{1, 1}.Info.LowPassFilterCutOffFrequency(1);
DurationS = data.Recording{1, 1}.Duration(1)*(1e-6); %original in us converted to S here
SamplingRate = 1000000/(data.Recording{1, 1}.AnalogStream{1, 1}.Info.Tick(1));

fprintf('Duration %d s, SamplingRate %d Hz, HighPass %s Hz, LowPass %s Hz', DurationS, SamplingRate, HighPassOnData{1,1}, LowPassOnData{1,1});

%% Double Check Parameters to be applied
clear DurationS SamplingRate LowPassOnData HighPassOnData;   %removes data pulled in from file to make room

% Make sure these match the above section
SamplingRate = 20000;                                       %in Hz
DurationS = cast(300, 'double');     
TimeVector = 0:1/SamplingRate:DurationS-1/SamplingRate;
ScalingFactor = 1e-6;  % Scale back to microvolts

% Filter Parameters
%LowPassCutoff = 3500/(SamplingRate/2);
%LowPassOrder = 2;
HighPassOrder = 4; 
HighPassCutoff = 250/(SamplingRate/2); 

% Prep Filters      Lowpass code here but not implemented
%[bLow, aLow] = butter(LowPassOrder, LowPassCutoff, 'low');      %Lowpass not implemented
[bHigh, aHigh] = butter(HighPassOrder, HighPassCutoff, 'high');


%%
WellNumber = data.Recording{1, 1}.AnalogStream{1, 1}.Info.GroupID();
ElectrodeNumber = data.Recording{1, 1}.AnalogStream{1, 1}.Info.Label;
FullData = data.Recording{1}.AnalogStream{1};[];

% Visualize before filtering
    % Partial Data to work with
cfg = [];
cfg.channel = [];   % channel index 1 to 12
cfg.window = [];        % whole time recording if left blank
PartialData = data.Recording{1}.AnalogStream{1}.readPartialChannelData(cfg);

% Full data plotted below
%plot(data.Recording{1}.AnalogStream{1},[]) %full data recording
% Extract the data from the McsAnalogStream
ChannelData = PartialData.ChannelData * ScalingFactor;
DoubleMatrixData = double(ChannelData);   % Convert channelData to a double matrix

% Filtering here
% Highpass filter applied
for i = 1:size(DoubleMatrixData, 1)
    FilteredData(i,:) = filtfilt(bHigh, aHigh, DoubleMatrixData(i, :));
end

% Comparing Unfiltered and FIltered
figure
parfor i = 1:12
    subplot(4,3,i)
    hold on
    plot(TimeVector, DoubleMatrixData(i,:), 'r'); 
    plot(TimeVector, FilteredData(i,:), 'b');
    legend('Pre-filter', 'Filtered'), xlabel('Time (s)'), ylabel('Voltage (\muV)')
    hold off;
end

%%

%DO SPECTROGRAM HERE


%% Finding standard deviations for thresholds
% done by row with random intervals from the parameters below
NumIntervals = 1;
StdIntervalDur = 1000; % 500mS for sample
StdNumSamples = (SamplingRate * StdIntervalDur) / 1e6;

Std = zeros(size(FilteredData, 1),1);

for i = 1:size(FilteredData,1)
    rowStd = zeros(1,NumIntervals);

    for j = 1:NumIntervals
        maxStartPoint = size(FilteredData, 2) - StdNumSamples+1;
        StartPoint = randi([1, maxStartPoint]);

        intervalData = FilteredData(i, StartPoint:StartPoint+StdNumSamples+1);

        rowStd(j) = std(intervalData);
    end
    Std(i) = mean(rowStd);
end 

% Changing Standard Deviations into Thresholds
Threshold = Std*5.5;

%Exclusion of Data based on Thresholds set
ThresholdExclusion = false(size(FilteredData));

for i = 1:size(FilteredData, 1)
    for j = 1:size(FilteredData, 2)
        ThresholdExclusion(i, j) = abs(FilteredData(i, j)) >= Threshold(i);
    end
end

ThreshFiltData = FilteredData;
ThreshFiltData(~ThresholdExclusion) = NaN;

%% Visualization of Threshold exclusion
figure
for i = 1:5           %showing 3 thresholds and electrodes.
    subplot(5,1,i)
    hold on
    plot(TimeVector, FilteredData(i,:), 'k'); 
    plot(TimeVector, ThreshFiltData(i,:), 'r*');
    yline(Threshold(i), 'b')
    yline(Threshold(i)*-1, 'b')
    hold off
end 

%%
% Specify the time window around threshold crossings
windowSize = 1/1000;  % Adjust the window size as needed (in seconds)

ThreshFiltData2 = NaN(size(FilteredData));

for i = 1:size(FilteredData, 1)
    % Find the indices where the threshold is crossed
    thresholdCrossings = find(ThresholdExclusion(i, :));

    % Create a window around each threshold crossing
    for j = thresholdCrossings
        startIndex = max(1, j - windowSize * SamplingRate);
        endIndex = min(size(FilteredData, 2), j + windowSize * SamplingRate);

        % Copy the data within the window to ThreshFiltData
        ThreshFiltData2(i, startIndex:endIndex) = FilteredData(i, startIndex:endIndex);
    end
end

figure
for i = 1:5
    subplot(5, 1, i)
    plot(TimeVector, ThreshFiltData2(i, :));
end

%% visualizing remaining waveforms
WaveformWindow = linspace(-windowSize, windowSize, windowSize * SamplingRate);
% 
figure
for i = 1:5
     subplot(5, 1, i)
     plot(WaveformWindow, ThreshFiltData2(i, :));
     xlabel('Time (s)')
end