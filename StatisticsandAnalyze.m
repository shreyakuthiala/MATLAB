% Author: Shreya Kuthiala (Nov. 09, 2022)
% This program will compute basic statistics and make some graphs using
% data from a study.
% This program requires the use of the file "fakeMemoryData2022.csv" and
% creates the files 'psych20ahw7fig1.pdf' & 'psych20ahw7fig2.pdf.

clear;       % clear variables from workspace
close all;   % close any open figure windows

%% IMPORT & EXTRACT DATA:

dataTable = readtable('/Users/kuthiala/Downloads/fakeMemoryData2022.csv'); % imports csv file into table
scorePlaceboDigit = dataTable.DigitScore(dataTable.Condition == 0); % vector containing digit-span scores in placebo group
scorePlaceboObject = dataTable.ObjectScore(dataTable.Condition == 0); % vector containing object scores in placebo group
scoreTreatDigit = dataTable.DigitScore(dataTable.Condition == 1); % vector containing digit-span scores in treatment group 
scoreTreatObject = dataTable.ObjectScore(dataTable.Condition == 1); % vector containing object scores in treatment group

%% STATISTICS:

meanPlaceboDigit = mean(dataTable.DigitScore(dataTable.Condition == 0)) % calculates mean digit-span score in placebo group
meanPlaceboObject = mean(dataTable.ObjectScore(dataTable.Condition == 0)) % calculates mean object score in placebo group
meanTreatDigit = mean(dataTable.DigitScore(dataTable.Condition == 1)) % calculates mean digit-span score in treatment group
meanTreatObject = mean(dataTable.ObjectScore(dataTable.Condition == 1)) % calculates mean object score in treatment group

sdPlaceboDigit = std(dataTable.DigitScore(dataTable.Condition == 0)) % calculates standard deviation of digit-span score in placebo group
sdPlaceboObject = std(dataTable.ObjectScore(dataTable.Condition == 0)) % calculates standard deviation of object score in placebo group
sdTreatDigit = std(dataTable.DigitScore(dataTable.Condition == 1)) % calculates standard deviation of digit-span score in treatment group
sdTreatObject = std(dataTable.ObjectScore(dataTable.Condition == 1)) % calculates standard deviation of object score in treatment group

semPlaceboDigit = std(dataTable.DigitScore(dataTable.Condition == 0)) / sqrt(numel(dataTable.DigitScore(dataTable.Condition == 0)))
semPlaceboObject = std(dataTable.ObjectScore(dataTable.Condition == 0)) / sqrt(numel(dataTable.ObjectScore(dataTable.Condition == 0)))
semTreatDigit = std(dataTable.DigitScore(dataTable.Condition == 1)) / sqrt(numel(dataTable.DigitScore(dataTable.Condition == 1)))
semTreatObject = std(dataTable.ObjectScore(dataTable.Condition == 1)) / sqrt(numel(dataTable.ObjectScore(dataTable.Condition == 1)))


%% FIGURE 1 - GROUPED BAR GRAPH:

figure(1) % opens figure 1 window

y = [meanPlaceboDigit', meanTreatDigit' ; meanPlaceboObject', meanTreatObject']
b = bar(y)

b(1).FaceColor = [.9 .6 .1]; % sets face color of b(1)
b(2).FaceColor = [.4 .4 1]; % sets face color of b(2)

name={'Digit-Span' ; 'Object-Recognition'};
set(gca, 'xticklabel', name);

set(gca, 'Ygrid', 'on') % adds horizontal grid lines
legend([b(1), b(2)],'Placebo', 'Treatment', 'northeast') % creates legend
xlabel('Test Type') % labels x-axis
ylabel('Memory Score') % labels y-axis
title('Mean Memory Scores') % title

% hold on
% 
% errorbar(b(1), b(2))
% 
% hold off

%% FIGURE 2 - SCATTER PLOT:

figure(2) % opens figure 2 window

subplot(1, 2, 2)
scatter(scorePlaceboDigit, scorePlaceboObject, 'black', 'markerfacecolor', 'blue')
hold on
scatter(scoreTreatDigit, scoreTreatObject, 'd', 'black', 'markerfacecolor', '#FF8800')
hold off

sgtitle('Object-Recognition vs. Digit-Span') % title
xlabel('Digit-Span Score') % labels x-axis
ylabel('Object-Recognition Score') % labels y-axis
legend('Placebo', 'Treatment') % creates legend
axis square % forces graph to be square
grid on % shows horizontal & vertical gridlines
box on % completes box outline

%% SAVE FIGURES

saveas(figure(1), 'psych20ahwfig1.pdf')
saveas(figure(2), 'psych20ahwfig2.pdf')