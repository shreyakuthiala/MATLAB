function answer = ftinch(userFt, userInches)
%FTINCH Converts inches to ft/inches or ft/inches to simply inches
% This program will convert mixed units (for example, feet & inches)
% to simply inches or vice versa. If the user enters only one input, that
% input will be considered as inches, and the fx will convert those inches
% to mixed units. If the user enters 2 inputs (each a single vector), the
% first input will be considered the "foot" part, and the second input will
% be considered the corresponding "inch" part, and the fx will convert the
% pair to a single value in inches. outputArg1 = inputArg1;

userInches= ('\nEnter a number to convert to ft/inches or ft/inches to convert to simply inches.\n');

if nargin == 2 % if there are 2 inputs...
    if numel(userFt) ~= numel(userInches)
        error('Ft and inch inputs must have the same number of elements.') % creates error message
    end
    heightConv = (userFt .* 12) + userInches;
    if isrow(heightConv) % checks if height is row vector
        heightConv = heightConv(:); % reshapes vector into column vector
    end
elseif nargin == 1 % if there is 1 input...
    userInches = userFt; % reassigns only input to inches
    heightConv = [fix(userInches/12) rem(userInches, 12)]; % converts inches to mixed units
    heightConv = reshape(heightConv, numel(userInches), 2); % reshapes heights
end

if ~isnumeric(userInches)    % if the input is not numeric, will return an error
    error('Inputs must be numeric.')
end

if ~isvector(userInches) % if the input is not a scalar/vector, will return an error
    error('Inputs must be vectors or scalars.')
end

end