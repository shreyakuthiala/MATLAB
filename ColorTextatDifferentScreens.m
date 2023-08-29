 % PSYCH 20B Homework 1
 % Display text of various colors at various screen-positions.
 % Author: Shreya Kuthiala (2023)

 %% SETUP
 clear all % clear previously-defined variables from workspace, reset misc settings
 close all % close any open figure windows
 sca % close any open Psychtoolbox windows

 rng shuffle % seed the random number generator based on the current time

 Screen('Preference', 'VisualDebugLevel', 1) ; % suppress Psychtoolbox welcome screen
 Screen('Preference', 'SkipSyncTests', 1) ; % skip sync testing that causes errors
 allScreenNums = Screen('Screens') ; % vector of screen numbers of available monitors
 mainScreenNum = max( Screen('Screens') ) ; % screen number of main monitor

 backgroundColor = [100 149 237];   % creates RGB triplet for background
 w = PsychImaging('OpenWindow', mainScreenNum, backgroundColor) ;
 PsychDefaultSetup(1) % use the 0-to-255 scale for RGB color values

 
 ListenChar(2) % suppress keyboard output to Matlab window
 HideCursor % hide the mouse cursor
 [wWidth, wHeight] = Screen('WindowSize', w) ; % width and height of window 'w' in pixels
 xmid = round(wWidth / 2) ; % horizontal midpoint of window 'w' in pixels
 ymid = round(wHeight / 2) ; % vertical midpoint of window 'w' in pixels
 
 quadRectTopLeft = rect[0 0 xmid ymid]; % rect defining top-left quadrant of screen
 quadRectTopRight = rect[xmid 0 wWidth ymid]; % rect defining top-right quadrant of screen
 quadRectBottomLeft = rect[0 ymid xmid wHeight];  % rect defining bottom-left quadrant of screen
 quadRectBottomRight = rect[xmid ymid wWidth wHeight]; % rect defining bottom-right quadrant of screen

 %% DISPLAY QUADRANT LABELS

Screen('TextSize', w, round(1/20 * wHeight)) ; % set text size to 1/20 of height
Screen('TextFont', w, 'Arial') ; % set font to Arial
Screen('TextStyle', w, 1);  % makes text bold

DrawFormattedText(w, 'TOP LEFT\nQUADRANT', 'left', 'center', [255 0 0], [], [], ...
    [], [], [], quadRectTopLeft);   % draws red text in top-left quadrant of screen
Screen('Flip', w, [], 1) ;  % flips the text onto the screen

WaitSecs(2) % waits 2 seconds

DrawFormattedText(w, 'TOP RIGHT\nQUADRANT', 'right', 'center', [255 255 0], [], [], ...
    [], [], [], quadRectTopRight);   % draws yellow text in top-right quadrant of screen
Screen('Flip', w, [], 1) ;  % flips the text onto the screen

WaitSecs(2) % waits 2 seconds

DrawFormattedText(w, 'BOTTOM LEFT\nQUADRANT', 'left', 'bottom', [0 255 0], [], [], ...
    [], [], [], quadRectBottomLeft);   % draws green text in bottom-left quadrant of screen
Screen('Flip', w, [], 1) ;  % flips the text onto the screen

WaitSecs(2) % waits 2 seconds

DrawFormattedText(w, 'BOTTOM RIGHT\nQUADRANT', 'right', 'bottom', [48 25 52], [], [], ...
    [], [], [], quadRectBottomRight);   % draws purple text in bottom-right quadrant of screen
Screen('Flip', w, [], 1) ;  % flips the text onto the screen

WaitSecs(2) % waits 2 seconds

%% DISPLAY TEXT AT RANDOM POSITIONS
Screen('TextSize', w, round(1/40 * wHeight)) ; % set text size to 1/40 of height
Screen('TextStyle', w, 0);  % makes text regular again

textDimRect = Screen('TextBounds', w, 'left');  % creates textbounds to the left
cutoff = textDimRect(3);

for i = 1:250   % for each of the "left" words
    PsychDefaultSetup(2);   % 0-1 RGB scale
    gray = grayIndex(w, rand);  % creates gray index
    DrawFormattedText(w, 'left', round(randi(wWidth/2)) - cutoff, randi(wHeight), gray);
end

Screen('Flip', w);
WaitSecs(8);    % waits 8 seconds

%% EXIT
 sca;
 ShowCursor % show the mouse cursor
 ListenChar(1) % restore keyboard output to Matlab window