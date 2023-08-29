
clc; clear all;

rng shuffle

rolls = input("How many times would you like to roll the dice?\n")

i = 1;
tic;
for k = i:rolls
    pause;
    value = (randi(6));
    disp(value)
end

if k(i) == rolls
    disp(toc)
end