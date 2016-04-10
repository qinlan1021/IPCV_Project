function out = padWithZeros(in, ROWS, COLS)
% PADWITHZEROS - Pads matrix with zeros up to W and H, centers the data in the matrix
out = padarray(in,[floor((ROWS-size(in,1))/2) floor((COLS-size(in,2))/2)],0,'both');
if size(out,1) == ROWS-1
    out = padarray(out,[1 0],0,'pre');
end
if size(out,2) == COLS-1
    out = padarray(out,[0 1],0,'pre');
end
    