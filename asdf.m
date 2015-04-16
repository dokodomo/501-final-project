clc
clear all
close all

l1range = 0:0.1:2;
l2range = 0:0.1:2;
%% Defining parameters
l0=1;             % L0-from the base of the frame to the tip
l10=l0/cosd(30);  % L1- when the L1=L2=L3
l20=l10;          % L2- when the L1=L2=L3
a=l10*sind(30);   % the distance from the base of the actuator to base of L0
%%
r=0;
for i=1:length(l1range)
    l1 = l1range(i);
    for j=1:length(l2range)
        l2=l2range(j);
        
        x=(l0^2+a^2-l1^2)/(2*a);        
        y=(-l2^2+l0^2+a^2+2*a*cosd(60)*x)/(2*a*sind(60));
        z=abs((l0^2-x^2-y^2)^0.5);

        q=abs((x^2+y^2+z^2)^0.5);
        
        if q < 1.01
            L1=line([a x],[0 y],[0 z],'Color',[0 1 0],'LineWidth', 3);
            L2=line([-a*cosd(60) x],[a*sind(60) y],[0 z],'Color',[1 0 0],'LineWidth', 3);
            L3=line([-a*cosd(60) x],[-a*sind(60) y],[0 z],'LineWidth', 3);
            L4=line([0 x],[0 y],[0 z]);
        end
    end
end
%% Plotting the base of the parallel manipulator
line([a -a*cosd(60) -a*cosd(60) a],[0 -a*sind(60) a*sind(60) 0],[0 0 0 0],...
    'Color',[0 0 1], 'LineWidth', 2);
        
xlabel('X0');
ylabel('Y0');
zlabel('Z0');
grid
axis vis3d


