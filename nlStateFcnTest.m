function dxdt = nlStateFcn(x,u)
% States x = [u v w p q r x y z phi theta psi dalpha1 dalpha2 dalpha3 dalpha4]
%             1 2 3 4 5 6 7 8 9 10   11   12     13     14      15       16  
% Inputs u = [u1 u2 u3 u4]

mb          = 0.793;    % mass of body
mr          = 0.0625;   % mass of each proprotor + motor rotor (https://robu.in/product/10x4-5-sf-props-black-cw-2pc/ 10"*4.5")
m_tot = mb+4*mr; mb = mb/m_tot; mr = mr/m_tot; % fudge to get 1 kg trim point
Irrzz    = .0002226; % Irrpolar, Izz for rotor (about shaft) disc: 1/2 MR^2
Irrperp   = Irrzz/2; % Ixx/Iyy for single rotor (assumes symmetric disc)
Ibbperp     = .00942;   % =Ixx=Iyy (for aircraft with 90 deg symmetry)
Ibbxx       = Ibbperp;  % moment of inertia about body x axis
Ibbyy       = Ibbperp;  % moment of inertia about body y axis
Ibbzz       = .01867;   % moment of inertia about body z axis
Ibbxz       = 0;        % product of inertia in XZ plane (not currently used)
R_arms      = .45/2;    % horizontal arm length from rotor shaft to centre (DJI F450)
z_rotors    = 0;        % not currently used
g           = 9.81;     % gravity constant

dxdt = x;
u = x(1);
= x(1);
= x(1);
= x(1);
= x(1);
= x(1);
= x(1);
= x(1);
= x(1);
= x(1);
= x(1);
= x(1);

t2 = cos(phi);
t3 = cos(psi);
t4 = cos(theta);
t5 = sin(phi);
t6 = sin(psi);
t7 = sin(theta);
t8 = Irrperp.*4.0;
t9 = R_arms.^2;
t10 = mr.*4.0;
t11 = 1.0./Irrpolar;
t17 = sqrt(2.0);
t16 = 1.0./t4;
t18 = mb+t10;
t23 = mr.*t9.*2.0;
t24 = t9.*t10;
t35 = (H1.*R_arms.*t17)./2.0;
t36 = (H2.*R_arms.*t17)./2.0;
t37 = (H3.*R_arms.*t17)./2.0;
t38 = (H4.*R_arms.*t17)./2.0;
t39 = (R_arms.*T1.*t17)./2.0;
t40 = (R_arms.*T2.*t17)./2.0;
t41 = (R_arms.*T3.*t17)./2.0;
t42 = (R_arms.*T4.*t17)./2.0;
t43 = (R_arms.*Y1.*t17)./2.0;
t44 = (R_arms.*Y2.*t17)./2.0;
t45 = (R_arms.*Y3.*t17)./2.0;
t46 = (R_arms.*Y4.*t17)./2.0;
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
t55 = NB+Q2+Q4+t14+t35+t38+t43+t44+t49+t50+t52+t53;
t56 = Irrpolar.*t55;
t57 = -t56;
out1 = [-q.*w+r.*v-t30.*(H1+H2+H3+H4-XB+g.*t7.*t18);t30.*(Y1+Y2+Y3+Y4+YB+g.*t4.*t5.*t18)+p.*w-r.*u;-p.*v+q.*u-t30.*(T1+T2+T3+T4-ZB-g.*t2.*t4.*t18);t54.*(LB+Mx1+Mx2+Mx3+Mx4-t39+t40+t41+t51-Irrpolar.*dalpha1.*q+Irrpolar.*dalpha2.*q-Irrpolar.*dalpha3.*q+Irrpolar.*dalpha4.*q-Ibbzz.*q.*r+Ibbperp.*q.*r-Irrpolar.*q.*r.*4.0+q.*r.*t8-mr.*q.*r.*t9.*2.0);t54.*(MB+My1+My2+My3+My4+t39+t40-t41+t51+Irrpolar.*dalpha1.*p-Irrpolar.*dalpha2.*p+Irrpolar.*dalpha3.*p-Irrpolar.*dalpha4.*p+Ibbzz.*p.*r-Ibbperp.*p.*r-Irrperp.*p.*r.*4.0+Irrpolar.*p.*r.*4.0+p.*r.*t23);t47.*(-M1+M2-M3+M4+NB+t35+t38+t43+t44+t49+t50+t52+t53);t3.*t4.*u-t2.*t6.*v+t5.*t6.*w+t3.*t5.*t7.*v+t2.*t3.*t7.*w;t4.*t6.*u+t2.*t3.*v-t3.*t5.*w+t5.*t6.*t7.*v+t2.*t6.*t7.*w;-t7.*u+t4.*t5.*v+t2.*t4.*w;t16.*(p.*t4+q.*t5.*t7+r.*t2.*t7);q.*t2-r.*t5;t16.*(q.*t5+r.*t2);t11.*t47.*(t25+t27+t32+t34+t57+Ibbzz+t24);t11.*t47.*(t26+t28+t31+t33+t56+Ibbzz.*t20+t20.*t24);t11.*t47.*(t25+t27+t32+t34+t57+Ibbzz.*t21+t21.*t24);t11.*t47.*(t26+t28+t31+t33+t56+Ibbzz.*t22+t22.*t24)];
