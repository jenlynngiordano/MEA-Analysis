%% Pull data into Matlab
clc; clear all; close all;

% Specify the path to the H5 file
FilePath = '20230525_Healthy.NM.h5';
%h5disp('20230525_Healthy.NM.h5')
%Info = h5info(FilePath);

%% Reference
%how to pull attributes
%   attribute_value = h5readatt(file_path, dataset_path, attribute_name);

%how to pull datasets
%    ChannelDataA_0 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_0/ChannelData');

%% Pull apart groups from the hdf5 file format
% Not all of these will be used but they are left here in case.
% Root folder is named /
% Event, Frame, and Segment Stream are not written out yet

%Data = '/Data';
   % Attributes from /Data
   %ProgramName = h5readatt(FilePath, Data, 'ProgramName');
   %ProgramVersion = h5readatt(FilePath, Data, 'ProgramVersion');
   %DateInTicks = h5readatt(FilePath, Data, 'DateInTicks');
   %FileGUID = h5readatt(FilePath, Data, 'FileGUID');
   %MeaSN = h5readatt(FilePath, Data, 'MeaSN');
   %MeaName = h5readatt(FilePath, Data, 'MeaName');
   %MeaLayout = h5readatt(FilePath, Data, 'MeaLayout');
   %Date = h5readatt(FilePath, Data, 'Date');
   %Comment = h5readatt(FilePath, Data, 'Comment');

Recording_0 = '/Data/Recording_0';
   % Attributes from /Data/Recording_0
   %RecordingID = h5readatt(FilePath, Recording_0, 'RecordingID');
   %RecordingType = h5readatt(FilePath, Recording_0, 'RecordingType');
   %TimeStamp = h5readatt(FilePath, Recording_0, 'TimeStamp');
   %Label = h5readatt(FilePath, Recording_0, 'Label');
   %Comment0 = h5readatt(FilePath, Recording_0, 'Comment');
   DurationUs = h5readatt(FilePath, Recording_0, 'Duration');
   DurationS = DurationUs / (1*10^6);

%AnalogStream = '/Data/Recording_0/AnalogStream';
    %AnalogStream is only organizational; contains no attributes or data

%AnalogStream0 = '/Data/Recording_0/AnalogStream/Stream_0';
% Analog 0 is Electrode Data, 1 is Auxillary, 2 is Digital
% maybe change these names later?
    % DataSets
    %ChannelDataTimeStamps = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_0/ChannelDataTimeStamps');
    ChannelDataA_0 = cast(h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_0/ChannelData')', 'double');
        %Channel Data comes flipped from what is said in MCS hdf5 organization, hence transposition
    InfoChannelA_0 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_0/InfoChannel');
        % Attributes in InfoChannelA-0 are nested within a structure.
        %RawDataType = InfoChannelA_0.RawDataType;
        
        % filter related
        %HighPassType = InfoChannelA_0.HighPassFilterType;
        %HighPassCutOff = InfoChannelA_0.HighPassFilterCutOffFrequency;
        %HighPassOrder = InfoChannelA_0.HighPassFilterOrder;
        %LowPassType = InfoChannelA_0.LowPassFilterType;
        %LowPassCutOff = InfoChannelA_0.LowPassFilterCutOffFrequency;
        %LowPassOrder = InfoChannelA_0.LowPassFilterOrder;
        
        % location related
        %RowIndex = InfoChannelA_0.RowIndex;                                % Row # of this channel in ChannelData matrix   
        WellLabel = InfoChannelA_0.GroupID;                                % Well number for those channels 
        ChannelID = InfoChannelA_0.ChannelID;                             % Indiv electrode channel numbers
        ElectrodeLayoutLabel = int32(cellfun(@str2double, InfoChannelA_0.Label));      % electrode number attached to location
        

        % Used for analysis
        %Unit = InfoChannelA_0.Unit;                                        % Shows Units here as in V, should convert to mV or uV
        %ADCBits = InfoChannelA_0.ADCBits;
        Tick = InfoChannelA_0.Tick;
        Exponent = cast(InfoChannelA_0.Exponent, 'double');                % Exponent 10^n that the channels are multiplied by
        ADZero = cast(InfoChannelA_0.ADZero, 'double');
        ConversionFactor = cast(InfoChannelA_0.ConversionFactor, 'double');% Conversion factor for ADC-Step -> Measured Value
        SamplingRate = 1000000/Tick(1);

