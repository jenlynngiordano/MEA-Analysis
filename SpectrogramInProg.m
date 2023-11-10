%  Spectrogram to check for noise 

% Set up spectrogram parameters
windowSize = 256; % Window size
overlap = 1024;   % Overlap between windows
nfft = 512;      % Number of FFT points
SamplingRate = 20000;       % Sampling frequency (adjust to match your data)

% Loop through each row of data
for i = 1:size(data, 1)
    % Calculate the spectrogram
    [S, F, T] = spectrogram(data(i, :), windowSize, overlap, nfft, SamplingRate);
    
    % Plot the spectrogram
    figure;
    imagesc(T, F, 10*log10(abs(S)));
    axis xy; % Correct the y-axis direction
    
    % Add labels and title
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title(['Spectrogram for Signal ', num2str(i)]);
    
    % Customize the color scale (optional)
    colormap('jet');
    colorbar;
end
