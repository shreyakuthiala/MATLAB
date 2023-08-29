% Author: Shreya Kuthiala (Oct. 22, 2022)
% This program gives the user a quiz on state capitals (in alphabetical
% order by state) and then reports their score. This progarm requires the
% file "usStates.csv


%% SETUP
clear; 
clc;

stateCapitalTable = readtable('/Users/kuthiala/Downloads/usStates.csv');
%% INPUT NUMBER OF STATES

numStates = input(['Enter the number of states to include on the ' ...
        'quiz: \n']) %% asks the user for the # of states to include on the quiz
while ((numStates >= 1) && (numStates <= 50)) == 0
    numStates = input(['Enter the number of states to include on the ' ...
            'quiz: \n'])  %% asks the user for the # of states to include on the quiz IF user does not input correct info
end

%% DEFINE QUIZ ITEMS
state = stateCapitalTable{x:y, 1}; % creates cell array for the state names
capital = stateCapitalTable{x:y, 3}; % creates cell array for the capital names of the states

%% GIVE QUIZ

response = {}; % creates cell array for responses
scoreCard = false(y,1); % initializes scoreCard array 

for i = 1:y
    capitalResponse = input(['What is the capital of ' state{x} '? '], 's'); % asks user what the capital is of state{x}
if strcmpi(capitalResponse, 'stop') == 1 % if the user inputs "stop" then 
    % breaks out of loop
    fprintf('Quiz aborted') % outputs "quiz aborted" if user inputs "stop"
    return
end
if strcmpi(capitalResponse, capital{x}) == 1 % if the user's input is the
    % same as that listed in the table, "correct" will be printed and scoreboard +1
    fprintf('\nCorrect!\n\n')
    scoreCard(x) = 1;
else
    fprintf('\nIncorrect!\n\n') % if user input is incorrect, output "incorrect" and scorecard = 0
    scoreCard(x) = 0;
end
x = x + 1;
end

%% SAVE DATA

save('psych20ahw4data.mat', "state", "capital", "response", "scoreCard");

%% REPORT SCORE

if ~strcmpi(capitalResponse, 'stop')
    fprintf('You got ', scoreCard(x), 'out of ', numStates, 'answers correct ', (scoreCard/numStates), '%%')
end


