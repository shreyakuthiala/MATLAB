%% Author: Shreya Kuthiala, February 2023
% This proram will conduct an experiment to see if people respond more
% quickly to a tone in their left, right, or both ears simultaneously.

%% GENERAL
clear all;                      %clear variables in other settings
clc;                            %clear command window
rng shuffle                     %seed rng using current time
close all;                      %close figure windows
sca;                            %close PsychToolbox windowsSkip intro/debug and start screen setup

% sample-rate for audio
InitializePsychSound(1);
numAudioChannels = 2;   % audio channel for left, right, both

try % try using 44100 Hz sample rate
    audioSampleRate   = 44100 ;    
    audioPort = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels); 
    
catch % if that produced an error, use 48000 Hz sample rate instead
    fprintf('\nAttempt to open audio port using 44100 Hz sample rate failed. Using 48000 Hz instead.\n\n')
    audioSampleRate   = 48000 ; 
    audioPortToneLeft = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels); %opens left audio port
    audioPortToneRight = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels);%opens right audio port
    audioPortToneDiotic = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels);%opens diotic audio port

end

audioPortLeft = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels);
audioPortRight = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels);
audioPortBoth = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels);

numTrials = 30; % defines number of trials
trialTypeTemp = repelem([1 2 3], 1, numTrials/3);    % unshuffled vector of trial
trialType = trialTypeTemp(randperm(numTrials)); % shuffled vector of trial types

delay = rand(1, numTrials) * (6-3) + 3; % random delay times
rt = NaN(1, numTrials) ; % initialize vector of subject's response-times

PsychDebugWindowConfiguration
Screen('Preference','VisualDebugLevel',1);      %suppress PsychToolbox Welcome screen
Screen('Preference','SkipSyncTests',1);         %Skip sync testing that causes error
PsychDefaultSetup(1);                           %Use 0-to-255 coding for colors (OK if you use 0-to-1)

allScreenNums = Screen('Screens');              %Vector of screen numbers for available monitors
mainScreenNum = max(allScreenNums);             %Screen number of the "main" monitor

