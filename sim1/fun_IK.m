function [l1,l2,l3]=fun_IK(A,B,C,O)

xa=A(1);ya=A(2);
xb=B(1);yb=B(2);
xc=C(1);yc=C(2);
xo=O(1);yo=O(2);zo=O(3);


l1=sqrt((xo-xa)^2+(yo-ya)^2+zo^2);
l2=sqrt((xo-xb)^2+(yo-yb)^2+zo^2);
l3=sqrt((xo-xc)^2+(yo-yc)^2+zo^2);


end