% Author: Shreya Kuthiala (March, 2023)
% This program will compute basic statistics and make some graphs using
% data from a study.
% This program requires the use of the file "fakeScores.csv" and
% creates the files 'psych20bhw9table.csv' & 'psych20bhw9fig.pdf'

clear;       % clear variables from workspace
close all;   % close any open figure windows

%% IMPORT DATA
dataTable = readtable('/Users/kuthiala/Downloads/fakeScores.csv'); % imports csv file into table
verbalScore = dataTable.VerbalScore; % vector containing verbal scores
mathScore = dataTable.MathScore; % vector containing math scores
memoryScore = dataTable.MemoryScore; % vector containing memory scores

%% DESCRIPTIVE STATISTICS

meanVerbalScore = mean(dataTable.VerbalScore)
meanMathScore = mean(dataTable.MathScore)
meanMemoryScore = mean(dataTable.MemoryScore)

sdVerbalScore = std(dataTable.VerbalScore)
sdMathScore = std(dataTable.MathScore)
sdMemoryScore = std(dataTable.MemoryScore)

semVerbalScore = std(dataTable.VerbalScore) / sqrt(numel(dataTable.VerbalScore))
semMathScore = std(dataTable.MathScore) / sqrt(numel(dataTable.MathScore))
semMemoryScore = std(dataTable.MemoryScore) / sqrt(numel(dataTable.MemoryScore))


%% CORRELATIONS

[corMat, corP, corCILower, corCIUpper] = corrcoef([verbalScore mathScore memoryScore]) ;

dataTable = array2table(corMat, 'RowNames'     , {'VerbalScore' 'MathScore' 'MemoryScore'}, ...
                               'VariableNames', {'VerbalScore' 'MathScore' 'MemoryScore'}) ;

disp(dataTable)  % displays corTable
writetable(dataTable, 'psych20bhw9table.csv') % saves table to csv file

%% SCATTER PLOTS

figure(1)   % open figure 1 window
subplot(2,2,1)  
scatter(mathScore, verbalScore, 10, 'oblack', 'white')
title('Verbal Score vs Math Score') % title
xlabel('Math Score') % x-axis label
ylabel('Verbal Score') % y-axis label
xlim([40 100])       % x-axis limits
ylim([40 100])       % y-axis limits
axis square % force graph to be square
grid on % show horizontal and vertical gridlines
grid minor % adds "minor" grid lines 
box on % complete the box outlining the graph

regLine = lsline ; % show least-squares regression line 
regLine.Color = [0 0 1]; % set color of least-squares regression line


subplot(2,2,2)  
scatter(memoryScore, verbalScore, 10, 'oblack', 'white')
title('Verbal Score vs Memory Score') % title
xlabel('Memory Score') % x-axis label
ylabel('Verbal Score') % y-axis label
xlim([40 100])       % x-axis limits
ylim([40 100])       % y-axis limits
axis square % force graph to be square
grid on % show horizontal and vertical gridlines
grid minor % adds "minor" grid lines 
box on % complete the box outlining the graph

regLine = lsline ; % show least-squares regression line 
regLine.Color = [0 0 1]; % set color of least-squares regression line


subplot(2,2,3)  
scatter(memoryScore, mathScore, 10, 'oblack', 'white')
title('Math Score vs Memory Score') % title
xlabel('Memory Score') % x-axis label
ylabel('Math Score') % y-axis label
xlim([40 100])       % x-axis limits
ylim([40 100])       % y-axis limits
axis square % force graph to be square
grid on % show horizontal and vertical gridlines
grid minor % adds "minor" grid lines 
box on % complete the box outlining the graph

regLine = lsline ; % show least-squares regression line 
regLine.Color = [0 0 1]; % set color of least-squares regression line




