function cross_point=linecross(k1,b1,k2,b2)
x=[];
y=[];
if k1==k2&b1==b2
disp('all the line is cross_point');
elseif k1==k2&b1~=b2
disp('there is no cross_point');
else
x=(b2-b1)/(k1-k2);
y=k1*x+b1;
cross_point=[x y];
disp('The cross-point is');
disp(cross_point);
end