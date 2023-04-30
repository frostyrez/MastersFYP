m = 1;
Ixx = 0.01;
Iyy = Ixx;
Izz = 0.02;
g = 9.81;

% quadcopter states: x y z x' y' z' phi theta psi phi' theta' psi'
A = zeros(12);
A(1,4)=1; A(2,5)=1; A(3,6)=1; A(4,8)=-g; A(5,7)=g; A(7,10)=1; A(8,11)=1; A(9,12)=1;

B = zeros(12,4);
B(6,1)=1/m; B(10,2)=1/Ixx; B(11,3)=1/Iyy; B(12,4)=1/Izz;

C = zeros(6,12);
C(1,1)=1; C(2,2)=1; C(3,3)=1; %C(4,7)=1; C(5,8)=1; C(6,9)=1;

Q = eye(12); % Penalize positions and velocities
R = .1; % Penalize effort

K = lqr(A,B,Q,R);

% Old states
% A = zeros(12);
% A(1,4)=1; A(2,5)=1; A(3,6)=1; A(4,8)=-g; A(5,7)=g; A(7,10)=1; A(8,11)=1; A(9,12)=1;
% 
% B = zeros(12,4);
% B(6,1)=1/m; B(10,2)=1/Ixx; B(11,3)=1/Iyy; B(12,4)=1/Izz;
% 
% C = zeros(6,12);
% C(1,1)=1; C(2,2)=1; C(3,3)=1; C(4,7)=1; C(5,8)=1; C(6,9)=1;
% 
% Q = eye(12); % Penalize positions and velocities
% R = .1; % Penalize effort
% 
% K = lqr(A,B,Q,R);
%G = -inv(C*inv(A-B*K)*B); % Feedforward gain