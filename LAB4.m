clear;
clc;

numbers = [951, 402, 984, 651, 360, 69, 408, 319, 601, 485, 980, 507, 725, 547, 544,...
    615, 83, 165, 141, 501, 263, 617, 865, 575, 219, 390, 984, 592, 236,105, 942, 941,...
    386, 462, 47, 418, 907, 344, 236, 375, 823, 566, 597, 978, 328, 615, 953, 345,...
    399, 162, 758, 219, 918, 237,...
    412, 566, 826, 248, 866, 950, 626, 949, 687, 217,...
    815, 67, 104, 58, 512, 24, 892, 894, 767, 553, 81, 379, 843, 831, 445, 742, 717,...
    958, 609, 842, 451, 688, 753, 854, 685, 93, 857, 440, 380, 126, 721, 328, 753, 470,...
    743, 527];
%% FOR LOOP:
for i = 1:numel(numbers)
    if numbers(i) == 237
        break
    elseif numbers(i)<400 && numbers(i)>200
        fprintf('%d, ',numbers(i))
    end
end

fprintf('\n')
%% WHILE LOOP:
i = 1; 
while (numbers(i) ~= 237)
    if numbers(i)<400 && numbers(i)>200
        fprintf('%d, ', numbers(i))
    end
    i = i+1;
end


%% work from hw4 (wrong)

while true

    answer = input(['Enter the number of states to include on the ' ...
        'quiz: \n'], 's') % asks the user the number of states they want to include in the quiz

    if ((0 < answer) && (answer < 51)) == 1 % a number between 1 and 50
        capitalResponse = [capitalResponse answer];
        break

    else capitalResponse = input(['Enter the number of states to include on the ' ...
            'quiz: \n'], 's') % re-asks the question if the user does not input a valid response
    end
end

%%