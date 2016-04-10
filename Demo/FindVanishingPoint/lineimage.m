function v = lineimage(x0, y0, angle, s) 
% generate a line in the image of size s
% create a line y = k*x + (y0-k*x0)
% v - Return a vector of line coordinates in the image (coordinates are
% linearized) 

if (abs(tan(angle)) > 1e015) % vertical line
    a(1,:) = repmat(x0,s(1),1)';
    a(2,:) = [1:s(1)];
elseif (abs(tan(angle)) < 1e-015) % horizontal line
    a(2,:) = repmat(y0,s(2),1)';
    a(1,:) = [1:s(2)];
else
   
    k = tan(angle);
    % leftmost and rightmost absccissas
    hiX = round((1-(s(1)-y0+1)+k*x0)/k);
    loX = round((s(1)-(s(1)-y0+1)+k*x0)/k);
    temp = max(loX, hiX);
    loX = max(min(loX, hiX), 1);
    hiX = min(s(2),temp);
    % cut everything outside
    a(1,:) = [loX:hiX];
    a(2,:) = max(1, floor(s(1)-(k*a(1,:)+(s(1)-y0+1)-k*x0)));
end
v = (a(1,:)-1).*s(1)+a(2,:);