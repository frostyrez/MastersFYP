% figure(1)
% hold on
% grid on
% for i = 1:10
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
%     plot(rotorAero.mu_x_loops,rotorAero.C_M(:,i))
% end
% legend('Z = 1','Z = 2','Z = 3','Z = 4','Z = 5',...
%     'Z = 6','Z = 7','Z = 8','Z = 9','Z = 10')

% Given x and z (equal?)
x = -.1*rand
z = -.1*rand
[~,ix] = min(abs(rotorAero.mu_x_loops - x));
[~,iz] = min(abs(rotorAero.mu_z_loops - z));
CT_near = rotorAero.C_T(ix,iz);
CH_near = rotorAero.C_H(ix,iz);
CM_near = rotorAero.C_M(ix,iz);
CQ_near = rotorAero.C_Q(ix,iz);

CT_act = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_T,z,x);
CH_act = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_H,z,x);
CM_act = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_M,z,x);
CQ_act = interp2(rotorAero.mu_z_loops,rotorAero.mu_x_loops,rotorAero.C_Q,z,x);

diff(1) = (CT_act - CT_near)/ CT_act;
diff(2) = (CH_act - CH_near)/ CH_act;
diff(3) = (CM_act - CM_near)/ CM_act;
diff(4) = (CQ_act - CQ_near)/ CQ_act;
disp(diff)