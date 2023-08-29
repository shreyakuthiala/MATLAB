clear;
clc;

% Lab 1
% create a vector of weight in kg from the given data below (in the order
% given): 81.65, 97.52, 95.25, 92.98, 86.18, 88.45, 66.41, 120.78

% 1.
weightKG = [81.65, 97.52, 95.25, 92.98, 86.18, 88.45, 66.41, 120.78];
% 2.
weightLB = weightKG * 2.2; % creates new vector called "weightLB" which contains weights in pounds

% 3.
max(weightLB) % finds maximum value in vector of weights in LB
min(weightLB) % finds minimum value in vector of weights in LB
mean(weightLB) % finds mean value of vector of weights in LB
sum(weightLB) % finds sum value of vector of weights in LB

% 4.
sort(weightLB)

% 5.
find(weightLB > 200)

% 6.
x = weightLB(7)

% 7.
y = weightLB([1, 3, 7])

% 8.
weightLB(6) = 777

% 9.
newWeightLB = floor(weightLB) + 20



