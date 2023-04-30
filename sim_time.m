for i = 1:20
    tic
    sim('model_quad_linear_mpc');
    time(i) = toc;
end
mean(time)

% 0.5264 for mpc N = 10, 0.58 for N = 50
% 0.4635 for lqr N = 10, 0.4896 for N = 50                   