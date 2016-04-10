function row = findHorizon(im)
% FINDHORIZON - computes the horizon line on poorly deliniated roads
% IM - grayscale double image
% ROW - Y coordinate of the horizon line

% set to 1,2 to display debug images ar various stages
DEBUG = 2;

IM = fft2(im);
ROWS = size(IM,1); COLS = size(IM,2);

%%%%%%%%%%%%%%%%%%% Create a bank of Gabors
PERIOD = 2^floor(log2(COLS)-5)+2; % frequency
SIZE = floor(10*PERIOD/pi);  % Gabor kernel size
SIGMA = SIZE/9; % variance
NORIENT = 72; % number of filter orientations
E = 16;  % ellipticity
orientations = [NORIENT/2-10:NORIENT/2+10]; % use only horizontal orientations

[C, S] = createGaborBank(SIZE, PERIOD, SIGMA, orientations, ROWS, COLS, E);

%%%%%%%%%%%%%%%%%%% Convolve and sum up filter responses
ASUM = zeros(ROWS, COLS);
for n=orientations
    A = ifftshift(real(ifft2(C{n}.*IM)).^2+real(ifft2(S{n}.*IM))).^2;
    ASUM = ASUM + A;        
    if (DEBUG==1)
     	colormap('hot');subplot(131);imagesc(real(A));subplot(132);imagesc(real(AMAX));colorbar;
       	pause
	end
end

%%%%%%%%%%%%%%%%%%% Find the horizon
ASUM(1:round(1+SIZE/2), :)=0; ASUM(end-round(SIZE/2):end, :)=0;
ASUM(:,end-round(SIZE/2):end)=0; ASUM(:, 1:1+round(SIZE/2))=0;
dd = sum(ASUM, 2);
[temp, row] = sort(-dd);
row = round(mean(row(1:10)));
if (DEBUG == 2)
	imagesc(ASUM);hold on;line([1:COLS],repmat(row,COLS));
    pause
end

