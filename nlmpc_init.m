nx = 16;
ny = 16;
nu = 4;
nlobj = nlmpc(nx,ny,nu);
nlobj.Model.StateFcn = "nlStateFcn";
%nlobj.Optimization.CustomCostFcn = 'nlCostFcn';
nlobj.Weights.OutputVariables = zeros(1,16);
nlobj.Weights.OutputVariables(7:9) = 10;
nlobj.Weights.ManipulatedVariables(1:4) = .1;
nlobj.Weights.ManipulatedVariablesRate(1:4) = 0;
%rng(0)
%validateFcns(nlobj,rand(nx,1),rand(nu,1));

Ts = .01;
p = 200;
c = 50;
nlobj.Optimization.SolverOptions.MaxIterations = 50;
nlobj.Ts = Ts;
nlobj.PredictionHorizon = p;
nlobj.ControlHorizon = c;
nlobj.MV = struct('Min',{-6.176;-6.176;-6.176;-6.176},...
    'Max',{8.624;8.624;8.624;8.624});
nlobj.Optimization.UseSuboptimalSolution = true;

% Nominal control to keep the quadrotor floating
nloptions = nlmpcmoveopt;
nloptions.MVTarget = [0 0 0 0]; 
nloptions.MVMin(1:4) = -6.176;
nloptions.MVMax(1:4) = 8.624;
mv = nloptions.MVTarget;

Duration = 5;
%hbar = waitbar(0,'Simulation Progress');
xHistory = zeros(1,16); xHistory(13:16) = 459.3008;
time = zeros(Duration/Ts,1);
infoHistory = zeros(Duration/Ts,3);
lastMV = mv;
uHistory = lastMV;
yref = zeros(p,16); yref(:,7:8) = 1; yref(:,13:16) = 459.3008;

% for j = 1:2
%     if j == 2
%         save('sim2a')
%         yref = zeros(p,16); yref(:,7:9) = 1; yref(:,13:16) = 459.3008;
%         MVs = MVs2;
%     end

for k = 1:(Duration/Ts)
    tic
    % Set initial guesses
    for i = 1:p
        if i+k-1 <= length(MVs)
            nloptions.MV0(i,:) = MVs(i+k-1,:); % Initial Guess
        else
            nloptions.MV0(i:p,:) = 0;
            break
        end
    end
    % Set references for previewing
    t = linspace(k*Ts, (k+p-1)*Ts,p);
    % Compute the control moves with reference previewing.
    xk = xHistory(k,:);
    [uk,nloptions,info] = nlmpcmove(nlobj,xk,lastMV,yref,[],nloptions);
    infoHistory(k,1) = info.Iterations;
    infoHistory(k,2) = info.Cost;
    infoHistory(k,3) = info.ExitFlag;
    uHistory(k+1,:) = uk';
    lastMV = uk;
    % Update states.
    ODEFUN = @(t,xk) nlStateFcn(xk,uk);
    [TOUT,YOUT] = ode45(ODEFUN,[0 Ts], xHistory(k,:)');
    xHistory(k+1,:) = YOUT(end,:);
    time(k) = toc;
    %waitbar(k*Ts/Duration,hbar);
end
% end
%save('sim2b')
%close(hbar)
