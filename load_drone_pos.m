function rotor = load_drone_pos(cartesian,euler) % [data: time x y z]
%% Plot center
rotor = cartesian; % initiate rotor matrix
rotor(:,:,2) = cartesian;
rotor(:,:,3) = cartesian;
rotor(:,:,4) = cartesian;

%% Adjust for rotor shafts position
arm = .225; % distance from center to rotor shaft
rotor(:,1,1) = 0+rotor(:,1,1);    % rotor 1 x
rotor(:,2,1) = arm+rotor(:,2,1);  % rotor 1 y

rotor(:,1,2) = arm+rotor(:,1,2);  % rotor 2 x
rotor(:,2,2) = 0+rotor(:,2,2);    % rotor 2 y

rotor(:,1,3) = 0+rotor(:,1,3);    % rotor 3 x
rotor(:,2,3) = -arm+rotor(:,2,3); % rotor 3 y

rotor(:,1,4) = -arm+rotor(:,1,4); % rotor 4 x
rotor(:,2,4) = 0+rotor(:,2,4);    % rotor 4 y

%% Rotate points around center
%Phi rotation, around x axis, affects 1 and 3
for i = 1:length(euler)
    rotor(i,2,3) = rotor(i,2,3)*cos(euler(i,1));
    rotor(i,3,3) = rotor(i,3,3)+arm*sin(euler(i,1));
    rotor(i,2,1) = rotor(i,2,1)*cos(euler(i,1));
    rotor(i,3,1) = rotor(i,3,1)-arm*sin(euler(i,1));
%end

%Theta rotation, around y axis, affects 2 and 4
% for i = 1:length(euler)
    rotor(i,1,2) = rotor(i,1,2)*cos(euler(i,2));
    rotor(i,3,2) = rotor(i,3,2)+arm*sin(euler(i,2));
    rotor(i,1,4) = rotor(i,1,4)*cos(euler(i,2));
    rotor(i,3,4) = rotor(i,3,4)-arm*sin(euler(i,2));
 end

%Theta rotation, around z axis, affects all
%     rotor(i,1,1) = rotor(i,1,1)*cos(euler(i,3));
%     rotor(i,2,1) = rotor(i,2,1)-arm*sin(euler(i,2));
%     rotor(i,1,2) = rotor(i,1,1)*cos(euler(i,3));
%     rotor(i,2,2) = rotor(i,2,1)-arm*sin(euler(i,2));
%     rotor(i,1,3) = rotor(i,1,1)*cos(euler(i,3));
%     rotor(i,2,3) = rotor(i,2,1)-arm*sin(euler(i,2));
%     rotor(i,1,4) = rotor(i,1,1)*cos(euler(i,3));
%     rotor(i,2,4) = rotor(i,2,1)-arm*sin(euler(i,2));
% end
% end

%% Test data
% rotor = zeros(10,3,4); % time, xyz, n
% k = 0;
% 
% for i =  1:10
%     for n = 1:4
%         rotor(i,:,n) = k;
%     end
%     k = k+1;
% end
% 
% rotor(:,1,1) = 4+rotor(:,1,1); % Adjust rotor position
% rotor(:,2,1) = 5+rotor(:,2,1);
% 
% rotor(:,1,2) = 5+rotor(:,1,2);
% rotor(:,2,2) = 4+rotor(:,2,2);
% 
% rotor(:,1,3) = 4+rotor(:,1,3);
% rotor(:,2,3) = 3+rotor(:,2,3);
% 
% rotor(:,1,4) = 3+rotor(:,1,4);
% rotor(:,2,4) = 4+rotor(:,2,4);