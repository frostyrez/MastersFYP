function mu_out = extend_mu(mu_in)

mu_out = mu_in;

mu_out(end+1:end*2) = 0;

for i = length(mu_out):-2:1
     mu_out(i) = mu_out(i/2);
end

for i = 1:2:length(mu_out)-1
    mu_out(i) = 0;
end
mu_out(1) = [];
for i = 2:2:length(mu_out)-1
    mu_out(i) = (mu_out(i-1)+mu_out(i+1)) / 2;
end

end