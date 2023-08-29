% Author: Shreya Kuthiala (Oct. 26, 2022)
% This program will run a free-association exercise where a series of words
% will be presented, and after each presented word the user will response
% as quickly as possible by typing the first word that comes to mind. This
% program requires the use of the file "free association word list.csv" and
% creates the file 'psych20ahw5data.mat'.

%% SETUP

clear;
clc;
rng shuffle % shuffles the random number generator

%% PREPARE WORD-PROMPTS

wordTable = readtable('/Users/kuthiala/Downloads/free association word list.csv'); % imports csv file into table
numPrompts = 10; % represents the number of word-prompts used in the exercise
 
 nonAdj = wordTable.Word(wordTable.IsAdjective ==0);
 adj = wordTable.Word(wordTable.IsAdjective == 1);

 reorderAdjective = randperm(numel(adj),numPrompts/2);
 reorderNonAdjective = randperm(numel(nonAdj),numPrompts/2);

 prompts = [nonAdj(reorderNonAdjective), adj(reorderAdjective)]';
 
%% FREE-ASSOCIATION EXERCISE

responses = []; % holds the user's responses


responseSecs = NaN; % holds the user's response times

fprintf('*** FREE-ASSOCIATION EXERCISE ***')
fprintf(['\n\nAfter each presented word, type the first word that comes to ' ...
    'mind in response.'])
fprintf(['\nType your answer as quickly as possible without thinking about it,' ...
    'and then press Return.\n\n'])
fprintf('Press any key to begin.')

pause; % waits for the user to press a key before continuing

x = 1;
y = 1;
z = 1;

for iResponse = 1:numel(prompts)
    clc;
    if mod(iResponse, 2) ~= 0
        wordPrompt = prompts{1,x};
        tic; % starts timer for user input
        answer = input([wordPrompt '\n'], 's');
        while isempty(answer)
            answer = input([wordPrompt '\n'], 's');
        end
        if strcmpi(answer, 'Abort exercise') == 1
            fprintf("Exercise aborted.")
            return
        end
        responseSecs(z) = toc; % records user output
        responses{z} = answer;
        x = x + 1;
        z = z + 1;
    else
        wordPrompt = prompts{2,y};
        tic;
    end
end

%% REPORT

% do we have to create new table with columns? how do we do this
Prompt = num2cell(prompts, [1 2]); % creates cell array (prompts) where cell contains entire prompts array
Response = num2cell(responses, [1 2]); % creates cell array (responses) where cell contains entire responses array
ResponseSeconds = num2cell(responseSecs, [1 2]); % creates cell array (responseSecs) where cell contains entire responseSecs array

resultsMatrix = [Prompt Response ResponseSeconds]; % creates a matrix with values we want in table

resultsTable = array2table(resultsMatrix, 'VariableNames', ["Prompt" "Response" "Response Seconds"]); % displays cell arrays & time spent per response
% not sure how to display the actual words, but tried to display cell array

clc;
disp(resultsTable)
fprintf('\nExercise complete!\n')

%% SAVE

save('psych20ahw5data', 'prompts', 'responses', 'responseSecs')
writetable(resultsTable, 'psych20ahw5results.csv')
