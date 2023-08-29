%% SETUP
Screen('Preference', 'ConserveVRAM', 8192) ;
PsychDebugWindowConfiguration

clc % clear previously-defined variables from workspace, reset misc settings
close all % close any open figure windows
sca % close any open Psychtoolbox windows

rng shuffle % seed the random number generator based on the current time

Screen('Preference', 'VisualDebugLevel', 1) ; % suppress Psychtoolbox welcome screen
Screen('Preference', 'SkipSyncTests', 1) ; % skip sync testing that causes errors
allScreenNums = Screen('Screens') ; % vector of screen numbers of available monitors
mainScreenNum = max( Screen('Screens') ) ; % screen number of main monitor

backgroundColor = [0 0 0];   % creates RGB triplet for background
w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor) ;
PsychDefaultSetup(1) % use the 0-to-255 scale for RGB color values

%  ListenChar(2) % suppress keyboard output to Matlab window
%  HideCursor % hide the mouse cursor

[wWidth, wHeight] = Screen('WindowSize', w) ; % width and height of window 'w' in pixels
xmid = round(wWidth / 2) ; % horizontal midpoint of window 'w' in pixels
ymid = round(wHeight / 2) ; % vertical midpoint of window 'w' in pixels
xquart = round(xmid  / 2);  % get 1/4 across screen (used in GetEchoString)

Screen('TextFont', w, 'Arial');    % sets font to Arial
Screen('TextSize', w, round(1/30 * wHeight));  % sets font size to 1/30 screen height

KbName('UnifyKeyNames') % use OSX key-name system
keyNumReturn = min(KbName('Return'));
keyNumQ = min(KbName('q'));
keyNumI = min(KbName('i'));
keyNumT = min(KbName('t'));
keyNumSpace = min(KbName('space'));

mainTextColor = [255 255 255];    % defines mainTextColor as white
warningTextColor = [80 33 0];   % defines warningTextColor as burnt orange

% define coordinates to draw to lines forming a cross
lineColor = [0 255 255];    % defines line color
lineX1 = round(wWidth/2); % x-coordinate for line start-point
lineY1 = round(wHeight/2); % y-coordinate for line start-point
lineX2 = xmid;    % x-coordinate for line endpoint
lineY2 = ymid;   % y-coordinate for line endpoint
penWidth = 3;


% define coordinates of quadrants
quadTopLeft = [0 0 xmid ymid] ; % rect defining region of screen for circle
quadTopRight = [xmid wHeight wWidth ymid];
quadBottomLeft = [0 ymid xmid wHeight];
quadBottomRight = [xmid ymid wWidth wHeight];


% define radius as smaller of two values
radius = round(wHeight * 1/8);


subPromptText    = 'Enter subject number:'      ; %  prompt text
subPromptDimRect = Screen('TextBounds', w, subPromptText) ; % rect giving dimensions of prompt text
subPromptWidth   = subPromptDimRect(3)                    ; % width  of prompt text
subPromptHeight  = subPromptDimRect(4)                    ; % height of prompt text
subPromptX       = xmid - subPromptWidth  / 2             ; % x-coordinate for left edge of prompt text
subPromptY       = ymid - subPromptHeight / 2             ; % y-coordinate for top 


 % prime Psychtoolbox functions now to avoid delays when first used in the experiment
 KbCheck;
 KbWait([], 1);
 RestrictKeysForKbCheck([]);
 Screen('GetFlipInterval', w);
 KbPressWait(-1);
 WaitSecs(0);
 DrawFormattedText(w, '');
 Screen('FillRect', w, backgroundColor);
 Screen('Flip', w);

%% PREPARE VECTORS

trialNums = [1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4];  % returns an array of 20 random values between 1 and 4
trialShuffleOrder = randi(4); % integers 1-4 in random order
trialType = trialNums(trialShuffleOrder); % shuffled trial nums

delayNominal = unifrnd(3,6,20);

avgFlipInterval = Screen('GetFlipInterval', w);    % average flip interval of the monitordelayAdjusted = 

delayAdjusted = NaN(1,20);  % creates 1 x 20 vector of NaN values
% avgFlipInterval / 2;  % half flip-interval

delayActual = NaN(1,20); % creates 1 x 20 vector of NaN values

rt = NaN(1, 20);    % creates 1 x 20 vector of NaN values
%% ENTER SUBJECT NUMBER

isSubNumValid = false ;  % initialize flag indicating whether a valid subject number has been entered

while ~isSubNumValid % stay in while-loop until valid age entered
    subChar = GetEchoString(w, subPromptText, subPromptX, subPromptY, mainTextColor, backgroundColor) ; % input subject number as character array
    Screen('FillRect', w, backgroundColor) ; % draw full-screen filled rectangle so GetEchoString text will be erased on next 'Flip'
    subjectNum = str2double(subChar) ; % convert subject number from character array to number

    if ismember(subjectNum, 1:1000) % if valid subject number (interger between 1 and 1000, inclusive) was entered...
        isSubNumValid = true ;  % ...update isSubNumValid flag (breaking the while-loop)
   
 else  % if invalid age entered...
        DrawFormattedText(w, 'INVALID SUBJECT NUMBER', 'center', 'center', warningTextColor) ; % draw error message
        Screen('Flip', w) ;  % displays error message
    end
