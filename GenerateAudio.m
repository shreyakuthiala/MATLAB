% Author: Shreya Kuthiala (Nov. 24, 2022)
% This program will generate 3 pieces of audio, then play those pieces of
% audio, then save those pieces of audio to .wav files. 

clear   % clear any previously defined variables
clear sound     % stop any currently playing audio
clc     % clear command window
close all     % close any previously opened figure windows
rng (0)     % sets seed to 0

sampleRate = 44100; % sets sample rate to 44100 samples / second

%% STATIC WHITE NOISE

noiseSecs = 5;   % length of noise in seconds
noiseLengthSample = round(noiseSecs * sampleRate);  % corresponding length in samples
whiteNoise = randn(noiseLengthSample, 1); 
noiseRMS = sqrt(mean(whiteNoise .^ .1));    % RMS of white noise generated
noiseScaled = whiteNoise * 0.1;     % noise rescaled to have desired RMS


%% SWELLING WHITE NOISE

firstHalf = linspace(0, 1, noiseScaled)' ;    % column-vector of linearly increasing values from 0-1
secondHalf = linspace(1, 0, noiseScaled)' ;    % column-vector of linearly decreasing values from 1-0
noiseSwell = cat(firstHalf,secondHalf);


%% MELODY

sampleRate = 44100;
f1 = 800;
f2 = 700;
f3 = 600;
f4 = 500;
toneSecs = 0.5;     % desired tone-duration in seconds

toneNumSamples = ceil(toneSecs * sampleRate);   % number of samples needed for tone-duration
timeVector = (0:toneNumSamples-1) / sampleRate;     % time-vector giving timestamp for each sample in tone

numSilentSamples = ceil(0.10 * sampleRate);     % calculates number of samples for silence
silentBreak = zeros(numSilentSamples, 2);   % creates vector of zeroes for silence


left1 = sin(2 * pi * f1 * timeVector)';
silence = zeros(numel(left1), 1);   % creates silence for one speaker

part1 = [left1 silence];    % creates 1st tone & silence 

right2 = sin(2 * pi * timeVector * f2)';
part2 = [silence right2];

left3 = sin(2 * pi * f3 * timeVector)';
part3 = [part3 silence];

right4 = sin(2 * pi * timeVector * f4)';
part4 = [silence part4];

melody = [part 1; silentBreak; part2; silentBreak; part3; silentBreak; part4]   % combines all the parts together to create a melody


%% RANDOM TONES

toneFreq = randi([500, 5000]);  % creates random generatino of integers between 500-5000
timeVec = (0:1) /sampleRate : 0.1;

randTones = 60 * sin(2 * pi * toneFreq * timeVec)';

%% PLAY AUDIO

fprintf('Playing static white noise')
playblocking(noiseScaled);  % plays noiseScaled audio, waits for audio to finish b4 continuing
pause(1);   % waits for 1 second
fprintf('\n\nPlaying swelling white noise')
playblocking(noiseSwell);   % plays noiseSwell audio, wait for audio to finish b4 continuing
pause(1);   % waits for 1 second
fprintf('Playing melody')
sound(melody, sampleRate);    % plays melody audio
fprintf('Playing random tones')
sound(randTones, sampleRate);   % plays randTones audio
%% SAVE AUDIO

audiowrite('noiseScaled.wav', noiseScaled, sampleRate, 'BitsPerSample', 24); % saves noiseScaled audio
audiowrite('noiseSwell.wav', noiseSwell, sampleRate, 'BitsPerSample', 24);    % saves noiseSwell audio
audiowrite('melody.wav', melody, sampleRate, 'BitsPerSample', 24);  % saves melody audio
audiowrite('randTones.wav', randTones, sampleRate, 'BitsPerSample', 24);    % saves randTones audio


