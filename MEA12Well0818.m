%% Pull data into Matlab
clc; clear all; close all;

% Specify the path to the H5 file
FileName = '20230525_Healthy.NM.h5'; %defining as filename here to improve readibility

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
   DurationS = h5readatt(FileName, Recording_0, 'Duration')/(1*10^6);

%AnalogStream = '/Data/Recording_0/AnalogStream';
    %AnalogStream is only organizational; contains no attributes or data

%AnalogStream0 = '/Data/Recording_0/AnalogStream/Stream_0';
% Analog 0 is Electrode Data, 1 is Auxillary, 2 is Digital
% maybe change these names later?
    % DataSets
    %ChannelDataTimeStamps = h5read(FilePath, '/Data/Recording_0/AnalogStream/Stream_0/ChannelDataTimeStamps');
    ChannelDataA_0 = cast(h5read(FileName, '/Data/Recording_0/AnalogStream/Stream_0/ChannelData')', 'double');
        %Channel Data comes flipped from what is said in MCS hdf5 organization, hence transposition
    InfoChannelA_0 = h5read(FileName, '/Data/Recording_0/AnalogStream/Stream_0/InfoChannel');
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
        %ChannelID = InfoChannelA_0.ChannelID;                              % Indiv electrode channel numbers
        WellLabel = InfoChannelA_0.GroupID;                                % Well number for those channels 
        ElectrodeLayoutLabel = int32(cellfun(@str2double, InfoChannelA_0.Label));      % electrode number attached to location
        
        % Used for analysis
        %Unit = InfoChannelA_0.Unit;                                       % Shows Units here as in V, should convert to mV or uV
        %ADCBits = InfoChannelA_0.ADCBits;
        SamplingRate = cast(1000000/InfoChannelA_0.Tick(1), 'double');                     % 1000000/Tick as seen in hdf5 mcs conversion file
        Exponent = cast(InfoChannelA_0.Exponent, 'double');                % Exponent 10^n that the channels are multiplied by
        ADZero = cast(InfoChannelA_0.ADZero, 'double');
        ConversionFactor = cast(InfoChannelA_0.ConversionFactor, 'double');% Conversion factor for ADC-Step -> Measured Value

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

%% Resample if necessary
% resamples the system by a factor of q/p
%in this case
p = 1;
q = 2;
RawSignal = resample(RawSignal', p, q)';
[NumOfChannels, TimeIndex] = size(RawSignal);

SamplingRate = SamplingRate * (p/q);
%% Adding on Well and Electrode Label
WorkingData = horzcat(WellLabel, ElectrodeLayoutLabel, RawSignal);

clearvars -except WorkingData TimeIndex NumOfChannels SamplingRate DurationS
save ('WorkingData.08.18.mat', 'WorkingData','TimeIndex','NumOfChannels','SamplingRate','DurationS', '-v7.3');

%% Load downsamples if necessary

clear all; clc; close all;
load ('WorkingData.07.13.mat')


%% Removed well layout as its not necessary rn
% work on getting the signal processing and THEN do the fancy stuff.
% figure out visualization of the signal with a scroll bar
% make a lil UI?

SamplingPeriod = 1/SamplingRate;
n = 0:TimeIndex-1;
t = n.*SamplingPeriod;


figure
plot(Time(1:50)), WorkingData((:15), (3:52)))
ylabel('voltage in uV? Need to double check'), xlabel('Indiv Sampling Points not seconds') 

%%

