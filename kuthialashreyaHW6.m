% Author: Shreya Kuthiala (Nov. 03, 2022)
% This program will 
% This program requires the use of the file 
% and
% creates the file 'psych20ahw5data.mat'.

clc;
clear;
close all; % closes all open figures
rng('default') % sets the rng to the default seed
rng(0) % sets the seed of the rng to 0

%% ORIGINAL IMAGE
fpath = '/Users/kuthiala/Downloads/';
fname = 'drakeMeme.jpg';
drakeOriginalRBG = imread(fullfile(fpath, fname)); % imports image file into RBG array
size = size(drakeOriginalRBG); % gives the size of image in pixels
drakeHeight = 1200;
drakeWidth = 600;

%% EXTACT TOP HALF OF IMAGE
drakeTop = drakeOriginalRBG(1:600, :, :);
%size(drakeTop);
%% 

%% VERTICALLY & HORIZONTALLY MIRROR THE IMAGE
%drakeMirror = imshow(drakeTop) && imshow(fliplr(drakeTop)) && imshow(flipup(drakeTop));
drakeMirror = figure(1);
drake2 = flip(drakeTop, 2); % flips horizontally
drake3 = flip(drakeTop, 1); % flips vertically
drake4 = rot90(drakeTop, 2); % flips horizontally & vertically
out = imtile({drakeTop, drake2, drake3, drake4}); % creates tile of images
figure(1), imshow(out);

%% BLACK-TO-DARK-MAGENTA GRADIENT
%columns = size(drakeTop);
figure(2)
background_L = 1200;
background_B = 600;
black = [0 0 0]; 
magenta = [255 0 255];
blackToMagentaGradient(1:background_B, 1:background_L, 1:3) = 255;

a1 = round(linspace(black(1), magenta(1), 600)); % R in RGB array
a2 = round(linspace(black(2), magenta(2), 600)); % G in RGB array
a3 = round(linspace(black(3), magenta(3), 600)); % B in RGB array

blackToMagentaGradient = uint8(blackToMagentaGradient);

vFactor = 0.5; % scalar used to decrease brightness to 50%
for x = 1:length(blackToMagentaGradient)
    blackToMagentaGradient(:,x,1) = a1(x)*vFactor;
    blackToMagentaGradient(:,x,2) = a2(x)*vFactor;
    blackToMagentaGradient(:,x,3) = a3(x)*vFactor;
    figure(2), imshow(blackToMagentaGradient) % runs program for black-magenta gradient
end
% zeroTo255Vec = uint8(linspace(0, 255, 600)); 
% blackToMagentaGradient(:,:,1) = repmat(zeroTo255Vec, 600); 
% rgbImage = cat(3, black, black, blackToMagentaGradient); % merges R G B matrix % imshow(rgbImage)

%blackToMagentaGradient = colorGradient([0 0 0], [255 0 255])

%% REPLACE BACKGROUND WITH GRADIENT

%drakeGrad = drakeMirror

drakeMirror = imresize(drakeMirror, [600 600]);
yellowReplace = drakeMirror(:,:,1) > 150 & drakeMirror (:,:,2) > 150 & drakeMirror(:,:,3) < 150;
drakeGrad = blackToMagentaGradient .* uint8(yellowReplace) + drakeMirror .* uint8(~yellowReplace);
imshow(drakeGrad);

%% REPLACE BACKGROUND WITH NOISE

noise = uint8(randi([0 255], [600 600 3]));
drakeNoise = noise .* uint8(yellowReplace) + drakeMirror .*uint8(~yellowReplace);
imshow(drakeNoise);
%% DISPLAY
figure(1)
subplot(2,1,1), imshow(drakeTop,map1);
subplot(2,1,2), imshow(drakeMirror,map2);
subplot(2,1,3), imshow(drakeGrad,map3);
subplot(2,1,4), imshow(drakeNoise,map4);
title(X1('drakeTop'), X2('drakeMirror'), X3('drakeGrad'), X4('drakeNoise')); % creates title
%drakeArray = repmat(drakeTop, [1 0 0 4], drakeMirror, [0 1 0 4], drakeGrad, [0 0 1 4], drakeNoise, [1 0 0 4]);
%montage(drakeArray)
%figure(1), imshow(drakeTop)

figure(2) % creates figure2
imshow(drakeNoise); % shows drakeNoise image
title('drakeNoise'); % creates title

%% SAVE
imwrite(drakeNoise, 'drakeNoise.png') % exports drakeNoise to png file
saveas('Figure 1', 'drakefig.pdf'); % exports Figure 1 to pdf file
