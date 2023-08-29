% PSYCH 20B Homework 2
% Matlab program that collects survey data.
% Author: Shreya Kuthiala (2023)

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

backgroundColor = [86 86 86];   % creates RGB triplet for background
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

KbName('UnifyKeyNames');                        % Use Mac-standard name for keys

mainTextColor = [0 0 0];    % defines mainTextColor as black
warningTextColor = [80 33 0];   % defines warningTextColor as burnt orange

%% SURVEY

% BEGIN SURVEY
DrawFormattedText(w, 'Press the spacebar to begin the survey','center', 'center', mainTextColor); % creates text
Screen('Flip', w); % flips text onto screen

keyCode = zeros (1,256) ; % initializes vector of Os for 0 keys pressed

while ~keyCode(keyNumSpace) % while loop until space bar is down
    [~, keyCode] = KbWait(-1); % waits for spacebar to be pressed
end %ends while loop

% ENGLISH?
DrawFormattedText(w, 'Are you a native English speaker?\n\n(Y)Yes\n(N)No','center', 'center', mainTextColor);
Screen( 'Flip', w); % flips text onto screen

keyCode = zeros (1,256) ; % initializes vector of Os for no keys pressed

keyNumYes = min( KbName('y') ) ; % key-number for 'y' key

keyNumNo = min(KbName('n') ) ; % key-number for 'n' key

while ~keyCode(keyNumYes) && ~keyCode(keyNumNo) % while loop until one of two keys is pressed
    [~, keyCode] = KbWait(-1, 2) ; % after all keys are up, wait for key-press, get vector of key-statuses
end

if keyCode (keyNumYes) == 1 %if loop for if Y is pressed
    speakerStatus = 1; % Y = yes
else %keyCode (keyNumNo) == 1
    speakerStatus = 0; % anything else = no
end % ends if loop

KbWait(-1, 1); % waits for all keys to be up

% REGISTERED TO VOTE?
DrawFormattedText(w, 'Are you registered to vote?\n\n(Y)Yes\n(N)No', 'center', 'center', mainTextColor); % asks survey question
Screen('Flip', w);

keyCode = zeros(1,256) ; % initialize vector of key-statuses
while ~keyCode(keyNumYes) && ~keyCode(keyNumNo) % stay in while-loop as long as 'y' is up
    [~, keyCode] = KbWait(-1,2) ; % wait for key-press, get vector of key-statuses
end

if keyCode(keyNumYes)
    voterStatus = 1;
else
    voterStatus = 0;
end

Screen('FillRect', w, backgroundColor) ; % draw full-screen solid rectangle in bkgdColor

KbWait(-1, 1); % waits for all keys to be up

% AGE?
ageChar = GetEchoString(w, 'Please enter your age in whole years:', xquart, ymid, mainTextColor, backgroundColor); % asks survey question
age = str2double(ageChar);  % changes the input from a string to a double


while any(10 > age | age > 100) % while the loop for input is NOT between 10 and 100
    Screen('FillRect', w, backgroundColor);   % clears the screen
    DrawFormattedText(w,'INVALID INPUT', 'center', 'center', warningTextColor); % creates the warning text
    Screen('Flip', w);  % puts text on screen
    WaitSecs(1);    % waits 1 second
    Screen('FillRect', w, backgroundColor) ; % draw full-screen solid rectangle in bkgdColor
    ageChar = GetEchoString(w, 'Please enter your age in whole years:', xquart, ymid, ymid, backgroundColor); % asks survey question
    age = str2double(ageChar);  % changes the input from a string to a double
end


% MUSIC STYLE?

Screen('FillRect', w, backgroundColor) ; % draw full-screen solid rectangle in bkgdColor
getMusic = GetEchoString(w,'What is your favorite style of music?', xquart, ymid,mainTextColor,backgroundColor);

while strlength(getMusic) < 3
    Screen('FillRect', w, backgroundColor);   % clears the screen
    DrawFormattedText(w,'INVALID INPUT', 'center', 'center', warningTextColor);
    Screen('Flip', w);  % puts text on screen
    WaitSecs(1);    % waits 1 second
    Screen('FillRect', w, backgroundColor) ; % draw full-screen solid rectangle in bkgdColor
    getMusic = GetEchoString(w,'What is your favorite style of music?', xquart, ymid,mainTextColor,backgroundColor);
end

% SURVEY COMPLETE
Screen('FillRect', w, backgroundColor) ; % draw full-screen solid rectangle in bkgdColor
DrawFormattedText(w, 'The survey is complete.\nThank you!', 'centerblock', 'center', mainTextColor);
Screen('Flip', w);  % puts text on the screen

%% SAVE & EXIT

KbWait(-1, 1); % waits for all keys to be up
keyCode = zeros(1,256);

keyDResp = min(KbName('d'));            % key-number for d key
keyOResp = min(KbName('o'));            % key-number for o key

while ~keyCode(keyDResp) && ~keyCode(keyOResp)
    [~,keyCode] = KbWait(-1); %get key code for pressed key(s)
end

save('psych20bhw2data', 'getMusic', 'age', 'voterStatus', 'speakerStatus');

ListenChar(1) % restore keyboard output to Matlab window
sca;    % close open Psychtoolbox windows & restore mouse cursor
