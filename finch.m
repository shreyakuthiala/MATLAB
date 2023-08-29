function [outputArg1,outputArg2] = untitled3(inputArg1,inputArg2)
%FTINCH Summary of this function goes here
% This program will convert mixed units (for example, feet & inches)
% to simply inches or vice versa. If the user enters only one input, that
% input will be considered as inches, and the fx will convert those inches
% to mixed units. If the user enters 2 inputs (each a single vector), the
% first input will be considered the "foot" part, and the second input will
% be considered the corresponding "inch" part, and the fx will convert the
% pair to a single value in inches. outputArg1 = inputArg1;
outputArg2 = inputArg2;

function [ft, inches] = ftinch(userIn) %## FIX OUTPUT / INPUT ARGS 


userIn = input(['Enter a number to convert to ft/inches or ft/inches to ' ...
    'convert to inches.'])

ftinch = @(ft, inches) inches ./ 12 ; 

% if ~isnumeric(ft, inches)    % if the input is not numeric, will return an error
%  error('Inputs must be numeric.')
% end
% 
% if ~isvector(inputFt, inputIn) % if the input is not a scalar/vector, will return an error
%     error('Inputs must be vectors or scalars.') 
% end
% 
% function ftinch = total(ft, inches)
% 
% if nargin == 1
%     printfprint([floorDiv(input/12) rem(input, 12)])
% elseif nargin == 2
%     ft = input(1);
%     inches = input(2);
% end


end