%function out1 = ODE_quad(t,u,v,w,p,q,r,x,y,z,phi,theta,psi,dalpha1,dalpha2,dalpha3,dalpha4,M1,M2,M3,M4,T1,T2,T3,T4,H1,H2,H3,H4,Y1,Y2,Y3,Y4,Q1,Q2,Q3,Q4,Mx1,Mx2,Mx3,Mx4,My1,My2,My3,My4,XB,YB,ZB,LB,MB,NB,mb,mr,Ibbxx,Ibbyy,Ibbzz,Ibbxz,Ibbperp,Irrpolar,Irrperp,R_arms,z_rotors,g)
function x_out = nlStateFcn(x_in,u_in)

% States x = [u v w p q r x y z phi theta psi dalpha1 dalpha2 dalpha3 dalpha4]
%             1 2 3 4 5 6 7 8 9 10   11   12     13     14      15       16  
% Inputs u = [u1 u2 u3 u4]

%% Parameters
mb          = 0.793;    % mass of body
mr          = 0.0625;   % mass of each proprotor + motor rotor (https://robu.in/product/10x4-5-sf-props-black-cw-2pc/ 10"*4.5")
m_tot = mb+4*mr; mb = mb/m_tot; mr = mr/m_tot; % fudge to get 1 kg trim point
Irrzz       = .0002226; % Irrpolar, Izz for rotor (about shaft) disc: 1/2 MR^2
Irrperp     = Irrzz/2; % Ixx/Iyy for single rotor (assumes symmetric disc)
Ibbperp     = .00942;   % =Ixx=Iyy (for aircraft with 90 deg symmetry)
Ibbxx       = Ibbperp;  % moment of inertia about body x axis
Ibbyy       = Ibbperp;  % moment of inertia about body y axis
Ibbzz       = .01867;   % moment of inertia about body z axis
Ibbxz       = 0;        % product of inertia in XZ plane (not currently used)
R_arms      = .45/2;    % horizontal arm length from rotor shaft to centre (DJI F450)
R_rotor     = .125;
z_rotors    = 0;        % not currently used
g           = 9.81;     % gravity constant
rho         = 1.225;    % air density
CDbody      = .75;
Abody       = .0314;
rotorAero = load('loopQuadBET_fromTheBook.mat','C_T','C_H','C_M','C_Q','mu_z_loops','mu_x_loops');
% rotorAerov2 = load('loadBookV2.mat');

Kv = 130;
Rw = 0.56;
i0 = 0;
LB = 0; MB = 0; NB = 0; % Body Torques are zero

u_in = u_in + 5.87;

if x_in(13) < 1
    x_in(13:end) = 459.3;
end

u = x_in(1);
v = x_in(2);
w = x_in(3);
p = x_in(4);
q = x_in(5);
r = x_in(6);
phi = x_in(10);
theta = x_in(11);
psi = x_in(12);
dalpha1 = x_in(13);
dalpha2 = x_in(14);
dalpha3 = x_in(15);
dalpha4 = x_in(16);

%% Motors
M = zeros(4,1); % Torque
for i = 1:4
    M(i) =( (u_in(i) - x_in(12+i)/Kv)/Rw - i0)/Kv;
    if M(i) < 0 % Assume ESC can't break
        M(i) = 0;
    end
end

%% Body Aerodynamics
% Assuming no wind disturbance
if any(x_in(1:3))
    x_in(1:3) = -x_in(1:3);
    temp = x_in(1:3)*x_in(1:3)';
    temp = temp * 1/2*rho*Abody*CDbody;
    B = temp * normalize(x_in(1:3),'norm');
    x_in(1:3) = -x_in(1:3);
else
    B = [0 0 0];
end

%% Rotor Aerodynamics
vB = x_in(1:3);
omega = x_in(13:16);
R_BR = eye(3);
spin_dir = [1,-1,1,-1];
vT = zeros(1,4);
mu = zeros(4,3);
C_T = zeros(1,4); C_H=C_T; C_Q=C_T; C_M=C_T;
H = zeros(4,1); Y = H; T = H; Mx = H; My = H; Q = H;

for i = 1:4
    % toXZplanesubfunction
    vR = -R_BR.'*vB(:);
    if vR(1)==0 && vR(2)==0 % wind is zero or aligned with Z axis
        R_RW = eye(3);
    else
        h = (vR(1)^2 + vR(2)^2)^0.5; % size of vR projected on XY plane (NB this is mu_x component)
        %a = atan2(vW(2),vW(1))
        c = vR(1)/h; %cos(a);
        s = vR(2)/h; %sin(a);
        R_RW = [ c -s 0 ; s c 0 ; 0 0 1];
    end
    vW = R_RW.' * vR;
    % Moving on
    vT(i) = omega(i)*R_rotor;
    mu(i,:) = (vW/vT(i)) .* [-1;0;1];
    C_T(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_T,mu(i,end),mu(i,1));
    C_H(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_H,mu(i,end),mu(i,1));
    C_Q(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_Q,mu(i,end),mu(i,1));
    C_M(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_M,mu(i,end),mu(i,1));

%     [~,ix] = min(abs(rotorAerov2.mu_x - mu(i,1)));
%     [~,iz] = min(abs(rotorAerov2.mu_z - mu(i,end)));
%     C_T(i) = rotorAerov2.C_Tv2(ix,iz);
%     C_H(i) = rotorAerov2.C_Hv2(ix,iz);
%     C_Q(i) = rotorAerov2.C_Qv2(ix,iz);
%     C_M(i) = rotorAerov2.C_Mv2(ix,iz);

    C_Q(i) = R_rotor*C_Q(i);
    C_M(i) = R_rotor*C_M(i)*spin_dir(i);

    temp = [C_T(i); C_H(i); C_Q(i); C_M(i)] * vT(i)^2 * 1/2*rho*(R_rotor^2*pi);
    FW = [0 -1 0 0 ; 0 0 0 0 ; -1 0 0 0] * temp;
    MW = [0 0 0 -1 ; 0 0 0 0 ; 0 0 1 0] * temp;
    top = R_RW * FW;
    bot = R_RW * MW;

    H(i) = -top(1);
    Y(i) = top(2);
    T(i) = -top(3);
    Mx(i) = bot(1);
    My(i) = bot(2);
    Q(i) = bot(3);

end


%% Final ODE_quad

t2 = cos(phi);
t3 = cos(psi);
t4 = cos(theta);
t5 = sin(phi);
t6 = sin(psi);
t7 = sin(theta);
t8 = Irrperp.*4.0;
t9 = R_arms.^2;
t10 = mr.*4.0;
t11 = 1.0./Irrzz;
t12 = -Q(1);
t13 = -Q(2);
t14 = -Q(3);
t15 = -Q(4);
t17 = sqrt(2.0);
t16 = 1.0./t4;
t18 = mb+t10;
t19 = M(1)+t12;
t20 = M(2)+t13;
t21 = M(3)+t14;
t22 = M(4)+t15;
t23 = mr.*t9.*2.0;
t24 = t9.*t10;
t35 = (H(1).*R_arms.*t17)./2.0;
t36 = (H(2).*R_arms.*t17)./2.0;
t37 = (H(3).*R_arms.*t17)./2.0;
t38 = (H(4).*R_arms.*t17)./2.0;
t39 = (R_arms.*T(1).*t17)./2.0;
t40 = (R_arms.*T(2).*t17)./2.0;
t41 = (R_arms.*T(3).*t17)./2.0;
t42 = (R_arms.*T(4).*t17)./2.0;
t43 = (R_arms.*Y(1).*t17)./2.0;
t44 = (R_arms.*Y(2).*t17)./2.0;
t45 = (R_arms.*Y(3).*t17)./2.0;
t46 = (R_arms.*Y(4).*t17)./2.0;
t25 = Irrzz.*t19;
t26 = Irrzz.*t20;
t27 = Irrzz.*t21;
t28 = Irrzz.*t22;
t29 = Ibbzz+t24;
t30 = 1.0./t18;
t48 = Ibbperp+t8+t23;
t49 = -t36;
t50 = -t37;
t51 = -t42;
t52 = -t45;
t53 = -t46;
t31 = -t25;
t32 = -t26;
t33 = -t27;
t34 = -t28;
t47 = 1.0./t29;
t54 = 1.0./t48;
t55 = NB+Q(2)+Q(4)+t12+t14+t35+t38+t43+t44+t49+t50+t52+t53;
t56 = Irrzz.*t55;
t57 = -t56;
x_out = [-q.*w+r.*v-t30.*(H(1)+H(2)+H(3)+H(4)-B(1)+g.*t7.*t18);...
    t30.*(Y(1)+Y(2)+Y(3)+Y(4)+B(2)+g.*t4.*t5.*t18)+p.*w-r.*u;...
    -p.*v+q.*u-t30.*(T(1)+T(2)+T(3)+T(4)-B(3)-g.*t2.*t4.*t18);...
    t54.*(LB+Mx(1)+Mx(2)+Mx(3)+Mx(4)-t39+t40+t41+t51-Irrzz.*dalpha1.*q+Irrzz.*dalpha2.*q-Irrzz.*dalpha3.*q+Irrzz.*dalpha4.*q-Ibbzz.*q.*r+Ibbperp.*q.*r-Irrzz.*q.*r.*4.0+q.*r.*t8-mr.*q.*r.*t9.*2.0);...
    t54.*(MB+My(1)+My(2)+My(3)+My(4)+t39+t40-t41+t51+Irrzz.*dalpha1.*p-Irrzz.*dalpha2.*p+Irrzz.*dalpha3.*p-Irrzz.*dalpha4.*p+Ibbzz.*p.*r-Ibbperp.*p.*r-Irrperp.*p.*r.*4.0+Irrzz.*p.*r.*4.0+p.*r.*t23);...
    t47.*(-M(1)+M(2)-M(3)+M(4)+NB+t35+t38+t43+t44+t49+t50+t52+t53);...
    t3.*t4.*u-t2.*t6.*v+t5.*t6.*w+t3.*t5.*t7.*v+t2.*t3.*t7.*w;...
    t4.*t6.*u+t2.*t3.*v-t3.*t5.*w+t5.*t6.*t7.*v+t2.*t6.*t7.*w;...
    -t7.*u+t4.*t5.*v+t2.*t4.*w;...
    t16.*(p.*t4+q.*t5.*t7+r.*t2.*t7);...
    q.*t2-r.*t5;...
    t16.*(q.*t5+r.*t2);...
    t11.*t47.*(t25+t27+t32+t34+t57+Ibbzz.*t19+t19.*t24);...
    t11.*t47.*(t26+t28+t31+t33+t56+Ibbzz.*t20+t20.*t24);...
    t11.*t47.*(t25+t27+t32+t34+t57+Ibbzz.*t21+t21.*t24);...
    t11.*t47.*(t26+t28+t31+t33+t56+Ibbzz.*t22+t22.*t24)];


end