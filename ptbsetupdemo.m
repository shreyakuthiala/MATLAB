% Author: Shreya Kuthiala (2023)
clear all % clears previously defined variables and settings
clc % clears command window
sca % close any open Psychtoolbox windows
rng shuffle % shuffle random number generator

Screen('Preference', 'VisualDebugLevel', 1); % suppress Psychtoolbox welcome screen
Screen('Preference', 'SkipSyncTests', 1);   % skips synchronization tests that cause errors

allScreenNums = Screen('Screens');  % vector of screen numbers for available monitors
mainScreenNum = max(allScreenNums); % screen number of 'main monitor'

PsychDebugWindowConfiguration; % makes screen semi-transparent (if want to turn on, (-1))

w = PsychImaging('OpenWindow', mainScreenNum, [0 0 255]); % makes window bright blue and full screen 

ListenChar(2);  % suppress keyboard input to Matlab window
HideCursor  % hides mouse cursor

Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC)ALPHA');   % sets up a blend function (turns on anti-ailiasing)
[wWidth, wHeight] = Screen('WindowSize', w);    % width and height of window w in pixels

xmid = round(wWidth / 2);   % horizontal midpoint of window w in pixels
ymid = round(wHeight / 2);  % vertical midpoint of window w in pixels

%% DISPLAY TEXT

%Screen('Flip', w, [], 1);  % allows for precise timing to display screen; the "1" allows the print to stay on the screen buffer

Screen('TextSize', w, 40);   % sets text size to 4p pixels tall
Screen('TextFont', w, 'Arial'); % sets text font

DrawFormattedText(w, 'Here is some text!', 100, 300, [255 255 0]) % first w, add text, horizontal/vertical pixels, rgb triplet for yellow; draws text, but does not put on screen (only in memory) 
Screen('Flip', w);  % puts text on screen

WaitSecs(5);   % wait 5 seconds before screen closes




% TO RUN: edit sca
% ptbsetupdemo





%% EXIT
sca % close Psychtoolbox window
% Screen('Close', w); alternative for above line
ListenChar(1);  % restores keyboard input to Matlab window