% AnalogStream1 = '/Data/Recording_0/AnalogStream/Stream_1';
%  ChannelDataA_1 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_1/ChannelData')';
%     ChannelDataTimeStamps1 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_1/ChannelDataTimeStamps');
%     InfoChannelA_1 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_1/InfoChannel');
%         %Attributes in InfoChannelA-1 are nested within a structure.
%         %RawDataType1 = InfoChannelA_1.RawDataType;
%         ChannelID1 = InfoChannelA_1.ChannelID;
%         RowIndex1 = InfoChannelA_1.RowIndex;
%         WellLabel1 = InfoChannelA_1.GroupID;
%         ElectrodeLabelforLayout1 = InfoChannelA_1.Label;
%         Unit1 = InfoChannelA_1.Unit;
%         Exponent1 = InfoChannelA_1.Exponent;
%         ADZero1 = InfoChannelA_1.ADZero;
%         Tick1 = InfoChannelA_1.Tick;
%         ConversionFactor1 = InfoChannelA_1.ConversionFactor;
%         ADCBits1 = InfoChannelA_1.ADCBits;
%         HighPassType1 = InfoChannelA_1.HighPassFilterType;
%         HighPassCutOff1 = InfoChannelA_1.HighPassFilterCutOffFrequency;
%         HighPassOrder1 = InfoChannelA_1.HighPassFilterOrder;
%         LowPassType1 = InfoChannelA_1.LowPassFilterType;
%         LowPassCutOff1 = InfoChannelA_1.LowPassFilterCutOffFrequency;
%         LowPassOrder1 = InfoChannelA_1.LowPassFilterOrder;

% AnalogStream2 = '/Data/Recording_0/AnalogStream/Stream_2';
%  ChannelDataA_2 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_2/ChannelData')';
%     ChannelDataTimeStamps2 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_2/ChannelDataTimeStamps');
%     InfoChannelA_2 = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_2/InfoChannel');
%         %Attributes in InfoChannelA-2 are nested within a structure.
%         %RawDataType2 = InfoChannelA_2.RawDataType;
%         ChannelID2 = InfoChannelA_2.ChannelID;
%         RowIndex2 = InfoChannelA_2.RowIndex;
%         WellLabel2 = InfoChannelA_2.GroupID;
%         ElectrodeLabelforLayout2 = InfoChannelA_2.Label;
%         Unit2 = InfoChannelA_2.Unit;
%         Exponent2 = InfoChannelA_2.Exponent;
%         ADZero2 = InfoChannelA_2.ADZero;
%         Tick2 = InfoChannelA_2.Tick;
%         ConversionFactor2 = InfoChannelA_2.ConversionFactor;
%         ADCBits2 = InfoChannelA_2.ADCBits;
%         HighPassType2 = InfoChannelA_2.HighPassFilterType;
%         HighPassCutOff2 = InfoChannelA_2.HighPassFilterCutOffFrequency;
%         HighPassOrder2 = InfoChannelA_2.HighPassFilterOrder;
%         LowPassType2 = InfoChannelA_2.LowPassFilterType;
%         LowPassCutOff2 = InfoChannelA_2.LowPassFilterCutOffFrequency;
%         LowPassOrder2 = InfoChannelA_2.LowPassFilterOrder;

%% Display Basic Info from File
%HighPassType = InfoChannelA_0.HighPassFilterType;
        %HighPassCutOff = InfoChannelA_0.HighPassFilterCutOffFrequency;
        %HighPassOrder = InfoChannelA_0.HighPassFilterOrder;

%LowPassType = InfoChannelA_0.LowPassFilterType;
        %LowPassCutOff = InfoChannelA_0.LowPassFilterCutOffFrequency;
        %LowPassOrder = InfoChannelA_0.LowPassFilterOrder;
