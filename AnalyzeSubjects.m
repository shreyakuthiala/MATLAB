%% Author: Shreya Kuthiala, March 2023
% This program will analyze and visualize (graph) the data of 24 fake
% subjects in the Homework 3 experiment. The coding scheme for the project
% is where 1 = clicked correctly and 0 = clicked incorrectly. trialType
% different numbers: 1 = TL, 2 = TR, 3 = BL, 4 = BR. 



%% IMPORT DATA

clear;      % clear variables from workspace
close all;  % close any open figure windows

dataFiles = dir('psych20bhw3_subj*.mat');   % structure listing the .mat files in current directory that start with psych20hw3subj'
n = numel(dataFiles);                       % total number of subjects (# of files listed in above structure)
numTrials = 20;                             % number of trials per subject

wWidthAll = NaN(n, 1);                         % screen width
wHeightAll = NaN(n, 1);                        % screen height
flipIntervalAll = NaN(n, 1);                   % flip-interval of monitor
subjIDAll = NaN(n, 1);                         % subject ID number

rtAll = NaN(n, numTrials) ;                     % response time in seconds
trialTypeAll = NaN(n, numTrials);               % trial types 
delayActualAll = NaN(n, numTrials);             % vector of actual delay times

for iSubj = 1:n
    fileName = dataFiles(iSubj).name ; % name of data file for current subject
    load(fileName)                   ; % load that data file (if file isn't in the current folder, you may need to concatenate the path onto the filename here)

    % insert current subject's single-value variables into all-subjects data vectors
    wWidthAll(      iSubj) = wWidth       ;
    wHeightAll(     iSubj) = wHeight      ;
   
    subjIDAll(      iSubj) = subjID       ;

    % insert current subject's multiple-value variables into all-subjects data matrices
    trialTypeAll(       iSubj, :) = trialType  ;
    delayActualAll(     iSubj, :) = delayActual;
    rtAll(              iSubj, :) = rt;
    % clear the loaded variables for this subject from the workspace
    clear wWidth wHeight flipInterval subjID trialType delayActual
end



%% COMPARE MEAN RESPONSE TIMES

% response-times only where trial type was 1 (TL)
rtTLAll                  = rtAll           ; % initialize rtBonkAll as equal to the rtAll matrix
rtTLAll(trialTypeAll~=1) = NaN               ; % set all response-times to NaN where trial-type isn't 1 (that is, on non-bonk trials)
rtTLAllAvg               = nanmean(rtTLAll, 2)   ; % vector giving average bonk-trial response time for each subject (nanmean ignores NaN values)

% instead of nanmean(rtBonkAll, 2) you could say mean(rtBonkAll, 2,'omitnan')
% response-times only where trial type was 2 (TR)
rtTRAll                  = rtAll         ; % initialize rtWhooshAll as equal to the rtAll matrix
rtTRAll(trialTypeAll~=2) = NaN             ; % set all response-times to NaN where trial-type isn't 2 (that is, on non-whoosh trials)
rtTRAllAvg               = nanmean(rtTRAll, 2) ; % vector giving average whoosh-trial response time for each subject (nanmean ignores NaN values)
       

% response-times only where trial type was 3 (BL)
rtBLAll                  = rtAll         ; % initialize rtBonkAll as equal to the rtAll matrix
rtBLAll(trialTypeAll~=3) = NaN             ; % set all response-times to NaN where trial-type isn't 1 (that is, on non-bonk trials)
rtBLAllAvg               = nanmean(rtBLAll, 2) ; % vector giving average bonk-trial response time for each subject (nanmean ignores NaN values)
        
% instead of nanmean(rtBonkAll, 2) you could say mean(rtBonkAll, 2,'omitnan')
% response-times only where trial type was 4 (BR)
rtBRAll                  = rtAll         ; % initialize rtWhooshAll as equal to the rtAll matrix
rtBRAll(trialTypeAll~=4) = NaN             ; % set all response-times to NaN where trial-type isn't 2 (that is, on non-whoosh trials)
rtBRAllAvg               = nanmean(rtBRAll, 2) ; % vector giving average whoosh-trial response time for each subject (nanmean ignores NaN values)
                         

[~, ptResTimeTLvsTR, citResTimeTLvsTR, statstResTimeTLvsTR] = ttest(rtTLAll, rtTRAll);

[~, ptResTimeTLvsBL, citResTimeTLvsBL, statstResTimeTLvsBL] = ttest(rtTLAll, rtBLAll);

[~, ptResTimeTLvsBR, citResTimeTLvsBR, statstResTimeTLvsBR] = ttest(rtTLAll, rtBRAll);

[~, ptResTimeTRvsBL, citResTimeTRvsBL, statstResTimeTRvsBL] = ttest(rtTRAll, rtBLAll);

[~, ptResTimeTRvsBR, citResTimeTRvsBR, statstResTimeTRvsBR] = ttest(rtTRAll, rtBRAll);

[~, ptResTimeBLvsBR, citResTimeBLvsBR, statstResTimeBLvsBR] = ttest(rtBLAll, rtBRAll);


%% DESCRIPTIVE STATISTICS

% for response-time measurements
meanRtTL   = mean(rtTLAllAvg  ) ; % mean of average response-times in TL condition
meanRtTR = mean(rtTRAllAvg) ; % mean of average response-times in TR condition
meanRtBL   = mean(rtBLAllAvg  ) ; % mean of average response-times in BL condition
meanRtBR = mean(rtBRAllAvg) ; % mean of average response-times in BR condition

sdRtTL   = std(rtTLAllAvg  ) ; % standard deviation of the mean for average response-times in TL   condition
sdRtTR = std(rtTRAllAvg) ; % standard deviation of the mean for average response-times in TR condition
sdRtBL   = std(rtBLAllAvg  ) ; % standard deviation of the mean for average response-times in BL   condition
sdRtBR = std(rtBRAllAvg) ; % standard deviation of the mean for average response-times in BR condition

%% BAR GRAPH OF MEAN RESPONSE TIMES

figure(1) % opens figure 3 window

bar(1:4, 1000* [meanRtTL meanRtTR meanRtBL meanRtBR], 'FaceColor', [0.5 0.5 1], 'BarWidth', 0.5) 

% label the graph (by using a cell array for the title, we can split it into two lines)
title( {'Mean Mean Response Times'}, 'FontSize', 16 ) % title
xlabel('Target Location', 'FontSize', 14) % x-axis label
ylabel('Mean Response Time (ms)', 'FontSize', 14) % y-axis label
set(gca, 'XTickLabel', {'Top-Left' 'Top-Right' 'Bottom-Left' 'Bottom-Right'}, 'FontSize', 12) % x-axis tick labels

hold on % keep the error bars from overwriting the bars
errorbar(1:4, 1000 * [meanRtBR meanRtTR meanRtBL meanRtBR], 1000 *[sdRtBR sdRtBL sdRtTR sdRtTL], 'LineStyle', 'none', 'Color', 'black', 'LineWidth', 2)
hold off

% (error bars might indicate standard deviations, standard errors, or confidence intervals, so you should always clarify which of those they indicate)
annotation('textbox', [.9 .7 .1 .2], 'String', ['Error bars indicate ' char(177) '1 SD'], 'EdgeColor','none')
%% PLOT INDIVIDUAL SUBJECTS' AVERAGE RESPONSE TIMES

figure(2) % open figure 4 window
% make plot

scatter(repelem(1:4, 1, n), 1000*[rtTLAllAvg ;rtTRAllAvg ; rtBLAllAvg;  rtBRAllAvg])
xlim([.5 4.5])  % x-axis limits (there are 2 condtions, but instead of just going from 1 to 2, give slight margin so points aren't on very edges of the graph)
% label the graph
title('Mean Response Times for Individual Subjects', 'FontSize', 16) % title
xlabel('Target Location', 'FontSize', 14) % x-axis label
ylabel('Mean Response Time (ms)' , 'FontSize', 14) % y-axis label ("ms" is the standard abbreviation for milliseconds)
set(gca, 'XTickLabel', {'Top-Left' 'Top-Right' 'Bottom-Left' 'Bottom-Right'}, 'FontSize', 12) % x-axis tick labels
xticks(1:4) % x-axis tick marks from 1:4