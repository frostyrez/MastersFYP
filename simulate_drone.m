%NL
% center = out.yout{3}.Values.Data;
% rotor = load_drone_pos(center,out.yout{4}.Values.Data); %t, xyz, n
% time = out.yout{3}.Values.Time;
%L
% [time,data] = simplify_drone(out.xyz{1}.Values.Time,...
%     [out.xyz{1}.Values.Data out.euler{1}.Values.Data],.05);
% center = data(:,1:3);%out.xyz{2}.Values.Data;
% euler = data(:,4:6);

close all
clear xcyl ycyl zcyl drone center euler combinedobject

center = out.xyz{2}.Values.Data;
euler = out.euler{1}.Values.Data;
%optctr = out.optctr{1}.Values.Data;
%%% TIME %%%
time = 0:0.025:10;

%% Define Figure plot
fig1 = figure('pos', [0 50 800 600]);
hg   = gca;
view(45,35) %view(37.5,30);
grid on;
%%% AXIS %%%
axis([-1 2 -1 2 -1 2])
xlabel('X[m]');
ylabel('Y[m]');
zlabel('Z[m]');
hold(gca, 'on');

%% Design Different parts
flag = [0 0 0 0];
% Get cylinder coordinates
arm = .2;
% Circle centers
C = zeros(4,3);
C(1,:) = [arm -arm 0];
C(2,:) = [arm arm 0];
    C(3,:) = [-arm arm 0];
C(4,:) = [-arm -arm 0];

R = 0.12;
rads = 0:.1:2*pi;
for i = 1:4
    xcyl(i,:) = C(i,1) + R*cos(rads);
    ycyl(i,:) = C(i,2) + R*sin(rads);
    zcyl(i,:) = C(i,3) + zeros(size(xcyl(i,:)));
    drone(i) = patch(xcyl(i,:),ycyl(i,:),zcyl(i,:));
    if i == 1 || i == 3
        drone(i).FaceColor = 'cyan';
    else
        drone(i).FaceColor = [1 .2 1];
    end
end
alpha(drone,0.7);

cross1 = plot3([arm -arm],[-arm arm],[0 0],'bx--');
cross2 = plot3([arm -arm],[arm -arm],[0 0],'bx--');
groundref = plot3([0 0],[0 0],[-1 0],'kx--','MarkerSize',12);
%sideref = plot3([-3 0],[0 0],[0 0],'kx--','MarkerSize',12);
%%% GOAL %%%
start = plot3(0,0,-3,'rs','MarkerSize',15);
goal = plot3(1,1,1,'p','MarkerSize',15,'Color',[0 .9 0]);

combinedobject = hgtransform('parent',hg);
set(drone,'parent',combinedobject)
text = annotation('textbox',[.35 .75 .13 .05],'String','','FitBoxToText','on');
%text_opt = annotation('textbox',[.55 .75 .11 .05],'String','','FitBoxToText','on');

for i = 1:length(center)
    translation = makehgtform('translate',...
        center(i,:));%[x(i) y(i) z(i)]);
    rotation1 = makehgtform('xrotate',-euler(i,1));
    rotation2 = makehgtform('yrotate',-euler(i,2));
    rotation3 = makehgtform('zrotate',0);
    if mod(i,5) == 0
%         if i == 100
%             flag = 1;
%         end
    end
    set(combinedobject,'matrix',...
        translation*rotation3*rotation2*rotation1);

    %axis([center(i,1)-3 center(i,1)+3 center(i,2)-3 center(i,2)+3 center(i,3)-3 center(i,3)+3])

    if time(i) >= 11
        if flag(1) == 0
            drone(1).FaceColor = 'red';
            alpha(drone(1),1)
            pause(.5)
            alpha(drone(1),0)
            flag(1) = 1;
        elseif time(i) >= 21
            if flag(2) == 0
                drone(3).FaceColor = 'red';
                alpha(drone(3),1)
                pause(.5)
                alpha(drone(3),0)
                flag(2) = 1;
            end
        end
    end

%     if i > 1
%         if optctr(i) ~= optctr(i-1)
%             set(text_opt,'String','')
%             pause(.5)
%         end
%     end

    cross1.XData = [arm -arm] + center(i,1);
    cross1.YData = [-arm arm] + center(i,2);
    cross1.ZData = [0 0] + center(i,3);
    cross2.XData = [arm -arm] + center(i,1);
    cross2.YData = [arm -arm] + center(i,2);
    cross2.ZData = [0 0] + center(i,3);
    groundref.XData(:) = center(i,1);
    groundref.YData(:) = center(i,2);
    %groundref.ZData(1) = center(i,3) - 3;
    groundref.ZData(2) = center(i,3);
%     sideref.XData(1) = center(i,1) - 3;
%     sideref.XData(2) = center(i,1);
%     sideref.YData(:) = center(i,2);
%     sideref.ZData(:) = center(i,3);
    %start.ZData = center(i,3)-3;
    set(text,'String',['Time = ',num2str(round(time(i),2)),' s'])
    %set(text_opt,'String',['Act CTR = ',num2str(optctr(i))])
    drawnow
end
