n = 1000;

CT_near = zeros(n,1); CH_near = CT_near; CQ_near = CT_near; CM_near = CT_near;
x = -.1*rand([n 1]);
z = -.1*rand([n 1]);

tic
for i = 1:n    
%     [~,ix] = min(abs(rotorAero.mu_x_loops - x(i)));
%     [~,iz] = min(abs(rotorAero.mu_z_loops - z(i)));
%     CT_near(i) = rotorAero.C_T(ix,iz);
%     CH_near(i) = rotorAero.C_H(ix,iz);
%     CM_near(i) = rotorAero.C_M(ix,iz);
%     CQ_near(i) = rotorAero.C_Q(ix,iz);
% Enhanced
    [~,ix] = min(abs(mu_x - x(i)));
    [~,iz] = min(abs(mu_z - z(i)));
    CT_near(i) = C_Tv2(ix,iz);
    CH_near(i) = C_Hv2(ix,iz);
    CM_near(i) = C_Mv2(ix,iz);
    CQ_near(i) = C_Qv2(ix,iz);
end
toc

CT_act = zeros(n,1); CH_act = CT_act; CM_act = CT_act; CQ_act = CT_act;
tic
for i = 1:n
    CT_act(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_T,z(i),x(i));
    CH_act(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_H,z(i),x(i));
    CM_act(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_M,z(i),x(i));
    CQ_act(i) = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_Q,z(i),x(i));
end
toc

diff = zeros(n,4);
for i = 1:n
    diff(i,1) = (CT_act(i) - CT_near(i))/ CT_act(i);
    diff(i,2) = (CH_act(i) - CH_near(i))/ CH_act(i);
    diff(i,3) = (CM_act(i) - CM_near(i))/ CM_act(i);
    diff(i,4) = (CQ_act(i) - CQ_near(i))/ CQ_act(i);
end

mean(diff)