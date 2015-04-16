% get the range of the L3 when link L1,L2 change
clear;close all;clc


% Position of base triangle
A=[5,0,0]';
B=[5*cosd(120),5*sind(120),0]';
C=[5*cosd(240),5*sind(240),0]';
O=[0,0,0];

xa=A(1);ya=A(2);za=A(3);
xb=B(1);yb=B(2);zb=B(3);
xc=C(1);yc=C(2);zc=C(3);



% set link motion
l1=10;
l2=0:0.05:20;
% l3_range=5:0.05:10;
l0=15/sqrt(3);



l3=((yc - ((xa - xb)*l0.^2 + xb*l1.^2 - xa*l2.^2)/(2*xa*yb - 2*xb*ya)).^2 + (xc + ((ya - yb)*l0.^2 + yb*l1.^2 - ya*l2.^2)/(2*xa*yb - 2*xb*ya)).^2 - ((xa - xb).*l0.^2 + xb.*l1.^2 - xa.*l2.^2).^2/(2*xa*yb - 2*xb*ya).^2 - ((ya - yb).*l0.^2 + yb.*l1.^2 - ya.*l2.^2).^2/(2*xa*yb - 2*xb*ya).^2 + l0.^2).^(1/2);

plot(l2,l3)
% 


