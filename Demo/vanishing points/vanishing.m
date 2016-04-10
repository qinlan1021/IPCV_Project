clear,close all;
clc;

points = [245,508,117,592,238,455,335;410,386,321,275,230,214,161];
%%
%compute the rate from pixel to distances
P1 = [points(1,1) points(2,1)];
P2 = [points(1,2) points(2,2)];

Pixel_D = norm(P1 - P2,'fro');
Real_D = 300*sqrt(2);
global rate;
rate = Real_D / Pixel_D; %mm
%%
%get the vanishing points

%vanishPoint1_x = (points(1,1)*points(2,3)-points(2,1)*points(1,3))/(points(1,1)-points(1,3))-(points(1,4)*points(2,7)-points(2,4)*points(1,7))/(points(1,4)-points(1,7));
%tmp1 = (points(2,4)-points(2,7))/(points(1,4)-points(1,7))-(points(2,1)-points(2,3))/(points(1,1)-points(1,3));
vanishPoint1_x = (points(1,1)*points(2,3)-points(2,1)*points(1,3))*(points(1,4)-points(1,7)) - (points(1,4)*points(2,7) - points(1,7)*points(2,4))*(points(1,1) - points(1,3));
tmp1 = ((points(2,4) - points(2,7))* (points(1,1) - points(1,3)) - (points(2,1) - points(2,3))*(points(1,4) - points(1,7)));
vanishPoint1_x = vanishPoint1_x / tmp1;

vanishPoint1_y = vanishPoint1_x * (points(2,4) - points(2,7)) + points(1,4)*points(2,7) - points(1,7)*points(2,4);
vanishPoint1_y = vanishPoint1_y / (points(1,4) - points(1,7));

%vanishPoint2_x = (points(1,7)*points(2,3)-points(2,7)*points(1,3))/(points(1,7)-points(1,3))-(points(1,4)*points(2,2)-points(2,4)*points(1,2))/(points(1,4)-points(1,2));
%tmp2 = (points(2,4)-points(2,2))/(points(1,4)-points(1,2))-(points(2,7)-points(2,3))/(points(1,7)-points(1,3));
vanishPoint2_x = (points(1,7)*points(2,3)-points(2,7)*points(1,3))*(points(1,4)-points(1,2)) - (points(1,4)*points(2,2) - points(1,2)*points(2,4))*(points(1,7) - points(1,3));
tmp2 = ((points(2,4) - points(2,2))* (points(1,7) - points(1,3)) - (points(2,7) - points(2,3))*(points(1,4) - points(1,2)));
vanishPoint2_x = vanishPoint2_x / tmp2;

vanishPoint2_y = vanishPoint2_x * (points(2,4) - points(2,2)) + points(1,4)*points(2,2) - points(1,2)*points(2,4);
vanishPoint2_y = vanishPoint2_y / (points(1,4) - points(1,2));

v_V1 = [vanishPoint1_x vanishPoint1_y];
v_V2 = [vanishPoint2_x vanishPoint2_y];

%%
%compute the focus distance
point_P_x = 352;
point_P_y = 288;
v_P = [point_P_x,point_P_y];
[v_real_P_x,v_real_P_y] = pixel2space(point_P_x,point_P_y);


k = (vanishPoint2_y - vanishPoint1_y) / (vanishPoint2_x - vanishPoint1_x);
Puv_x = (point_P_x +  k * point_P_y - vanishPoint2_y * k) / (k^2 +1-vanishPoint2_x * k^2);
Puv_y = vanishPoint2_y -vanishPoint2_x * k + Puv_x * k;

v_Puv = [Puv_x Puv_y];
[v_Real_Puv_x,v_Real_Puv_y] = pixel2space(Puv_x,Puv_y);

v1toPuv = v_V1 - v_Puv;
v2toPuv = v_V2 - v_Puv;

Dv12Puv = norm(v1toPuv,'fro');
Dv22Puv = norm(v2toPuv,'fro');
D_O2Puv =sqrt(Dv12Puv * Dv22Puv);

D_P2Puv = norm(v_P - v_Puv,'fro');
D_Pixel_focus = sqrt(D_O2Puv^2 - D_P2Puv^2);
D_Real_focus = D_Pixel_focus * rate;
display(D_Real_focus);

%%
%compute the rotate matrix
D_Pixel_P2V1_x =v_V1(1,1) - v_P(1,1);
D_Pixel_P2V1_y =v_V1(1,2) - v_P(1,2);

