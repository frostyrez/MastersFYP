function C_out = extend(C_in)

C_out = C_in;

C_out(:,end+1:end*2) = 0;
C_out(end+1:end*2,:) = 0;

for i = size(C_out,1):-2:1 % Loop 1
    C_out(i,:) = C_out(i/2,:);
end
for i = 1:2:size(C_out,1)
    C_out(i,:) = 0;
end

for i = size(C_out,2):-2:1 % Loop 2
    C_out(:,i) = C_out(:,i/2);
end
for i = 1:2:size(C_out,2)
    C_out(:,i) = 0;
end

% Clean up
C_out(:,1) = [];
C_out(1,:) = [];

% Interp
for i = 1:2:65
    for j = 2:2:60
        C_out(i,j) = ( C_out(i,j-1)+C_out(i,j+1) )/2;
    end
end
for j = 1:61
    for i = 2:2:64
        C_out(i,j) = ( C_out(i-1,j)+C_out(i+1,j) )/2;
    end
end

end