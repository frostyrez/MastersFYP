function [time_out,data_out] = simplify_drone(time_in,data_in,timestep)
% Simplifies positional data of vehicle to be played in real speed

% Initialise
finalTime = time_in(end); % Total time in seconds
time_out = (0:timestep:finalTime).';
data_out = zeros(length(time_out),1);

for set=1:size(data_in,2)
    idx1 = 1; % idx1 = beginning of second, idx2 = end of second
    j=1;
    for i = 1:finalTime % i counts seconds
        [~,idx2]=min(abs(time_in-i));
        for k = 0:timestep:1-timestep
            time_seeked = i-1+k;
            [~,target] = min(abs(time_in(idx1:idx2)-time_seeked));
            data_out(j,set) = data_in((idx1-1)+target,set);
            j=j+1;
        end
        idx1 = idx2;
    end
end
