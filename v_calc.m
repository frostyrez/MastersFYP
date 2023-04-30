y = lqr_data;
x = lqr_time;
for i = 2:length(y)
    v(i) = ( (y(i)+y(i-1))/2 ) * (x(i)-x(i-1));
end
V = 4*sum(v);