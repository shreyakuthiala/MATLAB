%% Author: Shreya Kuthiala, February 2023
% This program will collect a mood rating via mouse-click. Will import the
% sam.bmp file to represent the  moods. Program creates a data file called
% "psych20bhw4data_subj.mat". 
%% GENERAL SETUP
clear all;                      %clear variables in other settings
clc;                            %clear command window
rng shuffle                     %seed rng using current time
close all;                      %close figure windows
sca;                            %close PsychToolbox windowsSkip intro/debug and start screen setup
Screen('Preference', 'ConserveVRAM', 8192) ;
PsychDebugWindowConfiguration
Screen('Preference','VisualDebugLevel',1);      %suppress PsychToolbox Welcome screen
Screen('Preference','SkipSyncTests',1);         %Skip sync testing that causes error
PsychDefaultSetup(1);                           %Use 0-to-255 coding for colors (OK if you use 0-to-1)
allScreenNums = Screen('Screens');              %Vector of screen numbers for available monitors
mainScreenNum = max(allScreenNums);             %Screen number of the "main" monitor
backgroundColor = [0 0 0];
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
%GetEchoString setup
Screen('TextBounds',w,' ');                         % This should get rid of issues w/ aliasing in GetEchoString

% define subject-number prompt text, and get coordinates to center it
subjIDPromptText    = 'Enter subject number:'                   ; % subject-number prompt text
subjIDPromptDimRect = Screen('TextBounds', w, subjIDPromptText) ; % rect giving dimensions of text box
subjIDPromptWidth   = subjIDPromptDimRect(3)                    ; % width  of text box
subjIDPromptHeight  = subjIDPromptDimRect(4)                    ; % height of text box
subjIDPromptX       = xmid - subjIDPromptWidth  / 2             ; % x-coordinate for left edge prompt text
subjIDPromptY       = ymid - subjIDPromptHeight / 2             ; % y-coordinate for top  edge of prompt text box
%% PREPARE SAM ICONS
%read in image
samImage = imread('sam.bmp');
[height, width, dim] = size(samImage);   % find size of image
samImagePad = padarray(samImage, (round(1/26 * (samImage(2)))), 255, 'pre');   % pads image on top
samImagePad = padarray(samImagePad, round(1/26 * (samImage(2))), 255, 'post');   % pads image on bottom

% crop icons
samIcon1 = imcrop(samImagePad, [0, 0, round(wWidth/5), wHeight]);
samIcon2 = imcrop(samImagePad, [0, 0, round(wWidth/5) * 2, wHeight]);
samIcon3 = imcrop(samImagePad, [0, 0, round(wWidth/5) * 3, wHeight]);
samIcon4 = imcrop(samImagePad, [0, 0, round(wWidth/5) * 4, wHeight]);
samIcon5 = imcrop(samImagePad, [0, 0, wWidth, wHeight]);    % crops image

samIconYellow1 = samIcon1 * [255 255 0];    % yellow tinted version of icon
samIconYellow2 = samIcon2 * [255 255 0];    % yellow tinted version of icon
samIconYellow3 = samIcon3 * [255 255 0];    % yellow tinted version of icon
samIconYellow4 = samIcon4 * [255 255 0];    % yellow tinted version of icon
samIconYellow5 = samIcon5 * [255 255 0];    % yellow tinted version of icon

samIconRect1 = [0, 0, round(wWidth/5) + 4, wHeight];
samIconRect2 = [0, 0, round(wWidth/5)*2 + 4, wHeight];
samIconRect3 = [0, 0, round(wWidth/5)*3 + 4, wHeight];
samIconRect4 = [0, 0, round(wWidth/5)*4 + 4, wHeight];
samIconRect5 = [0, 0, wWidth + 4, wHeight];

% convert all icons to textures
samIconTexture1 = Screen('MakeTexture', w, samIcon1);
samIconTexture2 = Screen('MakeTexture', w, samIcon2);
samIconTexture3 = Screen('MakeTexture', w, samIcon3);
samIconTexture4 = Screen('MakeTexture', w, samIcon4);
samIconTexture5 = Screen('MakeTexture', w, samIcon5);

samIconYellowTexture1 = Screen('MakeTexture', w, samIconYellow1);
samIconYellowTexture2 = Screen('MakeTexture', w, samIconYellow2);
samIconYellowTexture3 = Screen('MakeTexture', w, samIconYellow3);
samIconYellowTexture4 = Screen('MakeTexture', w, samIconYellow4);
samIconYellowTexture5 = Screen('MakeTexture', w, samIconYellow5);

%% PRIME PSYCHTOOLBOX FUNCTIONS

WaitSecs(0);
KbWait([], 1) ; % this also primes KbCheck, since KbWait uses KbCheck
RestrictKeysForKbCheck([]);
DrawFormattedText(w, '');
Screen('Flip', w);
Screen('MakeTexture', w);
Screen('FillRect', w);
GetMouse;
%% ENTER SUBJECT NUMBER

