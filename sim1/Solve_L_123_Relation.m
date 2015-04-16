clear;close all;clc

% ?????,O1?????L0 ???

syms l0 l1 l2 l3 xo yo zo xa ya za xb yb zb xc yc zc
% 
% A=[4,-5,0];
% B=[3,4,0];
% C=[0,4,0];
O1=[0,0,0];
% O=[6,3,8];

% xa=A(1);ya=A(2);za=A(3);
% xb=B(1);yb=B(2);zb=B(3);
% xc=C(1);yc=C(2);zc=C(3);
% xo=O(1);yo=O(2);zo=O(3);

% l1=norm(O-A);
% l2=norm(O-B);
% l3=norm(O-C);

A=[xa,ya,za];
B=[xb,yb,zb];
C=[xc,yc,zc];



% [ O2 ] = fun_FK( A,B,O1,l1,l2,l0 );

[ O2 ] = fun_FK( O1,A,B,l0,l1,l2 );

[~,~,l3]=fun_IK(A,B,C,O2);

