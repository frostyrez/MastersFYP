%% Motion
x = out.xyz{2}.Values.Data(:,1);
y = out.xyz{2}.Values.Data(:,2);
z = out.xyz{2}.Values.Data(:,3);
roll = out.euler{1}.Values.Data(:,1);
pitch = out.euler{1}.Values.Data(:,2);
yaw = out.euler{1}.Values.Data(:,3);

%% Define design parameters
D2R = pi/180;
b   = 0.6;   % the length of total square cover by whole body of quadcopter in meter
a   = b/3;   % the legth of small square base of quadcopter(b/4)
H   = 0.06;  % hight of drone in Z direction (4cm)
H_m = H+H/2; % hight of motor in z direction (5 cm)
r_p = b/4;   % radius of propeller
%% Conversions
ro = 45*D2R;                   % angle by which rotate the base of quadcopter
Ri = [cos(ro) -sin(ro) 0;
      sin(ro) cos(ro)  0;
       0       0       1];     % rotation matrix to rotate the coordinates of base 
base_co = [-a/2  a/2 a/2 -a/2; % Coordinates of Base 
           -a/2 -a/2 a/2 a/2;
             0    0   0   0];
base = Ri*base_co;             % rotate base Coordinates by 45 degree 

to = linspace(0, 2*pi);
xp = r_p*cos(to);
yp = r_p*sin(to);
zp = zeros(1,length(to));
%% Define Figure plot
 fig1 = figure('pos', [0 50 800 600]);
 hg   = gca;
 view(-37.5,30);
 grid on;
%  axis equal;
%  xlim([-1.5 1.5]); ylim([-1.5 1.5]); zlim([0 3.5]);
 axis([-1 3 -1 3 -1 3]) 
 %title('(JITENDRA) Drone Animation')
 xlabel('X[m]');
 ylabel('Y[m]');
 zlabel('Z[m]');
 hold(gca, 'on');
 
%% Design Different parts
% design the base square
 drone(1) = patch([base(1,:)],[base(2,:)],[base(3,:)],'r');
 drone(2) = patch([base(1,:)],[base(2,:)],[base(3,:)+H],'r');
 alpha(drone(1:2),0.7);
% design 2 parpendiculer legs of quadcopter 
 [xcylinder,ycylinder,zcylinder] = cylinder([H/2 H/2]);
 drone(3) =  surface(b*zcylinder-b/2,ycylinder,xcylinder+H/2,'facecolor','b');
 drone(4) =  surface(ycylinder,b*zcylinder-b/2,xcylinder+H/2,'facecolor','b') ; 
 alpha(drone(3:4),0.6);
% design 4 cylindrical motors 
 drone(5) = surface(xcylinder+b/2,ycylinder,H_m*zcylinder+H/2,'facecolor','r');
 drone(6) = surface(xcylinder-b/2,ycylinder,H_m*zcylinder+H/2,'facecolor','r');
 drone(7) = surface(xcylinder,ycylinder+b/2,H_m*zcylinder+H/2,'facecolor','r');
 drone(8) = surface(xcylinder,ycylinder-b/2,H_m*zcylinder+H/2,'facecolor','r');
 alpha(drone(5:8),0.7);
% design 4 propellers
 drone(9)  = patch(xp+b/2,yp,zp+(H_m+H/2),'c','LineWidth',0.5);
 drone(10) = patch(xp-b/2,yp,zp+(H_m+H/2),'c','LineWidth',0.5);
 drone(11) = patch(xp,yp+b/2,zp+(H_m+H/2),'p','LineWidth',0.5);
 drone(12) = patch(xp,yp-b/2,zp+(H_m+H/2),'p','LineWidth',0.5);
 alpha(drone(9:12),0.3);

%% create a group object and parent surface
  combinedobject = hgtransform('parent',hg );
  set(drone,'parent',combinedobject)
  text = annotation('textbox',[.3 .6 .8 .2],'String','','FitBoxToText','on');
  time = 0:0.01:5;
  groundref = plot3([0 0],[0 0],[-1 0],'kx--','MarkerSize',12);

 for i = 1:350
  
     %ba = plot3(x(1:i),y(1:i),z(1:i), 'b:','LineWidth',1.5);
     groundref.XData(:) = x(i);
     groundref.YData(:) = y(i);
     groundref.ZData = [-1 z(i)];
   
     translation = makehgtform('translate',...
                               [x(i) y(i) z(i)]);
     rotation1 = makehgtform('xrotate',(pi/180)*(roll(i)));
     rotation2 = makehgtform('yrotate',(pi/180)*(pitch(i)));
     rotation3 = makehgtform('zrotate',yaw(i));
     set(combinedobject,'matrix',...
          translation*rotation3*rotation2*rotation1);
      
      %movieVector(i) =  getframe(fig1);
        %delete(b);
     drawnow
     set(text,'String',['Time = ',num2str(round(time(i),2)),' s'])
     %pause(0.05);
 end

 