[D_Real_P2V1_x,D_Real_P2V1_y] = pixel2space(D_Pixel_P2V1_x,D_Pixel_P2V1_y);

real_V1 = [D_Real_P2V1_x D_Real_P2V1_y D_Real_focus];

D_Pixel_P2V2_x =v_V2(1,1) - v_P(1,1);
D_Pixel_P2V2_y =v_V2(1,2) - v_P(1,2);

%D_Real_P2V2_x = D_Pixel_P2V2_x * rate;
%D_Real_P2V2_y = D_Pixel_P2V2_y * rate;
[D_Real_P2V2_x,D_Real_P2V2_y] = pixel2space(D_Pixel_P2V2_x,D_Pixel_P2V2_y);

real_V2 = [D_Real_P2V2_x D_Real_P2V2_y D_Real_focus];

%世界坐标系上的3个单位向量
u1 = real_V1 /norm(real_V1);
v2 = real_V2 /norm(real_V2);
w3 = cross(v2,u1);

rotate_Matrix = [u1;v2;w3]';
display(rotate_Matrix);

%%
%compute the translate vector
%d = 600;%瓷砖宽度，mm

%  k_v2 = v2(1,2) / v2(1,1);
% k_ad = points(2,4) / points(1,4);
% 
% point_pixel_d = [points(1,4) points(2,4)];
% [point_real_d_x,point_real_d_y] = pixel2space(points(1,4), points(2,4));
% 
% point_real_d = [point_real_d_x point_real_d_y D_Real_focus];

% point_pixel_a = [ 2 *points(1,2) -points(1,4)  2 *points(2,2) -points(2,4)];
% [point_real_a_x,point_real_a_y] = pixel2space(424, 497);
% 
% point_real_a = [point_real_a_x point_real_a_y D_Real_focus];
% 
% 
% 
% ppp_real_x = (v2(1,1) * point_real_a_y - v2(1,2) * point_real_a_x) / (v2(1,1) * point_real_d_y / point_real_d_x - v2(1,2));
% ppp_real_y = ppp_real_x * k_ad;
% 
% ppp_real_z = D_Real_focus * ppp_real_y / point_real_d_y;
% 
% 
% point_real_ppp = [ppp_real_x ppp_real_y ppp_real_z];
% D_real_a2ppp = norm(point_real_a - point_real_ppp,'fro');
% 
% display(D_real_a2ppp);

%AP_O=[600 0 0]';                                %计算AP变到摄像机坐标系下的长度
%AP_C=rotate_Matrix*AP_O;
%D_real_AP=norm(AP_C,'fro');

point_A1=[424,497];                             
point_P1=[592,275];
%D_A12P1 = norm(point_A1-point_P1,'fro');
%D_real_A12P1=D_A12P1*rate;

[point_real_a1_x,point_real_a1_y] = pixel2space(424,497);         %确定A'点的三维坐标
point_real_a1 = [point_real_a1_x point_real_a1_y D_Real_focus];
[point_real_p1_x,point_real_p1_y] = pixel2space(592,275);         %确定P'点的三维坐标
point_real_p1 = [point_real_p1_x point_real_p1_y D_Real_focus];
point_real_o=[0 0 0];                                             %O点的三维坐标
%D_real_OA1=norm(point_real_a,'fro');

%计算P''点的三维坐标
point_real_p11_y=point_real_p1_y*(u1(2)*point_real_a1_x-u1(1)*point_real_a1_y)/(u1(2)*point_real_p1_x-u1(1)*point_real_p1_y);
point_real_p11_x=point_real_p1_x*point_real_p11_y/point_real_p1_y;
point_real_p11_z=D_Real_focus*point_real_p11_y/point_real_p1_y;
point_real_p11=[point_real_p11_x point_real_p11_y point_real_p11_z];

%计算A'P''与OA'的长度,同时表示出AP的长度
D_real_O2A1=norm(point_real_a1,'fro');   %OA'
D_real_A12P11=norm(point_real_a1-point_real_p11,'fro'); %A'P''
D_real_AP=600;

%计算OA的长度
D_real_OA=D_real_O2A1*D_real_AP/D_real_A12P11;       %OA的模长
a=point_real_a1/D_real_O2A1;                 %OA方向单位向量

%计算OA向量
vector_OA=D_real_OA*a;

translation_Vector=inv(rotate_Matrix)*(vector_OA)';
display(translation_Vector);