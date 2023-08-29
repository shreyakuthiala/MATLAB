% Author: Shreya Kuthiala (Oct. 14, 2022)
% This program collect 4 survey responses via the keyboard, then analyze
% the responses and save the data.

clear;
clc;

%% GET SURVEY RESPONSES
responseCell = cell(4,1); % creates the responseCell

responseCell{1} = input('What is your favorite color? : \n', 's'); % asks for the user's favorite color & uses as input
responseCell{2} = input('\nWhat is your favorite style of music? : \n', 's'); %asks for the user's favorite style of music & uses as input
responseCell{3} = input('\nWhat is your favorite movie? : \n', 's'); % asks for the user's favorite movie & uses as input
responseCell{4} = input('\nDescribe your current mood in words : \n', 's'); % asks for the user's current mood & uses as input

fprintf("\nThe survey is complete.\n \nThank you for participating!\n"); % prints "The survey is complete. Thank you for participating!"

responseStruct = cell2struct(responseCell, {'faveColor', 'faveMusic', 'faveMovie', 'mood'}); % converts the vector "responseCell" into a new struct "responseStruct"

%% ANALYZE RESPONSES

responseStruct.responseNumChar = [numel(responseStruct.faveColor), numel(responseStruct.faveMusic), numel(responseStruct.faveMovie), numel(responseStruct.mood)]; %counts the number of characters in the responses
responseStruct.moodCharNoSpace = [numel(strrep(responseStruct.mood, ' ', ''))]; % counts the number of characters without a space in the response for mood
responseStruct.moodNumE = numel(strfind(responseStruct.mood, 'e')); % counts the number of "e"s in the response
responseStruct.moodNumWords = numel(strsplit(responseStruct.mood)); % counts the number of words in the response

%% SAVE DATA

save('psych20ahw3data.mat', 'responseStruct');
fileID = fopen('psych20ahw3mood.txt', 'w');
fprintf(fileID, 'Mood response:\n%s', responseStruct.mood);
fclose(fileID);
type 'psych20ahw3moodtxt'




