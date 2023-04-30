% Initialise
time = out.simout.Time;
y = out.simout.Data(:,1);
actuator = out.simout.Data(:,2);

% Look for settling
i = 1;
while time(i) < .01 % Start searching from reasonable point
    i = i+1;
end % Initial time value found

tol = 1e-4;
while abs(y(i+1)-y(i)) > tol % Begin convergence search at this point
    i = i+1;
end

settletime = time(i)
effort = sum(abs(actuator))

% Draw
% figure(1)
% hold off
% text = annotation('textbox',[.2 .6 .8 .2],'String','','FitBoxToText','on');
% for t = 1:length(time)
%     plot(time(i),y(i),'o','MarkerSize',12)
%     set(text,'String',['Time = ',num2str(settletime),' Effort = ',num2str(effort)])
%     %axis([-3 7 min(data(:,1))-3 max(data(:,3))+3])%-1 a+b+1 2*min(data(:,4)) 2*max(data(:,2))])
%     %grid on    
%     pause(.1) % Estimation of real time display
% end
