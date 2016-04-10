function [i] = lineBresenham(H,W,Sx,Sy,angle)
% LINEBRESENHAM  - Rasterizes a line using Bresenham line algorithm.
%                  This version draw the lines only up from 'Sx, Sy' at
%                  'angle'
% Sx, Sy, - start point
% angle - slope in radians
% Goes up the image, breaks at the top or left/right wall
% Always goes in Ist or IInd quadrant
% Ey > Sy always !!!
% I - returns the coordinates of the line pixels

    k = tan(angle);
    if (angle == pi || angle == 0)
        Ex = W;
        Ey = Sy;
        Sx = 1;
    elseif (angle == pi/2)
        Ey = 1;
        i = (Sx-1)*H+[Ey:Sy];
        return;
    elseif k>0 & k < (Sy-1)/(W-Sx) % right wall
        Ex = W;
        Ey = round(Sy-tan(angle)*(Ex-Sx));
    elseif k < 0 & abs(k) < (Sy-1)/(Sx-1) % left wall
        Ex = 1;
        Ey = round(Sy-tan(angle)*(Ex-Sx));
    else
        Ey = 1; % top wall        
        Ex = round((Sy-1)/tan(angle)+Sx);
    end
% ------------------------------    
	Dx = Ex - Sx;
	Dy = Ey - Sy;
    iCoords=1;
	if(abs(Dy) <= abs(Dx))
		if(Ex >= Sx)
			D = 2*Dy + Dx;
			IncH = 2*Dy;
			IncD = 2*(Dy + Dx);
			X = Sx;
			Y = Sy;
            i(iCoords) = (Sx-1)*H+Sy;
            iCoords = iCoords + 1;
			while(X < Ex)
				if(D >= 0)
					D = D + IncH;
					X = X + 1;
				else
					D = D + IncD;
					X = X + 1;
					Y = Y - 1;
				end
                i(iCoords) = (X-1)*H+Y;
                iCoords = iCoords + 1;                
			end
		else % Ex < Sx
			D = -2*Dy + Dx;
			IncH = -2*Dy;
			IncD = 2*(-Dy + Dx);
			X = Sx;
			Y = Sy;
            i(iCoords) = (Sx-1)*H+Sy;
            iCoords = iCoords + 1;
			while(X > Ex)
				if(D <= 0)
					D = D + IncH;
					X = X - 1;
				else
					D = D + IncD;
					X = X - 1;
					Y = Y - 1;
				end
                i(iCoords) = (X-1)*H+Y;
                iCoords = iCoords + 1;   
			end
		end

        
    else % abs(Dy) > abs(Dx) 
    	Tmp = Ex;
		Ex = Ey;
		Ey = Tmp;
		Tmp = Sx;
		Sx = Sy;
		Sy = Tmp;
		Dx = Ex - Sx;
		Dy = Ey - Sy;
		if(Ex >= Sx)
			D = 2*Dy + Dx;
			IncH = 2*Dy;
			IncD = 2*(Dy + Dx);
			X = Sx;
			Y = Sy;
            i(iCoords) = (Sy-1)*H+Sx;
            iCoords = iCoords + 1;
			while(X < Ex)
				if(D >= 0)
					D = D + IncH;
					X = X + 1;
				else
					D = D + IncD;
					X = X + 1;
					Y = Y - 1;
				end
                i(iCoords) = (Y-1)*H+X;
                iCoords = iCoords + 1;   
			end
		else % Ex < Sx
			D = -2*Dy + Dx;
			IncH = -2*Dy;
			IncD = 2*(-Dy + Dx);
			X = Sx;
			Y = Sy;
            i(iCoords) = (Sy-1)*H+Sx;
            iCoords = iCoords + 1;
			while(X > Ex)
				if(D <= 0)
					D = D + IncH;
					X = X - 1;
				else
					D = D + IncD;
					X = X - 1;
					Y = Y - 1;
				end
                i(iCoords) = (Y-1)*H+X;
                iCoords = iCoords + 1;   
			end
		end        
    end