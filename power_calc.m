x = out.power{1}.Values.Time;
y = out.power{1}.Values.Data;

for i = 1:4
    s(i) = sum(trapz(x,y(:,i)));
end

s_all = sum(s);