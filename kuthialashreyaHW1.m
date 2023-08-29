% Author: Shreya Kuthiala (Sep. 29, 2022)
% This program will define two vectors of mock data and complete some
% computations as given in the assignment such as: completing conversions,
% finding the mean, maximum, difference, proportion, and other mathematical
% functions.

clear;
clc;
beatsPerMinDay1 = [66.9, 90.2, 68.4, 69.1, 73.7, 81.3, 69.4, 97.6, 51.8, 105.5]; % defines a vector called "beatsPerMinDay1" which consists of heartrate measurements from day1 in beats-per-minute
beatsPerMinDay2 = [54.7, 79.2, 75.2, 67.0, 81.4, 63.1, 77.9, 90.3, 57.3, 102.8]; % defines a vector called "beatsPerMinDay2" which consists of heartrate measurements from day2 in beats-per-minute

beatsPerSecDay1 = beatsPerMinDay1 / 60; % defines a new vector called "beatsPerSecDay2" which takes values from beatsPerMinDay1 and converts values from minutes to seconds
beatsPerSecDay2 = beatsPerMinDay2 / 60; % defines a new vector called "beatsPerSecDay2" which takes values from beatsPerMinDay2 and converts values from minutes to seconds

meanBeatsPerMinDay1 = mean(beatsPerMinDay1); % defines a new vector which contains values of the mean value of the beatsPerMinDay1 vector
meanBeatsPerMinDay2 = mean(beatsPerMinDay2); % defines a new vector which contains values of the mean value of the beatsPerMinDay2 vector

maxBeatsPerMinDay1 = max(beatsPerMinDay1); % returns the value of the maximum beatsPerMin in Day1 
maxBeatsPerMinDay2 = max(beatsPerMinDay2); % returns the value of the maximum beatsPerMin in Day2

changeBeatsPerMin = beatsPerMinDay2 - beatsPerMinDay1; % returns a new vector including the difference of beatsPerMin between day2 and day1

propHeartRateIncreases = sum(beatsPerMinDay2 > beatsPerMinDay1)/numel(beatsPerMinDay1); % returns the proportion of subjects whose heart rate was higher on day2 than day1

whichSubjectHeartRateDecrease = beatsPerMinDay1(beatsPerMinDay1 > beatsPerMinDay2); % creates a victor which gives the indexes of the subjects whose heart rate was higher on d1 than d2

numUnusualHeartRateDay1 =  sum(beatsPerMinDay1 < 60 | beatsPerMinDay1 > 95); % determines the number of unusual heart rates in day 1

numUnusualHeartRateDay2 = sum(beatsPerMinDay2 < 60 | beatsPerMinDay2 > 95); % determines the number of unusual heart rates in day 2

beatsPerMinDay1First5 = beatsPerMinDay1([1:5]); % creates a vector which contains the first 5 values from beatsPerMinDay1

beatsPerMinOver95Day2 = beatsPerMinDay2(beatsPerMinDay2 > 95); % creates a new vector wich contains the heart rates on day 2 that were over 95 bpm