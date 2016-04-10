% % This is the program of using vashing points for calibration
% % note by

clc;
clear all;
% % % %%%%读入数据
C=load('camera coordinate.txt');
W=load('world coordinate.txt');

% % % 计算灭点坐标
plot(C(:,1),-C(:,2),'r*');
hold on
%求Fu坐标 
x1=[C(3,1),C(5,1),C(7,1),C(8,1),C(9,1)];
y1=[C(3,2),C(5,2),C(7,2),C(8,2),C(9,2)];
p1=polyfit(x1,y1,1);

x2=[C(2,1),C(4,1)];
y2=[C(2,2),C(4,2)];
p2=polyfit(x2,y2,1);

Fu=cross_point(p1(1),p1(2),p2(1),p2(2));
plot(Fu(1),-Fu(2),'b+'),hold on;

%求Fv坐标 
x3=[C(1,1),C(3,1)];
y3=[C(1,2),C(3,2)];
p3=polyfit(x3,y3,1);

x4=[C(4,1),C(6,1),C(7,1)];
y4=[C(4,2),C(6,2),C(7,2)];
p4=polyfit(x4,y4,1);

Fv=cross_point(p3(1),p3(2),p4(1),p4(2));
plot(Fv(1),-Fv(2),'b+'),hold on;

% 画灭点的相交直线
x=C(3,1):0.1:Fu(1);
y=p1(1)*x+p1(2);plot(x,-y),hold on;
x=405:0.1:Fu(1);
y=p2(1)*x+p2(2);plot(x,-y),hold on;
x=Fv(1):0.1:405;
y=p3(1)*x+p3(2);plot(x,-y),hold on;
x=Fv(1):0.1:C(4,1);
y=p4(1)*x+p4(2);plot(x,-y),hold on;
line([Fu(1) Fv(1)],[-Fu(2) -Fv(2)]),hold on;
plot(352,-288,'r.'),hold on;

% % %Puv点坐标
P=[352 288];
Puv=Fu+dot((Fv-Fu),(P-Fu))*(Fv-Fu)/normest(Fv-Fu)^2;
plot(Puv(1),-Puv(2),'b+'),hold on;

% % %求焦距f
f=sqrt(normest(Puv-Fv)*normest(Fu-Puv)-normest(P-Puv)^2);

% % %求旋转矩阵
Fu_Rc=[Fu(1)-352 Fu(2)-288 f];
Fv_Rc=[Fv(1)-352 Fv(2)-288 f];
M_o_c=[Fu_Rc/normest(Fu_Rc);Fv_Rc/normest(Fv_Rc);cross(Fu_Rc,Fv_Rc)/normest(cross(Fu_Rc,Fv_Rc))]';

% % % 求平移向量
%选0,3点
a_Rc=[[405 522]-[352 288] f];
b_Rc=[C(3,:)-[352 288] f];
AB=600;
OA=AB*normest(a_Rc)*normest(b_Rc-Fv_Rc)/normest(b_Rc-a_Rc)/normest(Fv_Rc);
OA_Rc=OA*a_Rc/normest(a_Rc);
T_o_c=inv(M_o_c)*OA_Rc';
% % % 显示计算结果
disp('The f is');
disp(f);

disp('The R is');
disp(M_o_c);

disp('The T is');
disp(T_o_c);

% %验证
% M_o_c*[300;0;0]+[T_o_c(1);T_o_c(2);T_o_c(3)]