end
%% EXPERIMENT

Screen('FillRect', w, backgroundColor) ; % clears screen

DrawFormattedText(w, 'In each round of this experiment, you will see a cross\ndividing ' + ...
    'the screen into four sections.\n\nAfter a few seconds, a circle will ' + ...
    'appear\nin one of the sections.\n\nYour task is to press the spacebar\nas' + ...
    'quickly as possible when you notice the circle.\n\nPress Return to begin.\n', ...
    'center', 'center', mainTextColor);     % draws instructions

Screen('Flip', w);  % displays instructions

RestrictKeysForKbCheck(keyNumReturn) ; % ignore all keys except 'return'
KbPressWait(-1)                     ; % wait for fresh key-press
Screen('FillRect', w, backgroundColor) ; % clears screen


for iTrial = 1:20

    RestrickKeysForKbCheck([]); % stop ignoring keys
   
    % displays cyan-colored cross
    Screen('DrawLine', w, lineColor, lineX1, lineY1, lineX2, lineY2 - 200, penWidth);
    Screen('DrawLine', w, lineColor, lineX1, lineY1, lineX2 + 200, lineY2, penWidth);
    Screen('DrawLine', w, lineColor, lineX1, lineY1, lineX2, lineY2 + 200), penWidth;
    Screen('DrawLine', w, lineColor, lineX1, lineY1, lineX2 - 200, lineY2, penWidth);
    Screen('Flip', w);  % puts line on screen

    % display type of shape
    circleColor = [0 0 255] ; % circle color

    % define 4 rects for circle position
    circleTopLeft = [(xmid/2- radius) (ymid/2 - radius) (xmid/2 + radius) (ymid/2 + radius)]; %rect for top left circle
    circleTopRight = [(threeQuartersWidth - radius) (ymid/2 - radius) (threeQuartersWidth + radius) (ymid/2 + radius)]; %rect for top right circle
    circleBottomLeft = [(xmid/2 - radius) (threeQuartersHeight - radius) (xmid/2 + radius) (threeQuartersHeight + radius)]; %rect for bottom left circle
    circleBottomRight= [(threeQuartersWidth - radius) (threeQuartersHeight - radius) (threeQuartersWidth + radius) (threeQuartersHeight + radius)]; %rect for bottom right circle
    circlePenWidth = 2; % "pen width" (line thickness in pixels) for rectangle
    
    refTime = GetSecs ; % timestamp for current moment (used as reference)

    if trialType == 1
        Screen('FillOval', w, circleColor, circleTopLeft) ; % draw circle
        Screen('Flip', w, refTime + delayNominal) ; % put circle on the screen
    elseif trialType == 2
        Screen('FillOval', w, circleColor, circleTopRight) ; % draw circle
        Screen('Flip', w, refTime + delayNominal); % put circle on the screen
    elseif trialType == 3
        Screen('FillOval', w, circleColor, circleBottomLeft) ; % draw circle
        Screen('Flip', w, refTime + delayNominal) ; % put circle on the screen
    elseif trialType == 4
        Screen('FillOval', w, circleColor, circleBottomRight) ; % draw circle
        Screen('Flip', w, refTime + delayNominal) ; % put circle on the screen
    end
   
    % record response time

    RestrictKeysForKbCheck(keyNumSpace) ; % ignore all keys except 'space'
    keyCode = zeros(1,256) ; % initialize vector of key statuses
    while ~keyCode(keyNumSpace) % stay in while-loop til spacebar pressed
        [~, keySecs, keyCode] = KbCheck(-1) ; % current timestamp, vector of key-statuses
    end
    
    rt = keySecs;
    % record actual time in delayActual
    delayActual = refTime - keySecs;

    % clear screen and display text
    Screen('FillRect', w, backgroundColor); % clears screen
    DrawFormattedText(w, 'Press Return to go to the next round.\n)');
    RestrictKeysForKbCheck(keyNumReturn);   % ignore all keys except 'return'
    KbPressWait(-1) % wait for fresh key-press
    
    iTrial = iTrial + 1;
end

Screen('FillRect', w, backgroundColor) ; % draw full-screen filled rectangle so GetEchoString text will be erased on next 'Flip'
DrawFormattedText(w, 'The experiment is complete.\n\nThanks for your participation!', mainTextColor);
Screen('Flip', w);  % displays message


%% SAVE & EXIT

save('psych20bhw3_subj',subjectNum) % save data to file

% wait for 'q' + 'i' + 't' (and no other keys) to be down before exiting
while ~keyCode(keyNumQ)  ||  ~keyCode(keyNumI)  ||  ~keyCode(keyNumT) || sum(keyCode) > 3
    [~, keyCode] = KbWait(-1) ; % get vector of current key-statuses
end
sca             % close Psychtoolbox window, restore mouse-cursor


