%% Piecing data together prelim
% recreating the raw signal based on the electrode data from ChannelDataA_0
% equation for recreation taken from MCS hdf5 file explanation

[NumOfChannels, TimeIndex] = size(ChannelDataA_0);                          % Get Channel number and Time Index from the size of the data, set up to futureproof
RawSignal = zeros(NumOfChannels, TimeIndex);                                % Preallocate the array

% Plotting raw signal and recreating
% plotting commented out for now

%figure  
%hold on

for i = 1:NumOfChannels
    RawSignal(i, :) = (ChannelDataA_0(i, 1:TimeIndex) - ADZero(i)) * (ConversionFactor(i) / (10 .^ (abs(Exponent(i) + 6))));
end

%plot(1:TimeIndex, RawSignal)
%hold off

%% Adding on Well and Electrode Label
WorkingData = horzcat(WellLabel, ElectrodeLayoutLabel, RawSignal);

clearvars -except WorkingData TimeIndex NumOfChannels SamplingRate DurationS

%% Setting up the matrix to put the data into
% Initialize a structure to hold the channel matrices for each well
WellMatrices = struct();

% Assign channel labels to the correct positions in the matrix
% Now, ElectrodePosition is a containers.Map with keys as integers, not strings
ElectrodePosition = containers.Map('KeyType', 'double', 'ValueType', 'any');
ElectrodePosition(21) = [1, 2];
ElectrodePosition(31) = [1, 3];
ElectrodePosition(12) = [2, 1];
ElectrodePosition(22) = [2, 2];
ElectrodePosition(32) = [2, 3];
ElectrodePosition(42) = [2, 4];
ElectrodePosition(13) = [3, 1];
ElectrodePosition(23) = [3, 2];
ElectrodePosition(33) = [3, 3];
ElectrodePosition(43) = [3, 4];
ElectrodePosition(24) = [4, 2];
ElectrodePosition(34) = [4, 3];

% Get unique well labels
WellLabel = unique(WorkingData(:, 1));

% Go through each well
for i = 1:numel(WellLabel)
    Well = WellLabel(i);

    % Get the data for this well
    WellData = WorkingData(WorkingData(:, 1) == Well, :);

    % Create the empty 4x4 matrix
    ChannelMatrix = cell(4, 4);

    % Go through each channel in the well data
    for ElectrodeLabel = ElectrodePosition.keys
        ElectrodeLabel = ElectrodeLabel{1};

        % If the channel label is in the well data, store it in the correct position
        if ismember(ElectrodeLabel, unique(WellData(:, 2)))
            Position = ElectrodePosition(ElectrodeLabel);
            ChannelMatrix(Position(1), Position(2)) = num2cell(ElectrodeLabel);
        end
    end

    % Store the channel matrix in the well_matrices structure
    WellMatrices.(sprintf('well_%d', Well)) = ChannelMatrix;
end

%% Print each well's channel matrix
WellID = fieldnames(WellMatrices);
for i = 1:numel(WellID)
    WellLabel = WellID{i};
    ChannelMatrix = WellMatrices.(WellLabel);
    fprintf('Well Label: %s\n', WellLabel);
    fprintf('Channel Matrix:\n');
    disp(ChannelMatrix);
    fprintf('\n');
end


%%
% Define the mapping from well number to well label
well_mapping = containers.Map('KeyType', 'double', 'ValueType', 'char');
rows = 'ABCD';
for well = 1:24
    row = rows(ceil(well / 6));
    col = mod(well - 1, 6) + 1;
    well_mapping(well) = [row num2str(col)];
end

% Print each well's channel matrix with the new well labels
WellNames = fieldnames(WellMatrices);
for i = 1:numel(WellNames)
    WellNumber = str2double(WellNames{i}(6:end));  % Extract the well number from the field name
    WellLabel = well_mapping(WellNumber);  % Get the new well label from the mapping
    ChannelMatrix = WellMatrices.(WellNames{i});
    fprintf('Well Label: %s\n', WellLabel);
    fprintf('Channel Matrix:\n');
    disp(ChannelMatrix);
    fprintf('\n');
end

