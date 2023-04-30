%parameter intialisation for model_quad.slx

% vehicle model (see mass+inertia.xlsx)

K = reshape([-5.110766e+00;-5.110828e+00;5.110766e+00;5.110828e+00;-5.110828e+00;5.110766e+00;5.110828e+00;-5.110766e+00;-5.404988e+00;-5.404988e+00;-5.404988e+00;-5.404988e+00;-4.040006e+00;4.040001e+00;4.040006e+00;-4.040001e+00;4.040001e+00;4.040006e+00;-4.040001e+00;-4.040006e+00;-8.161851e-01;8.161851e-01;-8.161851e-01;8.161851e-01;-7.071059e+00;-7.071076e+00;7.071059e+00;7.071076e+00;-7.071076e+00;7.071059e+00;7.071076e+00;-7.071059e+00;-7.071068e+00;-7.071068e+00;-7.071068e+00;-7.071068e+00;-1.811892e+01;1.811885e+01;1.811892e+01;-1.811885e+01;1.811885e+01;1.811892e+01;-1.811885e+01;-1.811892e+01;-5.000000e-01;5.000000e-01;-5.000000e-01;5.000000e-01;1.257982e-01;1.907311e-02;-9.340298e-02;1.907311e-02;1.907311e-02;1.257982e-01;1.907311e-02;-9.340298e-02;-9.340298e-02;1.907311e-02;1.257982e-01;1.907311e-02;1.907311e-02;-9.340298e-02;1.907311e-02;1.257982e-01],[4,16]);
mb          = 0.793;    % mass of body
mr          = 0.0625;   % mass of each proprotor + motor rotor (https://robu.in/product/10x4-5-sf-props-black-cw-2pc/ 10"*4.5")
m_tot = mb+4*mr; mb = mb/m_tot; mr = mr/m_tot; % fudge to get 1 kg trim point
Irrpolar    = .0002226; % Izz for rotor (about shaft) disc: 1/2 MR^2
Irrperp   = Irrpolar/2; % Ixx/Iyy for single rotor (assumes symmetric disc)
Ibbperp     = .00942;   % =Ixx=Iyy (for aircraft with 90 deg symmetry)
Ibbxx       = Ibbperp;  % moment of inertia about body x axis
Ibbyy       = Ibbperp;  % moment of inertia about body y axis
Ibbzz       = .01867;   % moment of inertia about body z axis
Ibbxz       = 0;        % product of inertia in XZ plane (not currently used)
R_arms      = .45/2;    % horizontal arm length from rotor shaft to centre (DJI F450)
z_rotors    = 0;        % not currently used
g           = 9.81;     % gravity constant

% motor model
% (initially "second hand" 1200Kv 32-36 BLDC; not sure if this
% is the same but Kv matches)
% Kv          = 133;      % motor speed constant
% R           = 0.823;    % winding resistance
% i0          = 0.233;    % zero-torque current
% Vmax        = 14.8;     % 4 cell LiPo max voltage
% final values used in report:
Kv          = 130;      % motor speed constant
Rwinding    = 0.56;    % winding resistance
%i0          = 0.233;    % zero-torque current
i0          = 0;    % zero-torque current
Vmax        = 4*3.7;%14.8;     % 4 cell LiPo max voltage

% rotor aerodynamics
%CT = 0.0219; % estimated from prop thrust curves at https://rcplanes.online/calc_thrust.htm (T = CT * rho * .5 * R^2 * pi * R^2 * (RPM/60*2*pi)^2 ) 46g @ 200RPM
%CT = 0.1; % plucked from some test data online for a 10x5" pitch prop
%CT = 0.0343 % see rotor_data.xls
CT = 0.0248; % see rotor_data.xls (no longer used?!)
rho=1.225;
R_rotor=.125;
rotorAero = load('loopQuadBET_fromTheBook.mat','C_T','C_H','C_M','C_Q','mu_z_loops','mu_x_loops');
spin_dir = [1 -1 1 -1];
for ii=1:4
    R_RB(1:3,1:3,ii)=eye(3); % transforms from body to rotor frame
end

% body aerodynamics
CDbody = 1;                  % pessimistic (flat plate/cube)
CDbody = 0.5;                % optimistic (sphere)
CDbody = 0.75;               % why not
Rbody  = 0.1;
Abody  = pi*Rbody^2;


% DJI F450 spec:
% Weight: 280g (w/out electronics)
% G.Weight: 395g
% Recommended (Not Included):
% A2208/A2212 800KV~1100kv brushless motor (85-115 rad/s/V)
% ESC 15~25A
% 1800mAh~3600mAh 3S LiPo battery
% 1045/8045 Forward&Reverse propeller

% each motor: 69g
% each esc 11.3g

% flight controller: 5g
% transmitter: 12g
% battery: 1800mAh 3S 160g (5000mAh 4S 523g; 450mAh 4S 63g)