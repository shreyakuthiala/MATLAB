% Author: Shreya Kuthiala (Oct. 08, 2022)
% This program will diagram what a chess board will look like after every
% move that each player makes & analyze the amountn of time each player
% took for each move. Coding scheme we will be using for the pieces on the
% chesssboard: white pawn = 1, white rook = 2, white knight = 3, white bishop = 4, 
% white queen = 5, white king = 6,corresponding negative numbers for the black 
% pieces (black pawn = –1, black rook = –2, etc.), and empty square = 0.

clear;
clc;

%% BOARD DIAGRAMS

boardStart = [2 3 4 5 6 4 3 2
         1 1 1 1 1 1 1 1
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         0 0 0 0 0 0 0 0
         -1 -1 -1 -1 -1 -1 -1 -1
         -2 -3 -4 -6 -5 -4 -3 -2] % defines an 8x8 matrix representing a chessboard with pieces in standard starting positions


move1 = boardStart; %initializes move1
move1(2, 4) = 0; %changes the space to empty because the piece moved
move1(4, 4) = 1; %changes the space to a pawn

move2 = move1; %initializes move2
move2(7,5) = 0; %changes the space to empty because the piece moved
move2(5,5) = -1; %changes the space to a black pawn

move3 = move2; %initializes move3
move3(5,5) = 1; %changes the space to a pawn
move3(4,4) = 0; %changes the space to empty because the piece moved

move4 = move3; %initializes move4
move4(8,5) = 0; %changes the space to empty because the piece moved
move4(5,5) = -5; %changes the space to the black queen

move5 = move4; %initializes move5
move5(1,4) = 0; %changes the space to empty because the piece moved
move5(2,4) = 6; %changes the space to the king

move6 = move5; %initializes move6
move6(4,4) = -5; %changes the space to the black queen
move6(8,5) = 0; %changes the space to empty because the piece moved

fullGame = cat(3,move1, move2, move3, move4, move5, move6); % defines an 8x8x6 matrix where page1 = positions of pieces after 1st move, page2 - 2nd move, etc.

fullGameRotated = rot90(fullGame, 1); %rotates the fullGame by 90 degrees

%% MOVE-TIME ANALYSIS

moveSecs = [0.3 0.8 1.3
            0.5 0.9 0.6];
meanMoveSecs = mean(moveSecs);
grandMeanMoveSecs = mean(meanMoveSecs);
totalGameSecs = sum(moveSecs);