backgroundColor = [90 90 90];
w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor);       %open a full-screen window
Screen('BlendFunction',w,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');  %Make drawing smoother (anti-aliasing)

[wWidth, wHeight] = Screen('WindowSize', w) ;   % width and height of screen in pixels
xmid       = round(wWidth  / 2);                % horizontal midpoint of screen in pixels
ymid       = round(wHeight / 2);                % vertical   midpoint of screen in pixels

%Text setup                                
Screen('TextFont',w,'Arial');                       % Set text font 
smallText = round(wHeight/30);                      % smaller text size for prompts
Screen('TextSize',w,smallText);                     % set text size to 1/30 screen height
mainTextColor = [255 255 255];                      % white as  text color
warningTextColor = [80 33 0];                       % warningTextColor as burnt orange

% Keyboard Setup
KbName('UnifyKeyNames')                             % use OSX key-name system
keyNumR = min(KbName('r')) ; % key-number for the 'r' key
keyNumSpace  = min( KbName('space' )); % key-number for the 'space' key
keyNumReturn = min( KbName('return')); % key-number for the 'return' key
keyNumQ = min( KbName('q')) ;   % key-number for the 'q' key
keyNumT = min( KbName('t')) ;   % key-number for the 't' key

%GetEchoString setup
Screen('TextBounds',w,' '); % This should get rid of issues w/ aliasing in GetEchoString

%% PREPARE AUDIO
frequency = 44100; % sampling frequency
duration = 0.5; % duration in seconds

tone = MakeBeep(frequency, duration, audioSampleRate);

% apply linear fadeout

numSamplesPart1 = round(0.45 * audioSampleRate);    % first part of audio
part1 = tone(1:numSamplesPart1);
part2 = tone(numSamplesPart1 : end-1);  % second part of audio

lengthAudio = size(part2, 1);  % numsamples in part 2
fadeOut = linspace(1,0, lengthAudio);

fadedPart2 = part2 .* fadeOut;  % fades last 50ms
wholeFadeOut = [part1 fadedPart2];
reducedToneLR = wholeFadeOut * 0.25;
reducedToneDiotic = wholeFadeOut * 0.25/sqrt(2);

% tone right
toneRight = [zeros(1, numel(reducedToneLR)) ; reducedToneLR];   % creates tone on the right

% tone right
toneLeft = [reducedToneLR ; zeros(1, numel(reducedToneLR))];  % creates tone on the left

% toneDiotic
toneDiotic = [reducedToneDiotic ; reducedToneDiotic];

PsychPortAudio('FillBuffer', audioPortToneLeft , toneLeft);
PsychPortAudio('FillBuffer', audioPortToneRight, toneRight);
PsychPortAudio('FillBuffer', audioPortToneDiotic, toneDiotic);

%% PRIME PSYCHTOOLBOX
WaitSecs(0);
%KbWait([], 1); % this also primes KbCheck, since KbWait uses KbCheck
RestrictKeysForKbCheck([]) ;
DrawFormattedText(w, '') ;
GetMouse;
Screen('FillRect', w, backgroundColor);
Screen('Flip', w);

%% ENTER SUBJECT NUMBER SECTION
% define subject-number prompt text, and get coordinates to center it
subjIDPromptText    = 'Enter subject number:'                   ; % subject-number prompt text
subjIDPromptDimRect = Screen('TextBounds', w, subjIDPromptText) ; % rect giving dimensions of text box
subjIDPromptWidth   = subjIDPromptDimRect(3)                    ; % width  of text box
subjIDPromptHeight  = subjIDPromptDimRect(4)                    ; % height of text box
subjIDPromptX       = xmid - subjIDPromptWidth  / 2             ; % x-coordinate for left edge prompt text
subjIDPromptY       = ymid - subjIDPromptHeight / 2             ; % y-coordinate for top  edge of prompt text box

subNumValid = 0 ;  % initialize boolean indicating whether subject ID number is valid
while ~subNumValid % stay in while-loop until valid subject ID number is entered
    subjIDChar = GetEchoString(w, subjIDPromptText, subjIDPromptX, subjIDPromptY, mainTextColor, backgroundColor) ; % subject ID as character array
    Screen('FillRect', w, backgroundColor) ; % draw full-screen filled rectangle so GetEchoString text will be erased on next 'Flip'

    subjID = str2double(subjIDChar) ;  % convert subject ID from character array to numeric value

    if ismember(subjID, 1:1000) % if entered subject ID is between 1 and 1000 inclusive
        subNumValid = 1  ;    % breaks loop
        outputFileName = ['entersubjiddemoData_subj' num2str(subjID) '.mat'] ; % filename

        if ~exist(outputFileName, 'file') % if filename for this subject doesn't exist already
            subNumValid = 1 ;           % subject ID is valid, break while-loop
        else                              % otherwise, display warning below
            DrawFormattedText(w, ['WARNING: Data already exist for subject number '
                num2str(subjID) ' and will be overwritten.\n\n' 'Filename: ' outputFileName '\n\nPress spacebar to continue anyway, or press ''r'' to re-enter subject number.'], 'center', 'center', warningColor) ;
            Screen('Flip', w) ; % put warning on screen
            [~, keyCode]  = KbWait(-1)           ; % wait for key-press
            subNumValid = keyCode(keyNumSpace) ; % break while-loop
        end
    else                        % otherwise, error message
        DrawFormattedText(w, 'INVALID SUBJECT NUMBER', 'center', 'center', warningTextColor) ; % error message
        Screen('Flip', w') ; % error message
        WaitSecs(1)        ; % wait 1 second
    end
end

% display instructions
DrawFormattedText(w, ['Please put on your headphones.\n\nIn each round of ' ...
    'this experiment,\nyou will hear a tone in the left, right, or center.\n\n' ...
    'Your task is to press the spacebar as quick as possible/nonce you hear ' ...
    'the tone.\n\nPress <Return> to begin.'], 'center', 'center', mainTextColor);   % instructions
Screen('Flip', w);  % flips message onto screen

RestrictKeysForKbCheck(keyNumReturn) ; % ignore all keys except Return
while ~KbCheck(-1)                     % wait for key-press
end

%% EXPERIMENT 
% after subject presses return
Screen('FillRect', w, backgroundColor) ;
DrawFormattedText(w, 'Press <Return> to do another round.', 'center', 'center', mainTextColor);
Screen('Flip', w);  
keyCode = zeros(1, 256);
while ~keyCode(keyNumReturn)
    [~, ~, keyCode] = KbCheck(-1);
end

% for loop with itrial
for iTrial = 1:numTrials
    DrawFormattedText(w, 'Press the spacebar as soon as you hear the tone.', 'center', 'center', mainTextColor);
    Screen('Flip', w);  % flips message onto screen

    textTime = Screen('Flip', w); %flips text, records time stamp

    if trialType(iTrial) == 1 % if 1
        flipTime = PsychPortAudio('Start' , audioPortToneLeft, [], textTime + delay(iTrial), 1); % left tone, get flip time
    elseif trialType(iTrial) == 2 %if condition is 2
        flipTime = PsychPortAudio('Start' , audioPortToneRight, [], textTime + delay(iTrial), 1); % right tone, get flip time
    else % if 3
        flipTime = PsychPortAudio('Start' , audioPortToneDiotic, [], textTime + delay(iTrial), 1); % diotic tone, get flip time
    end %end loop

    while KbCheck(-1)%wait for all keys to be up
    end              %end loop
    while ~keyCode(keyNumSpace)            %while loop until space bar is pressed
        [~, keySecs, keyCode] = KbCheck(-1) ; %gets current time stamp and vector of key statuses
    end
    rt(iTrial) = keySecs - flipTime; % adds response time
    save(outputFileName, 'audioSampleRate', 'trialType', 'delay', 'subjID', 'rt') % saves file
    if iTrial == numTrials %if last trial
        Screen('FillRect', w, backgroundColor); %clear screen
        DrawFormattedText(w, 'That is the end of the experiment.\n\nThanks for your participation.', 'center', 'center', mainTextColor); %create text message
        Screen('Flip', w); %flip message onto screen
    else %if not last trial
        Screen('FillRect', w, backgroundColor); %clear screen
        DrawFormattedText(w, 'Press <Return> to do another round.', 'center', 'center', mainTextColor);
        Screen('Flip', w);
        keyCode = zeros(1,256);         % initializes vector of 0s for no keys pressed
        while ~keyCode(keyNumReturn)       % while loop until return is down
            [~, ~, keyCode] = KbCheck(-1); % waits for return to be pressed
        end  %ends while loop
    end %ends if loop
end %ends for loop

%% EXIT

% wait for mouse buttons q & t pressed down for 1.5 seconds

% One way to accomplish that is to start a 1.5 second timer before the while-loop.
%  Then each time you go through the while-loop, restart the timer if the correct 
% combination isn't being pressed.

keyCode = zeros(1,256) ; % initialize vector of key-statuses
mouseButtons = [0 0 0] ; % initialize vector of mouse-button statuses
t = 0;  % timing variable
tStart = GetSecs;  % time stamp

while ~keyCode(keyNumQ) || ~keyCode(keyNumT) || sum(mouseButtons) == 0 || ~timing % while q and t key and mouse are NOT pressed
[~, ~, mouseButtons] = GetMouse; % mouse info
[~, ~, keyCode] = KbCheck(-1);
t = GetSecs - timeStart > 1.5; % time stamp
end

% standard exit steps
sca             % close Psychtoolbox window, restore mouse-cursor
ListenChar(1) ; % restore keyboard output to Matlab window
PsychPortAudio('Close') ; % close any open audio ports

