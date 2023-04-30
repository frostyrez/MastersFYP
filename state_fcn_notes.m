
t16.*(p.*t4+q.*t5.*t7+r.*t2.*t7); %10
(p.*t4 + q*sin(phi)*t7 + r.*t2.*t7) / cos(theta);

q.*t2-r.*t5; %11
q*cos(phi) - r*sin(phi)

t16.*(q.*t5+r.*t2); %12
(q*sin(phi) + r*cos(phi)) / cos(theta) % good

%% To find out: Forces
-(H1+H2+H3+H4-XB + g.*sin(theta)*masses %1

(Y1+Y2+Y3+Y4+YB + g*cos(theta)*sin(phi)*masses) %2

-(T1+T2+T3+T4-ZB - g*cos(phi)*cos(theta)*masses) %3

%% To find out: Angular Torques

-M1+M2-M3+M4+NB+t35+t38+t43+t44+t49+t50+t52+t53 %6
