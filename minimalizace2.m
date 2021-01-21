clc;clear all;close all force;
addpath('utils')


tmp = load('real_data/data_1.mat');

tau = tmp.tau;  %shear stress
tau_t = tmp.tau_t; %casova osa shera stresu
gamma = tmp.gamma;  %shear strain (odezva hadičky + buńky)
gamma_bg = tmp.gamma_bg; %shear strain (odezva hadičky + buńky) bez odečtenáho pozadí - tady je potřeba optimalizovat i polynom
gamma_t = tmp.gamma_t; %casova osa gamma

ttt = max([tau_t(1),gamma_t(1)]):0.1:min([tau_t(end),gamma_t(end)]);  %převzorkujeme na společnou časovou osu


gamma = fillmissing(interp1(gamma_t,gamma_bg,ttt),'nearest');
tau = fillmissing(interp1(tau_t,tau,ttt),'nearest');



tt_h = -0:0.1:40;% osa pro impuilzni charakteristiku

order = 7;

h = @(b,x) b(1)*b(2)*exp(-b(2)*x);


pred = @(b) (custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*0.1+polyval(b(4:end),ttt));

nrmrsd = @(b) double(norm(gamma - pred(b) , 1) );
nrmrsd2 = @(b) double(gamma - pred(b));
% +10000*norm(b(4:end))
%

% fo = fit(ttt',gamma',['poly' num2str(order)],'Robust','Bisquare');
% ps1 = coeffvalues(fo);
ps = double(polyfit(ttt',gamma',order));



B0 = [0.0139    0.4582  172.3600, ps];
lb = [0.001 0.01 100 -0.1*ones(1,order+1)];
ub = [0.1 5 300 0.1*ones(1,order+1)];

Aneq = [];
bneq = [];
Aeq = [];
beq = [];
nonlcon = [];



bs={};
fvals = [];
alg = {};
iter = [];
iters = 1 ;
for k = 1:iters
%     tic
%     options = optimoptions('ga','FunctionTolerance',0,'MaxGenerations',30);
%     [b,fval] = ga(nrmrsd,length(B0),Aneq,bneq,Aeq,beq,lb,ub,nonlcon,options);
%     bs=[bs,b];
%     fvals = [fvals,fval];
%     alg = [alg,'ga'];
%     iter = [iter,k];
%     toc
%     tic
%     options = optimoptions('simulannealbnd','FunctionTolerance',0,'MaxIterations',10000,'PlotFcn','saplotbestf');
%     [b,fval] = simulannealbnd(nrmrsd,B0,lb,ub,options);
%     bs=[bs,b];
%     fvals = [fvals,fval];
%     alg = [alg,'sa'];
%     iter = [iter,k];
%     toc
    tic
%     
    options = optimoptions('patternsearch','FunctionTolerance',0,'PlotFcn','psplotbestf','MaxIterations',3000,'MeshTolerance',0,'StepTolerance',0,'MaxFunctionEvaluations',9999999,'UseParallel',true);
    [b,fval] = patternsearch(nrmrsd,B0,Aneq,bneq,Aeq,beq,lb,ub,nonlcon,options);
    bs=[bs,b];
    fvals = [fvals,fval];
    alg = [alg,'ps'];
    iter = [iter,k];
    toc

%     tic
%     options = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective',...
%     'MaxFunctionEvaluations',99999999,'MaxIterations',3000,'OptimalityTolerance',0,...
%     'UseParallel',true,'StepTolerance',0,'PlotFcn','optimplotresnorm');
%     [b,fval] = lsqnonlin(nrmrsd2,B0,lb,ub,options);
%     bs=[bs,b];
%     fvals = [fvals,fval];
%     alg = [alg,'ps'];
%     iter = [iter,k];
%     toc



%     tic
%     gs = MultiStart('FunctionTolerance',0,'XTolerance',0,'StartPointsToRun','all');
%     opts = optimoptions(@fmincon,'FunctionTolerance',0);
%     problem = createOptimProblem('fmincon','x0',B0,'objective',nrmrsd,'lb',lb,'ub',ub,'options',opts);
%     [bb,fval] = run(gs,problem,200);
%     bs=[bs,bb];
%     fvals = [fvals,fval];
%     alg = [alg,'psw'];
%     iter = [iter,k];

%     options = optimoptions('particleswarm','FunctionTolerance',0,'MaxIterations',300,'MaxStallIterations',100000,'PlotFcn','pswplotbestf');
%     [bb,fval] = particleswarm(nrmrsd,length(B0),lb,ub,options);
%     bs=[bs,bb];
%     fvals = [fvals,fval];
%     alg = [alg,'psw'];
%     iter = [iter,k];
%     toc
    
    
end
fvals
[~,tmp] = min(fvals);
b = bs{tmp};





G = 1/b(1)
ni = G/b(2)


figure;
title([num2str(G) '   ' num2str(ni)])
hold on;
plot(gamma)
tmp = pred(b);
plot(tmp)


figure;
title([num2str(G) '   ' num2str(ni)])
hold on;
plot(gamma-polyval(b(4:end),ttt))
tmp = (custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*0.1);
plot(tmp)



