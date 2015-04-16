function [ O ] = fun_FK( A,B,C,l1,l2,l3 )

% forward kinematics for 3 DOF parallel manipulator. 
% Base frame lays on the center of circumcircle of the triangle


xa=A(1);ya=A(2);
xb=B(1);yb=B(2);
xc=C(1);yc=C(2);

x2=-(l1^2*(yb-yc)+l2^2*(yc-ya)+l3^2*(ya-yb))/(2*(xa*(yb-yc)+xb*(yc-ya)+xc*(ya-yb)));
y2=-(l1^2*(xb-xc)+l2^2*(xc-xa)+l3^2*(xa-xb))/(2*(ya*(xb-xc)+yb*(xc-xa)+yc*(xa-xb)));
z2=sqrt(l1^2-(x2-xa)^2-(y2-ya)^2);

O=[x2,y2,z2];

end

