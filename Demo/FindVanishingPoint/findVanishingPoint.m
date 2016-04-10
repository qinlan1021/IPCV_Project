function [row, col] = findVanishingPoint(im)
% FINDVANISHINGPOINT - computes the vanishing point on poorly deliniated roads
% IM - grayscale double image
% ROW, COL - coordinates of the vanishing point

% set to 1,2 to display debug images ar various stages
DEBUG = 0;

IM = fft2(im);
ROWS = size(IM,1); COLS = size(IM,2);

%%%%%%%%%%%%%%%%%%% Create a bank of Gabors
PERIOD = 2^floor(log2(COLS)-5)+2; % frequency
SIZE = floor(10*PERIOD/pi);  % Gabor kernel size
SIGMA = SIZE/9; % variance
NORIENT = 72; % number of filter orientations
E = 8;  % ellipticity
[C, S] = createGaborBank(SIZE, PERIOD, SIGMA, NORIENT, ROWS, COLS, E);

%%%%%%%%%%%%%%%%%%% Convolve and record orientation which gives the best response at each pixel
D = ones(ROWS, COLS); % number of dominant orientation
AMAX = ifftshift(real(ifft2(C{1}.*IM)).^2+real(ifft2(S{1}.*IM))).^2; % response at the dominant orientation
for n=2:NORIENT
    A = ifftshift(real(ifft2(C{n}.*IM)).^2+real(ifft2(S{n}.*IM))).^2;
    D(find(A > AMAX)) = n;        
    AMAX = max(A, AMAX);        
    if (DEBUG==1)
     	colormap('hot');subplot(131);imagesc(real(A));subplot(132);imagesc(real(AMAX));colorbar;
        subplot(133);imagesc(D);
       	pause
	end
end

%%%%%%%%%%%%%%%%%%% At each pixel find orientation that gives maximum response
if (DEBUG==2)
	figure('DoubleBuffer','on');
end
% threshold responses below mean-3*sigma
T = mean(AMAX(:))-3*std(AMAX(:));
VOTE = zeros(ROWS, COLS);
for row=round(1+SIZE/2):round(ROWS-SIZE/2) % exclude edge pixels half the kernel size on each side 
    for col=round(1+SIZE/2):round(COLS-SIZE/2)
        if (AMAX(row,col) > T)
            indices = lineBresenham(ROWS, COLS, col, row, D(row, col)*pi/NORIENT-pi/2);
            VOTE(indices) = VOTE(indices)+AMAX(row,col);
        end
    end
    if (DEBUG==2)
        colormap('hot');imagesc(VOTE);pause;                                        
	end
end
if (DEBUG==2)
	close
end

M=1;
[b index] = sort(-VOTE(:));
col = floor((index(1:M)-1) / ROWS)+1;
row = mod(index(1:M)-1, ROWS)+1;
col = round(mean(col));
row = round(mean(row));

%%%%% use horizon for vanishing point
% row = row_horiz;
% [temp, col] = max(VOTE(row_horiz,:));