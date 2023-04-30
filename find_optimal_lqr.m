% Check optimal lqr
A = reshape([-1.097500e-06;0.000000e+00;0.000000e+00;-4.432200e-05;0.000000e+00;0.000000e+00;1.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-1.097500e-06;0.000000e+00;0.000000e+00;-4.432200e-05;0.000000e+00;0.000000e+00;1.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-1.710500e-05;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;1.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-8.619000e-05;-8.619000e-05;-8.619000e-05;-8.619000e-05;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;1.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;1.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;1.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;9.810000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-9.810000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-1.070000e-02;-1.067000e-01;1.067000e-01;3.400000e-03;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-1.106300e+00;3.400000e-03;-3.400000e-03;3.400000e-03;0.000000e+00;0.000000e+00;-1.070000e-02;1.067000e-01;1.067000e-01;-3.400000e-03;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;3.400000e-03;-1.106300e+00;3.400000e-03;-3.400000e-03;0.000000e+00;0.000000e+00;-1.070000e-02;1.067000e-01;-1.067000e-01;3.400000e-03;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-3.400000e-03;3.400000e-03;-1.106300e+00;3.400000e-03;0.000000e+00;0.000000e+00;-1.070000e-02;-1.067000e-01;-1.067000e-01;-3.400000e-03;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;3.400000e-03;-3.400000e-03;3.400000e-03;-1.106300e+00],[16,16]);
B = reshape([0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-4.459000e-01;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;6.215420e+01;-4.459000e-01;4.459000e-01;-4.459000e-01;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;4.459000e-01;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-4.459000e-01;6.215420e+01;-4.459000e-01;4.459000e-01;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-4.459000e-01;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;4.459000e-01;-4.459000e-01;6.215420e+01;-4.459000e-01;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;4.459000e-01;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;0.000000e+00;-4.459000e-01;4.459000e-01;-4.459000e-01;6.215420e+01],[16,4]);

% Initialize LQR Gains
Q = eye(16); % Penalize positions and velocities
%Q(7:9,7:9) = Q(7:9,7:9)*2;
%R = 1; % Penalize effort

% Find Opt R first
R = .5:.5:10;
result = zeros(length(R),2);

for i = 1:length(r)
    K = lqr(A,B,Q,R(i));
    sim('lqr_model_quad_linear');
    result(i,1) = R(i);
    result(i,2) = sum(out.opt_signal{1}.Values.Data);
end