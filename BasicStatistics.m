%% Author: Shreya Kuthiala, Feb 2023
% This program will import data from a csv file (fakeMemoryData2022), 
% compute basic statistics, and then output a table of the results. The
% name of the csv file created from this program will be 'psych20bhw7'. The
% coding scheme for conditions is as follows: 1 = treatment group, 0 =
% placebo group.

clear;       % clear variables from workspace
close all;   % close any open figure windows

%% IMPORT & EXTRACT DATA:

dataTable = readtable('/Users/kuthiala/Downloads/fakeMemoryData2022.csv'); % imports csv file into table
scoreTreatDigit = dataTable.DigitScore(dataTable.Condition == 1); % vector containing digit-span scores in treatment group 
scoreTreatObject = dataTable.ObjectScore(dataTable.Condition == 1); % vector containing object scores in treatment group
scorePlaceboDigit = dataTable.DigitScore(dataTable.Condition == 0); % vector containing digit-span scores in placebo group
scorePlaceboObject = dataTable.ObjectScore(dataTable.Condition == 0); % vector containing object scores in placebo group

%% DESCRIPTIVE STATISTICS

meanTreatDigit = mean(dataTable.DigitScore(dataTable.Condition == 1)); % calculates mean digit-span score in treatment group
meanTreatObject = mean(dataTable.ObjectScore(dataTable.Condition == 1)); % calculates mean object score in treatment group
meanPlaceboDigit = mean(dataTable.DigitScore(dataTable.Condition == 0)); % calculates mean digit-span score in placebo group
meanPlaceboObject = mean(dataTable.ObjectScore(dataTable.Condition == 0)); % calculates mean object score in placebo group

sdPlaceboDigit = std(dataTable.DigitScore(dataTable.Condition == 0)); % calculates standard deviation of digit-span score in placebo group
sdPlaceboObject = std(dataTable.ObjectScore(dataTable.Condition == 0)); % calculates standard deviation of object score in placebo group
sdTreatDigit = std(dataTable.DigitScore(dataTable.Condition == 1)); % calculates standard deviation of digit-span score in treatment group
sdTreatObject = std(dataTable.ObjectScore(dataTable.Condition == 1)); % calculates standard deviation of object score in treatment group

semPlaceboDigit = std(dataTable.DigitScore(dataTable.Condition == 0)) / sqrt(numel(dataTable.DigitScore(dataTable.Condition == 0)));
semPlaceboObject = std(dataTable.ObjectScore(dataTable.Condition == 0)) / sqrt(numel(dataTable.ObjectScore(dataTable.Condition == 0)));
semTreatDigit = std(dataTable.DigitScore(dataTable.Condition == 1)) / sqrt(numel(dataTable.DigitScore(dataTable.Condition == 1)));
semTreatObject = std(dataTable.ObjectScore(dataTable.Condition == 1)) / sqrt(numel(dataTable.ObjectScore(dataTable.Condition == 1)));


%% MEAN COMPARISONS


% digit-span t-test comparing treatment group to placebo group
[~, ptscoreTreatDigitvsscorePlaceboDigit, citscoreTreatDigitvsscorePlaceboDigit, statstscoreTreatDigitvsscorePlaceboDigit] = ttest2(scoreTreatDigit, scorePlaceboDigit, 'vartype', 'unequal') ;

% object-recognition t-test comparing treatment group to placebo group
[~, ptscoreTreatObjectvsscorePlaceboObject, citscoreTreatObjectvsscorePlaceboObject, statstscoreTreatObjectvsscorePlaceboObject] = ttest2(scoreTreatObject, scorePlaceboObject, 'vartype', 'unequal') ;

%% RESULTS TABLE
% 2 rows (Digit, Object), 8 columns (TreatmentMean, TreatmentSD, PlaceboMean, PlaceboSD, MeanDifference, p, CILower, CIUpper)

resultsTable = ([meanTreatDigit, sdTreatDigit, meanPlaceboDigit, sdPlaceboDigit, meanTreatDigit-meanPlaceboDigit, p, CIlower, CIupper'; ...
                meanTreatObject, sdTreatObject, meanPlaceboObject, sdPlaceboObject, meanTreatObject - meanPlaceboObject, p, CIlower, CIupper]');

resultsTable = array2table(resultsTable, "RowNames", {'Digit', 'Object'}, 'VariableNames',{'Treatment Mean', 'Treatment SD', 'Placebo Mean', 'Placebo SD', 'Mean Difference', 'p', 'CI Lower', 'CI Upper'});

disp(resultsTable) % displays result table
writetable(resultsTable, 'psych20bhw7results.csv', 'WriteRowNames', true);  % saves table to file
