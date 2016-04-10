function row = findHorizon(im)
% FINDHORIZON - computes the horizon line on poorly deliniated roads
% IM - grayscale double image
% ROW - Y coordinate of the horizon line

% set to 1,2 to display debug images ar various stages
DEBUG = 2;

ROWS = size(im,1); COLS = size(im,2);
e = edge(im,'sobel', [], 'horizontal');
dd = sum(e, 2);
%%%%%%%%%%%%%%%%%%% Convolve and sum up filter responses
N=3;
row = 1; 
M = 0;
for i=1+N:length(dd)-N
    m = sum(dd(i-N:i+N));    
    if (m > M)
        M = m;
        row = i;
    end
end


imshow(e);pause