subNumValid = 0 ;  % initialize boolean indicating whether subject ID number is valid
while ~subNumValid % stay in while-loop until valid subject ID number is entered
    subjIDChar = GetEchoString(w, subjIDPromptText, subjIDPromptX, subjIDPromptY, mainTextColor, backgroundCOlor) ; % subject ID as character array
    Screen('FillRect', w, backgroundColor) ; % draw full-screen filled rectangle so GetEchoString text will be erased on next 'Flip'

    subjID = str2double(subjIDChar) ;  % convert subject ID from character array to numeric value

    if ismember(subjID, 1:1000) % if entered subject ID is between 1 and 1000 inclusive
        isSubjIDValid = 1  ;    % breaks loop
    else                        % otherwise, error message
        DrawFormattedText(w, 'INVALID SUBJECT NUMBER', 'center', 'center', warningTextColor) ; % error message
        Screen('Flip', w') ; % error message
        WaitSecs(1)        ; % wait 1 second
    end
end
%% GET MOOD RATING
% instructions
Screen('FillRect', w, backgroundColor) ; % clears screen
DrawFormattedText(w, ['Click on the image that best represents your current ' ...
    'mood.\n'], xmid, round(wHeight*0.20), mainTextColor);

% icons appear
Screen('DrawTextures', w, [samIcon1, samIcon2, samIcon3, samIcon4, samIcon5]);  % draws textures
Screen('Flip', w);  % flips textures onto screen

SetMouse(xmid, round(wHeight*0.80));    % sets mouse cursor position
mouseButtons = [0 0 0]; % initializes vector of mouse-button statuses

% IF any mouse bottom pressed WHILE mouse cursor on icon, record subject
getMoodRating = nan(1, 5);

% monitor mouse activity continually
while sum(mouseButtons) == 0
    [~, ~, mouseButtons] = GetMouse;    % get current mouse-button statuses

    if (sum(mouseButtons) ~= 0) && (IsInRect(samIconRect1) || IsInRect(samIconRect2) || IsInRect(samIconRect3) || IsInRect(samIconRect4) || IsInRect(samIconRect5))
        mouseButtons = 1;
        % when mouse cursor on icon, icon = yellow-tinted, other icons untinted
        if ~IsInRect(mouseX, mouseY, samIconRect1)   % icon 1
            Screen('FillRect', w, [255 255 255], samIconRect1)
            Screen('Flip', w);  % puts square on screen
        else
            Screen('FillRect', w, [255 255 0], samIconRect1)
            Screen('Flip', w);  % puts square on screen
        end

        if ~IsInRect(mouseX, mouseY, samIconRect2)   % icon 2
            Screen('FillRect', w, [255 255 255], samIconRect2)
            Screen('Flip', w);  % puts square on screen
        else
            Screen('FillRect', w, [255 255 0], samIconRect2)
            Screen('Flip', w);  % puts square on screen
        end

        if ~IsInRect(mouseX, mouseY, samIconRect3)   % icon 3
            Screen('FillRect', w, [255 255 255], samIconRect3)
            Screen('Flip', w);  % puts square on screen
        else
            Screen('FillRect', w, [255 255 0], samIconRect3)
            Screen('Flip', w);  % puts square on screen
        end

        if ~IsInRect(mouseX, mouseY, samIconRect4)   % icon 4
            Screen('FillRect', w, [255 255 255], samIconRect4)
            Screen('Flip', w);  % puts square on screen
        else
            Screen('FillRect', w, [255 255 0], samIconRect4)
            Screen('Flip', w);  % puts square on screen
        end

        if ~IsInRect(mouseX, mouseY, samIconRect5)   % icon 5
            Screen('FillRect', w, [255 255 255], samIconRect5)
            Screen('Flip', w);  % puts square on screen
        else
            Screen('FillRect', w, [255 255 0], samIconRect5)
            Screen('Flip', w);  % puts square on screen
        end

    end

    % selection as numeric value (samicon3 = 3)
    getMoodRatingChar = [mouseX, mouseY, mouseButtons]; % stores output
    getMoodRating = str2double(getMoodRatingChar);
end

% after icon clicked, hide mouse cursor, WAIT 200 ms, "thank you" message
HideCursor  % hide regular mouse cursor
WaitSecs(0.20); % waits 200 miliseconds
DrawFormattedText(w, 'Thank you!'); % writes thank you message
Screen('Flip', w);  % flips onto screen


%% SAVE & EXIT
save(['psych20bhw4_subj' subjIDChar], getMoodRating, "wWidth", "wHeight"); % save all objects in workspace to file, 

RestrictKeysForKbCheck([]) ; % stop ignoring keys
keyCode = zeros(1, 256)    ; % initialize vector of key-statuses
sca             % close Psychtoolbox window, restore mouse-cursor
ListenChar(1) ; % restore keyboard output to Matlab window
Priority(0)   ; % reset Psychtoolbox display priority to normal 