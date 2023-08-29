%% Author: Shreya Kuthiala, February 2023
% This program will conduct a simple experiment examining how sound effects
% can affect perception of an ambiguous animation.

%% GENERAL SETUP
clear all;                      %clear variables in other settings
clc;                            %clear command window
rng shuffle                     %seed rng using current time
close all;                      %close figure windows
sca;                            %close PsychToolbox windowsSkip intro/debug and start screen setup

% Setting up Audio
InitializePsychSound(1) ; % initializes the audio driver
numAudioChannels = 1;   % number of unique audio channels
try % try using 44100 Hz sample rate
    audioSampleRate   = 44100 ;    
    audioPortBonk = PsychPortAudio('Open', [], [], [], audioSampleRate, 2) ; % audio port pointer for bonk tone
catch % if that produced an error, use 48000 Hz sample rate instead
    fprintf(['\nAttempt to open audio port using 44100 Hz sample rate failed. ' ...
        'Using 48000 Hz instead.\n\n'])
    audioSampleRate   = 48000 ; % audio port pointer for bonk tone
    audioPortBonk = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels) ;
end

audioPortWhoosh  = PsychPortAudio('Open', [], [], [], audioSampleRate, numAudioChannels) ; % audio port pointer for whoosh tone

Screen('Preference', 'ConserveVRAM', 8192) ;
PsychDebugWindowConfiguration
Screen('Preference','VisualDebugLevel',1);      % suppress PsychToolbox Welcome screen
Screen('Preference','SkipSyncTests',1);         % skip sync testing that causes error
PsychDefaultSetup(1);                           % use 0-to-255 coding for colors (OK if you use 0-to-1)
allScreenNums = Screen('Screens');              % vector of screen numbers for available monitors
mainScreenNum = max(allScreenNums);             % screen number of the "main" monitor
backgroundColor = [0 0 0];                      % black background color
w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor);       % open a full-screen window
Screen('BlendFunction',w,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');  % make drawing smoother (anti-aliasing)
% HideCursor % hides mouse cursor

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
keyLeftShift = min(KbName('LeftShift')) ; % key-number for the 'leftshift' key
keyRightShift  = min( KbName('RightShift')); % key-number for the 'rightshift' key
keySpace = min(KbName('space')); % key-number for the 'space' key
keyR = min(KbName('r'));    % key-number for the 'r' key
keyNumTop2 = min(KbName('2@')); % key-number for the 2@ key

%GetEchoString setup
Screen('TextBounds',w,' ');                         % This should get rid of issues w/ aliasing in GetEchoString

% define subject-number prompt text, and get coordinates to center it
subjIDPromptText    = 'Enter subject number:'                   ; % subject-number prompt text
subjIDPromptDimRect = Screen('TextBounds', w, subjIDPromptText) ; % rect giving dimensions of text box
subjIDPromptWidth   = subjIDPromptDimRect(3)                    ; % width  of text box
subjIDPromptHeight  = subjIDPromptDimRect(4)                    ; % height of text box
subjIDPromptX       = xmid - subjIDPromptWidth  / 2             ; % x-coordinate for left edge prompt text
subjIDPromptY       = ymid - subjIDPromptHeight / 2             ; % y-coordinate for top  edge of prompt text box

%% ANIMATION SETUP

bballImage = imread('basketball.png');  % imports image into RGB array
flipInterval = Screen('GetFlipInterval', w); % flip interval of monitor (seconds/frame)

ballDiameter = round(1/10 * wHeight);
squareWidth = ballDiameter * 2;

bballSize = size(bballImage);   % size of image
bballWidthToHeightRatio = bballSize(2) / bballSize(1);  % width to height ratio

bballHeight = ballDiameter * BBWidthToHeightRatio; % creates height for given width using proportions
BBWidthToHeightRatio = sizeBB(2)/sizeBB(1);  %gets width to height ratio

ballRect1 = [0 wHeight-bballHeight ballDiameter wHeight];    % starting position for ball 1
ballRect2 = [wWidth-ballDiameter 0 wWidth bballHeight];      % starting position for ball 2

squareColor = [110 110 110];    % color of square (grey)
squareRect = [xmid-greySquareWidth/2 ymid-greySquareWidth/2 xmid+greySquareWidth/2 ymid+greySquareWidth/2]; %creates rect for square

totalAniSecs = 4; % duration of animation
totalAniFrames = round(totalAniSecs / flipInterval); % convert above to the number of frames the complete animation will take

totalTravelPixels = wWidth - squareWidth; % total number of pixels the circle will travel

pixelsPerFrameX = (wWidth  - ballDiameter) / totalAniFrames ; % number of pixels to move the image horizontally each frame
pixelsPerFrameY = (wHeight - ballDiameter) / totalAniFrames ; % number of pixels to move the image vertically each frame

travelWidth = wWidth - ballDiameter; % width picture will travel
travelHeight = wHeight - bballHeight; % height picture will travel
pixelsPerFrameWidth = travelWidth/totalAniFrames; % pixels of width to travel
pixelsPerFrameHeight = travelHeight/totalAniFrames; % pixels of height to travel

bballTexture = Screen('MakeTexture', w, bballImage);    % makes texture

%% GENERATE AUDIO

sineFreq       = 50 ; % frequency in Hz
sineLengthSecs = .2 ; % duration in seconds
oversaturation = 5  ; % level of oversaturation
sineTone        = MakeBeep(sineFreq, sineLengthSecs, audioSampleRate); % audio vector for sine-wave tone
sineToneOversat = sineTone * oversaturation; % distorted sine-wave tone
fadeOut4Bonk    = linspace(1, 0, numel(sineToneOversat)); % fade-out vector for bonk
bonk            = sineToneOversat .* fadeOut4Bonk; % applying fade-out to oversaturated sine-wave tone
bonk(bonk >  1) =  1; % clip peaks wherever they exceed 1
bonk(bonk < -1) = -1; % clip troughs wherever they go lower than -1
bonk            = repmat(bonk, numAudioChannels, 1); % replicate bonk into designated number of channels


noiseLengthSecs     = .2; % duration in seconds
fadeExp             = 6; % determine steepness of fade-in
noiseLengthSamples  = noiseLengthSecs * audioSampleRate; % duration of noise 
whiteNoise          = randn(1, noiseLengthSamples); % Gaussian white noise 
whiteNoise(whiteNoise >  1) =  1; % clip peaks in white noise wherever they exceed 1
whiteNoise(whiteNoise < -1) = -1; % clip troughs in white noise wherever they go lower than -1
fadeIn4WhiteNoise           = linspace(0, 1, numel(whiteNoise)) .^ fadeExp; % fade-in vector for white noise
whoosh              = whiteNoise .* fadeIn4WhiteNoise; % make whoosh sound 
whoosh              = repmat(whoosh, numAudioChannels, 1); % replicate whoosh into designated number of channels


PsychPortAudio('FillBuffer', audioPortBonk, bonk) ;
PsychPortAudio('FillBuffer', audioPortWhoosh, whoosh) ;

%% PREPARE VECTORS

numTrials = 20; % number of trials
numTrialTypes = 2;  % types of trials

trialTypeTemp = repelem([1 2], 1, numTrials/2); % unshuffled trial types
trialType = Shuffle(trialTypeTemp); % shuffled trial types

% shuffle so that trial-types vector does not have 2 like trial-types in a row
 while any( strfind(diff(trialType),[0 0]))
     trialType = Shuffle(trialTypeTemp);
 end

bounceOrPass = NaN(1, numTrials);
responseTime = NaN(1, numTrials);

%% PRIME FUNCTIONS

GetMouse;
GetSecs;
KbWait(-1, 1) ; % priming KbWait & KbCheck
RestrictKeysForKbCheck([]);
DrawFormattedText(w, '');
Screen('FillRect', w, backgroundColor);
Screen('Flip', w);
PsychPortAudio('Start', audioPortBonk);
PsychPortAudio('Stop' , audioPortBonk);

%% ENTER SUBJECT NUMBER

% input subject ID number
isSubjIDValid = 0 ;  % initialize logical flag indicating whether a valid subject ID number has been entered
while ~isSubjIDValid % stay in while-loop until valid subject ID number is entered

    subjIDChar = GetEchoString(w, 'Enter subject number: ', subjIDPromptX, ...
        subjIDPromptY, mainTextColor, backgroundColor); % get subject ID as character array
    Screen('FillRect', w, backgroundColor) ; % draw full-screen rectangle so that text will be erased on the next 'Flip'
    subjID = str2double(subjIDChar) ; % convert the entered subject ID from character array to numeric value
    if ismember(subjID, 1:1000)       % if entered subject ID is a whole number between 1 and 1000 inclusive

        outputFileName = ['psych20bhw6_subj' subjIDChar '.mat'] ; % filename for subject's data

        if ~exist(outputFileName, 'file') % if filename for this subject doesn't already exist in the directory...
                isSubjIDValid = 1 ;           % ...then subject ID is valid; updatelogical flag to break while-loop
        else                              % otherwise, display warning below

            DrawFormattedText(w, ['WARNING: Data already exist for subject number '
                num2str(subjID) ' and will be overwritten.\n\nFilename: ' ...
                outputFileName '\n\nPress spacebar to continue anyway, or ' ...
                'press ''r'' to re-enter subject number.'], 'center', ...
                'center', warningTextColor); % draw warning text
            Screen('Flip', w) ; % put that text on the screen

            RestrictKeysForKbCheck([keyNumR keyNumSpace]) ; % ignore all keys except 'r' and spacebar
            [~, keyCode]  = KbWait(-1)                    ; % wait for 'r' or space to be pressed, get vector of key-statuses
            isSubjIDValid = keyCode(keyNumSpace)          ; % if spacebar pressed,accepted the entered subject ID; otherwise, stay in loop
            RestrictKeysForKbCheck([])                    ; % stop ignoring keys
        end
    else % if entered subject ID is not a whole number between 1 and 1000 inclusive, display error message below
        DrawFormattedText(w, ['SUBJECT ID MUST BE WHOLE NUMBER\nBETWEEN 1 ' ...
            'AND 1000 INCLUSIVE'], 'center', 'center', warningTextColor) ; % error message
        Screen('Flip', w') ; % put error message on screen
        WaitSecs(2)        ; % hold error message on screen for 2 seconds
    end
end

%% EXPERIMENT

Screen('FillRect', w, backgroundColor);  % clears screen
DrawFormattedText(w, ['In each round of this experiment, you will see two ' ...
    'moving basketballs.\n\nThen you will press Left-Shift if they looked ' ...
    'like they bounced off each other,\nor press Right-Shift if they looked' ...
    ' like they passed through or by each other.\n\nPress the spacebar to begin.'], ...
    'center', 'center', mainTextColor); % instructions
Screen('Flip', w);  % put text on screen
flip = 0;
keyCode = zeros(1,256);         %initializes vector of 0s for no keys pressed
RestrictKeysForKbCheck(keyNumSpace) ; % ignore all keys except spacebar
[~, keyCode]  = KbWait(-1); % wait for space to be pressed, get vector of key-status

for iTrial = 1:numTrials
    while ballRect1(3) <= wWidth || ballRect1(1) > 0 % when balls are in start position
        Screen('DrawTexture', w, bballTexture, [], ballRect1); % draws first basketball
        Screen('DrawTexture', w, bballTexture, [], ballRect2); % draws second basketball
        Screen('FillRect', w, squareColor, squareRect); % creates grey square
        Screen('Flip', w); % flips on to screen

        flip = flip + 1; % adds one with each flip, counting flips
        ballRect1 = ballRect1 + [pixelsPerFrameWidth 0 pixelsPerFrameWidth 0] - [0 pixelsPerFrameHeight 0 pixelsPerFrameHeight];%moves ball by changing rect
        ballRect2 = ballRect2 - [pixelsPerFrameWidth 0 pixelsPerFrameWidth 0] + [0 pixelsPerFrameHeight 0 pixelsPerFrameHeight]; %moves ball by changing rect

        if flip == round(totalAniFrames/2) % when halfway through animation
            if trialType(iTrial) == 1 % if trial type == 1
                PsychPortAudio('Start', audioPortBonk); % play bonk sound
            else % if trial type == 2
                PsychPortAudio('Start', audioPortWhoosh); %play whoosh sound
            end
        end
    end

    DrawFormattedText(['Press Left-Shift if the balls looked like they bounced ' ...
        'off each other.\n\nPress Right-Shift if the balls looked like they ' ...
        'passed through or by each other.\n'], 'center', 'center', mainTextColor);
    flipTime = Screen('Flip', w) ; % put text on screen, and get timestamp

    keyCode = zeros(1,256);         %initializes vector of 0s for no keys pressed

    while ~keyCode(keyLeftShift) && ~keyCode(keyRightShift)            %while loop until space bar is pressed
        [~, keySecs, keyCode] = KbCheck(-1); %gets current time stamp and vector of key statuses
        if keyCode(keyLeftShift) == 1 %if left key pressed
            bounceOrPass(iTrial) = 1; %encodes response
        else %if right shift key
            bounceOrPass(iTrial) = 2;
        end %ends loop
    end %ends loop
    responseTime(iTrial) = flipTime - keySecs; %calculates response time
    save(outputFileName, "wWidth", "wHeight", "flipInterval", "audioSampleRate", "subjID", "trialType", "bounceOrPass", "responseTime"); %saves file and variables
    ball1Rect = [0 wHeight-bballHeight ballDiameter wHeight];    %restarts starting position for ball 1
    ball2Rect = [wWidth-ballDiameter 0 wWidth bballHeight];      %restarts starting position for ball 2
    flip = 0; %resets flip value
end %ends for loop
DrawFormattedText(w, 'That''s the end of the experiment.\n\nThank you for participating!', 'center', 'center', mainTextColor); %creates message
Screen('Flip', w); %flips message to screen

%% EXIT

RestrictKeysForKbCheck([]) ; % stop disregarding keys
while GetSecs < timerStart + 1
    [~, ~, keyCode     ] = KbCheck(-1) ; % get vector of current key-statuses
    [~, ~, mouseButtons] = GetMouse    ; % get mouse button statuses 

    % restart timer unless 2@ (and no other key) and at least 1 mouse button is being pressed
    if ~keyCode(keyNumTop2) ||  ~any(mouseButtons)
        timerStart = GetSecs ;
    end
end

PsychPortAudio('Close') ; % close audio ports
ListenChar(1)           ; % restore keyboard output to Matlab window
sca % close Psychtoolbox window, restore mouse-cursor
