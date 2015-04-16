% get the range of the end-factor when link L1,L2,L3 changes
clear;close all;clc
hold on


% Position of base triangle
A=[5,0,0]';
B=[5*cosd(120),5*sind(120),0]';
C=[5*cosd(240),5*sind(240),0]';







xa=A(1);ya=A(2);za=A(3);
xb=B(1);yb=B(2);zb=B(3);
xc=C(1);yc=C(2);zc=C(3);


% draw the base triangle
surf([xa,xa;xb,xc],[ya,ya;yb,yc],zeros(2,2),5)
text(xa,ya,za,'A')
text(xb,yb,zb,'B')
text(xc,yc,zc,'C')



% set link motion
l1_range=10;
l2_range=5:0.05:10;
l3_range=5:0.05:10;




tic
r=0;
for i=1:length(l1_range)
    l1=l1_range(i);
    for j=1:length(l2_range)
        l2=l2_range(j);
        
        for k=1:length(l3_range)
        l3=l3_range(k);
        
            O1=fun_FK(A,B,C,l1,l2,l3);
            if(isreal(O1))
                r=r+1;
                L(r,:)=[l1,l2,l3];
                O(r,:)=O1;
            end
        end
    end
end
toc

Color_Set=linspace(1,10,r);



scatter3(O(:,1),O(:,2),O(:,3),[],Color_Set)




grid on



xlabel('x')
ylabel('y')
zlabel('z')

Line1=[A';O1;B'];
Line2=[C';O1];

line(Line1(:,1),Line1(:,2),Line1(:,3),'LineWidth',2,'Color',[0,0,0])
line(Line2(:,1),Line2(:,2),Line2(:,3),'LineWidth',2,'Color',[0,0,0])
text(O1(1),O1(2),O1(3),'O_2')





