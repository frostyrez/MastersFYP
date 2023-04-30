clf
%NL
% center = out.yout{3}.Values.Data;
% rotor = load_drone_pos(center,out.yout{4}.Values.Data); %t, xyz, n
% time = out.yout{3}.Values.Time;
%L
% [time,data] = simplify_drone(out.xyz{1}.Values.Time,...
%     [out.xyz{1}.Values.Data out.euler{1}.Values.Data],.05);
% center = data(:,1:3);%out.xyz{2}.Values.Data;
% euler = data(:,4:6);
center = out.xyz{2}.Values.Data;
euler = out.euler{1}.Values.Data;
rotor = load_drone_pos(center,euler); %t, xyz, n
time = 0:0.05:5;

p = plot3(squeeze(rotor(1,1,:)),squeeze(rotor(1,2,:)),...
    squeeze(rotor(1,3,:)),'o','MarkerSize',8);
figure(1)
axis([-1 3 -1 3 -1 3])
grid on
hold on
xlabel('X')
ylabel('Y')
zlabel('Z')
cross1 = plot3([rotor(1,1,1) rotor(1,1,3)],... % Line from 1 to 3
    [rotor(1,2,1) rotor(1,2,3)],...
    [rotor(1,3,1) rotor(1,3,3)],'--b');
cross2 = plot3([rotor(1,1,2) rotor(1,1,4)],... % Line from 2 to 4
    [rotor(1,2,2) rotor(1,2,4)],...
    [rotor(1,3,2) rotor(1,3,4)],'--b');
groundref = plot3([center(1,1) center(1,1)],[center(1,2) center(1,2)],...
    [center(1,3) -1],'kx--');

text = annotation('textbox',[.2 .6 .8 .2],'String','','FitBoxToText','on');

for i = 1:length(time) % Update plot heres what i think
        p.XData = squeeze(rotor(i,1,:));
        p.YData = squeeze(rotor(i,2,:));
        p.ZData = squeeze(rotor(i,3,:));
        %p.Color = [.1*i 1-.1*i 0];
        cross1.XData = [rotor(i,1,1) rotor(i,1,3)];
        cross1.YData = [rotor(i,2,1) rotor(i,2,3)];
        cross1.ZData = [rotor(i,3,1) rotor(i,3,3)];
        cross2.XData = [rotor(i,1,2) rotor(i,1,4)];
        cross2.YData = [rotor(i,2,2) rotor(i,2,4)];
        cross2.ZData = [rotor(i,3,2) rotor(i,3,4)];
        groundref.XData = center(i,1);
        groundref.YData = center(i,2);
        set(text,'String',['Time = ',num2str(round(time(i),2)),' s'])
        %pause(.05)
 end