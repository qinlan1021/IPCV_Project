function [C, S] = createGaborBank(SIZE, PERIOD, SIGMA, NORIENT, ROWS, COLS, E)
%%%%%%%%%%%%%%%%%%%%%%% create bank of Gabors
% SIZE = 32;  % Gabor kernel size
% PERIOD = 32;%16; % frequency
% SIGMA = PERIOD/2*sqrt(2); % variance
% NORIENT = 72; % # orientations
% ROWS, COLS  %filter size
% E = 8 % ellipticity (1 - circlular)
if (length(NORIENT)==1)
    orientations=[1:NORIENT];
else
    orientations = NORIENT;
    NORIENT = max(orientations);
end

for n=orientations
    [C{n}, S{n}] = gabormask(SIZE, SIGMA, PERIOD, n*pi/NORIENT);
    C{n} = fft2(padWithZeros(C{n}, ROWS, COLS)); 
    S{n} = fft2(padWithZeros(S{n}, ROWS, COLS));
end
