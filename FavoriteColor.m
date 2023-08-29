%% Author: Shreya Kuthiala, March 2023
% This proram will conduct a short survey where the subject will choose the
% color they like best.

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

backgroundColor = [0 0 0];                      % background color is black
w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor);       %open a full-screen window
Screen('BlendFunction',w,'GL_SRC_ALPHA','GL_ONE_MINUS_SRC_ALPHA');  %Make drawing smoother (anti-aliasing)

[wWidth, wHeight] = Screen('WindowSize', w) ;   % width and height of screen in pixels
xmid       = round(wWidth  / 2);                % horizontal midpoint of screen in pixels
ymid       = round(wHeight / 2);                % vertical   midpoint of screen in pixels

%Text setup
Screen('TextFont',w,'Arial');                       % Set text font
smallText = round(wHeight/30);                      % smaller text size for prompts
Screen('TextSize',w,smallText);                     % set text size to 1/30 screen height
textColor = [0 255 255];                            % cyan as  text color

% Keyboard Setup
KbName('UnifyKeyNames')                             % use OSX key-name system
Screen('TextBounds',w,' ');                         % This should get rid of issues w/ aliasing in GetEchoString

keyNumG = min(KbName('g'));
keyNumJ = min(KbName('j'));

ListenChar(2) ; % suppress keyboard output to Matlab window

% PRIME PSYCHTOOLBOX FUNCTIONS
WaitSecs(0);
DrawFormattedText(w, '');
GetMouse;
SetMouse(0, 0);
HideCursor
ShowCursor;
IsInRect(0, 0, [0 0 0 0]);
Screen('FillOval', w);
Screen('FrameOval', w);
Screen('FillRect', w, backgroundColor);
Screen('Flip', w);
[anyKeyDown, keySecs, keyCode] = KbCheck(-1) ; % check key statuses

%% COLOR SELECTION

while ~KbCheck(-1) % wait for any key to be down
    DrawFormattedText(w, 'Press any key to begin color selection', 'center', 'center', textColor)  % draw text
    Screen('Flip', w);  % put text on screen
end

% create rects for circles using linspace
rectWidth = linspace(0, wWidth, 33); % divides screen width into 33 equal parts
circle1 = [0 ymid-(wWidth/16) rectWidth(5) ymid+(wWidth/16)]; %defines rect for circle 1
circle2 = [rectWidth(8) ymid-(wWidth/16) rectWidth(12) ymid+(wWidth/16)];%defines rect for circle 2
circle3 = [rectWidth(15) ymid-(wWidth/16) rectWidth(19) ymid+(wWidth/16)]; %defines rect for circle 3
circle4 = [rectWidth(22) ymid-(wWidth/16) rectWidth(26) ymid+(wWidth/16)]; %defines rect for circle 4
circle5 = [rectWidth(29) ymid-(wWidth/16) wWidth ymid+(wWidth/16)]; %defines rect for circle 5
circleRects = [circle1 ; circle2 ; circle3 ; circle4 ; circle5]; % matrix of circle rects
xCenter = [rectWidth(2) rectWidth(9) rectWidth(16) rectWidth(23) rectWidth(30)]; % creates matrix of center of circles

mouseButtons = [0 0 0]; % initialize mouse buttons to 0
while sum(mouseButtons) == 0 % while nothing has been clicked
    [mouseX, mouseY, mouseButtons] = GetMouse(w); % gets mouse positon
    Screen('FillOval', w, [255 87 51], circle1); % circle 1
    Screen('FillOval', w, [98 52 18], circle2); % circle 2
    Screen('FillOval', w, [174 183 651], circle3); % circle 3
    Screen('FillOval', w, [227 28 121], circle4); % circle 4
    Screen('FillOval', w, [128 0 128], circle5); % circle 5
    Screen('Flip',w, [], 1); % flips circles on to screen

    for iCircle = 1:5
        if radius >= sqrt ((mouseX - xCenter(iCircle))^2 + (mouseY-ymid)^2) %if mouse is inside the circle
            Screen ('FrameOval', w, textColor, circleRects(iCircle, :), 5); % creates white outline
            if any (mouseButtons) % if mouse pressed
                faveColor = iCircle; % assigns condition to faveColor
            end
        end
    end

    DrawFormattedText(w, 'Click on the color you like best.', 'center', ymid/2, textColor); %creates prompt
    Screen('Flip',w,[], 1); % flips prompt on to screen
end

Screen('FillRect', w, backgroundColor) ; % clear screen
WaitSecs(0.10)  % wait 100 ms
DrawFormattedText(w, 'Color selection is complete.\nThank you!', 'center', 'center', textColor);
Screen('Flip, w');  % flips text

%% SAVE & EXIT
save('psych20bhw10data', faveColor, 'wWidth', 'wHeight'); % save all objects in workspace to file

RestrictKeysForKbCheck([]); % stop ignoring keys
keyCode = zeros(1, 256)   ; % initialize vector of key-statuses
topLeftRect = [0 xmid 0 ymid];

while ~(( keyCode([keyNumG keyNumJ]) ) && IsInRect(mouseX, mouseY, topLeftRect))
    [~, keyCode] = KbWait(-1) ; % get vector of current key-statuses
    [mouseX, mouseY, mouseButtons] = GetMouse(w);   % get mouse position
end

sca             % close Psychtoolbox window, restore mouse-cursor
ListenChar(1) ; % restore keyboard output to Matlab window
