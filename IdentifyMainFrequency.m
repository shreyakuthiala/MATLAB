function strongestFreq = IdentifyMainFrequency(wave,sampleRate,makePlot)
%MAINFREQ inputs an audio vector, plots the frequency spectrum, identifies
%the most promiment component frequency in the signal.

% Author: Shreya Kuthiala (Nov 29 2022)

%% CHECK INPUTS AND APPLY DEFAULTS

if ~isnumeric(wave) && ~isStringScalar(wave) && ~ischar(wave)  % checks if the input aligns with the requirements
    error('First input must be a filename (in quotes) or numeric.') % creates error message if input does not align with requirements % redefines wave as imported audio from file
elseif ischar(wave)     % checks if input is characters
    if isfile(wave)     % checks if input is a filename
        [y, Fs] = audioread(wave);  % reads audio file for wave input
        wave = y;   % reassigns y as wave
            if nargin < 2 || isempty(sampleRate)
                sampleRate = Fs;    % reassigns Fs as sampleRate
            end
    end
elseif (nargin < 2 || isempty(sampleRate)) && isnumeric(wave)
    sampleRate = 44100;     % default sampleRate
end
 
if nargin > 2   % checks if there are more than 2 inputs
    if ~isnumeric(sampleRate) || isscalar(sampleRate) || (sampleRate > 0) == 0
        error('Second input must be a positive numeric scalar.')    % creates error message
    end
end

if ismatrix(wave)   % checks if the first input is a matriz
    wave = wave(:);  % vectorizes wave (converts to single column row vector)
end

if ~isnumeric(sampleRate) || ~(sampleRate>0) || ~isscalar(sampleRate)    % if sampleRate is not a positive numeric scalar
    error('Second input must be a positive numeric scalar.')    % creates error message
end

if nargin < 3 || isempty(makePlot)  % if there is no input or empty
    makePlot = true;    % sets makePlot to true
end
%% ANALYZE COMPONENT FREQUENCIES

waveNumSamples = size(wave, 1);   % finds number of samples
nyquistFreq = sampleRate / 2;   % highest representable frequency

frequencies = linspace(-nyquistFreq, nyquistFreq, waveNumSamples); % create vector of frequencies
fftWave = fftshift(fft(wave));    % converts sound from time domain to frequency domain
magnitudes = abs(fftWave);     % converts frequency-domain vector to vector of magnitude
maxMag = max(magnitudes);    % finds maximum magnitude value
indexMaxMag = (magnitudes == maxMag);   % finds index of max magnitude

strongestFreq = max(frequencies(indexMaxMag));    % finds corresponding frequency with the highest magnitude
%% PLOT FREQUENCY SPECTRUM

figure(1)   % opens figure 1 window

if makePlot == true
    subplot(3,1,1)  % selects position 1 in 3x1 grid of plots
    plot(frequencies, magnitudes);  % plots frequency spectrum
    xlabel('Frequency(Hz)')  % x-axis label
    ylabel('Magnitude') % y-axis label
    xlim([0 max(frequencies)]); % creates x limits
    title([num2str(frequencies) 'Magnitudes of Component Frequencies']) % title
    hold on
    scatter(strongestFreq, maxMag, "red") % puts red circle around magnitude at strongest frequency
    hold off
end

end