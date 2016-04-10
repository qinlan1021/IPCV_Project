function [abscissa, ordinate] = linevector(x0, y0, angle, s) 
% generate a line in the image of size s
% create a line y = k*x + (y0-k*x0)

if (rad2deg(angle) == 90) 
        abscissa = repmat(x0,s(1),1);
        ordinate = [1:s(1)];
else
    k = tan(angle);
    % leftmost and rightmost absccissas
    hiX = round((1-(s(1)-y0+1)+k*x0)/k);
    loX = round((s(1)-(s(1)-y0+1)+k*x0)/k);
    temp = max(loX, hiX);
    loX = max(min(loX, hiX), 1);
    hiX = min(s(2),temp);
    % cut everything outside
    
    abscissa = [loX:hiX];
    ordinate = k*abscissa+((s(1)-y0+1)-k*x0);
end