tic
Duration = 10;
Ts = .1;
%p = 50;
%c = 10;

MVs = out.lqr_motor_data{1}.Values.Data;
MVs = test_fcn_2(MVs);
% MVs = zeros(Duration/Ts,4);
% MVs(1:10,:) = 8;
% MVs(11:20,:) = -6;
% MVs(21:30,:) = 8;
% MVs(31:40,:) = -6;

xHistory = zeros(1,16); intHistory = xHistory; xHistory(1,13:16) = 459.3008;
uHistory = MVs(1,:);
%yref = zeros(p,16); yref(:,9) = 1; yref(:,13:16) = 459.3;
for k = 1:(Duration/Ts)
    %tic
    % Set references for previewing
    %t = linspace(k*Ts, (k+p-1)*Ts,p);
    % Compute the control moves with reference previewing.
    xk = xHistory(k,:);
    uk = MVs(k,:);
    uHistory(k+1,:) = uk';
    % Update states.
    intHistory(k+1,:) = nlStateFcn(xk,uk);
    ODEFUN = @(t,xk) nlStateFcn(xk,uk);
    [TOUT,YOUT] = ode45(ODEFUN,[0 Ts], xHistory(k,:)');
    xHistory(k+1,:) = YOUT(end,:);
    if any(isnan(YOUT))
        flag = 1;
    end
    %disp([num2str(k) ' ' num2str(toc)])
    %waitbar(k*Ts/Duration,hbar);
end
toc

% figure(1)
% hold on
% grid on
% plot(0:Ts:Duration,xHistory(:,7),'r')
% plot(0:Ts:Duration,xHistory(:,8),'g')
% plot(0:Ts:Duration,xHistory(:,9),'b')
% legend('Z')
% xlabel('Time (s)')
% ylabel('Displacement (m)')
% hold off
% 
% figure(2)
% hold on
% grid on
% plot(0:Ts:Duration,uHistory(:,1))
% plot(0:Ts:Duration,uHistory(:,2))
% plot(0:Ts:Duration,uHistory(:,3))
% plot(0:Ts:Duration,uHistory(:,4))
% legend('U1','U2','U3','U4')
% xlabel('Time (s)')
% ylabel('Voltage Input')
% hold off