% lqr_time = out.xyz{1}.Values.Time; % Time
% yref = out.xyz{2}.Values.Data(:,1);
% lqr_data = out.xyz{1}.Values.Data;

%x = out.mpc_motor{1}.Values.Time; % Time
%y = out.mpc_motor{1}.Values.Data; % Data



figure(1)
hold on
grid on
% for i = 1:4
%     figure(i)
%     hold on
%     grid on
%     plot(lqr_time,lqr_data(:,i),'b')
%     plot(mpc_time,mpc_data(:,i),'r')
%     legend('LQR','MPC')
%     xlabel('Time (s)')
%     ylabel('Voltage (V)')
%     axis([0 10 -8 10])
% end
% %plot(lqr_time,yref,'k--')
plot(out.xyz{2}.Values.Time,out.xyz{2}.Values.Data(:,3),'--k')
plot(out.xyz{1}.Values.Time,out.xyz{1}.Values.Data(:,3))
%plot([11 11],[0 40],'r-.',[21 21],[0 40],'r-.')
%plot(mpc_time,mpc_data,'r')
% %plot([0 10],[-6.176 -6.176],'k--',[0 10],[8.624 8.624],'k--')
%legend('Reference','Z Position','Rotor Failure','location','northwest')
% % p1 = plot(x,y(:,1),'-','Color',[1 0 0]);
% % p2 = plot(x,y(:,2),'-','Color',[.8 0 0]);
% % p3 = plot(x,y(:,3),'-','Color',[.6 0 0]);
xlabel('Time (s)')
ylabel('Displacement (m)')
% %legend ([p4 p5 p6],'Rotor 1','Rotor 2 and 4','Rotor 3')
%hold off
%axis([0 30 0 40])

% figure(1)
% hold on
% grid on
% plot(0:.2:10,xHistory_02(:,9))
% plot(0:.1:10,xHistory_01(:,9))
% plot(0:.05:10,xHistory_005(:,9))
% plot(0:.01:10,xHistory_001(:,9))
% plot(0:.1:10,ref,'k--')
% legend('0.2s','0.1s','0.05s','0.01s','Ref (0.1s)','Location','best')
% xlabel('Time (s)')
% ylabel('Displacement (m)')
% axis([0 10 0 1.8])