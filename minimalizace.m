clc;clear all;close all;
addpath('utils')





for edgeNum = 1:2:8 
load('real_data.mat')

gamma = WCdiff/opt.px2mum/h;
tau = flowmeterValues/12.98*0.1;
t = imageFrameTimes;
tt = flowmeterTimes;

ttt = max([t(1),tt(1)]):0.1:min([t(end),tt(end)]);
tt_h = -0:0.1:40;

gamma = fillmissing(interp1(t,gamma,ttt),'nearest');
tau = fillmissing(interp1(tt,tau,ttt),'nearest');


edge_times_tmp = flowmeterTimes([flowExtremaPoss(edgeNum),flowExtremaPoss(edgeNum+2)]);
numEdges = length(edge_times_tmp);
imgEdgeIdx = zeros(1,numEdges);
for edgeNum = 1:numEdges
    [~,edgeIdx(edgeNum)] = min(abs(ttt-edge_times_tmp(edgeNum)));
end


gamma = gamma(edgeIdx(1):edgeIdx(2));

edgeIdx(1) = edgeIdx(1) - (length(tt_h)-1);
edgeIdx(2) = edgeIdx(2) + (length(tt_h)-1);
tau = tau(edgeIdx(1):edgeIdx(2));

% figure;
% plot(gamma);
% hold on
% plot(tau)
% drawnow;

h = @(b,x) b(1)*b(2)*exp(-b(2)*x);

nrmrsd = @(b) norm(gamma - (cropsig(custom_shift(conv(tau,h(b,tt_h), 'valid' ),b(3)),[(length(tt_h)-1)/2,(length(tt_h)-1)/2])*0.1-b(4)), 1);


B0 = [0.0139    0.4582  172.3600,0.04];
lb = [0.001 0.01 100 -1];
ub = [0.1 3 300 1];





Aneq = [];
bneq = [];
Aeq = [];
beq = [];
nonlcon = [];



bs={};
fvals = [];
alg = {};
iter = [];
iters = 2 ;
for k = 1:iters
    tic
    options = optimoptions('ga','FunctionTolerance',0,'MaxGenerations',50);
    [b,fval] = ga(nrmrsd,length(B0),Aneq,bneq,Aeq,beq,lb,ub,nonlcon,options);
    bs=[bs,b];
    fvals = [fvals,fval];
    alg = [alg,'ga'];
    iter = [iter,k];
    toc
    tic
    options = optimoptions('simulannealbnd','FunctionTolerance',0,'MaxIterations',800);
    [b,fval] = simulannealbnd(nrmrsd,B0,lb,ub,options);
    bs=[bs,b];
    fvals = [fvals,fval];
    alg = [alg,'sa'];
    iter = [iter,k];
    toc
    tic
    options = optimoptions('patternsearch','FunctionTolerance',0,'MaxIterations',200);
    [b,fval] = patternsearch(nrmrsd,B0,Aneq,bneq,Aeq,beq,lb,ub,nonlcon,options);
    bs=[bs,b];
    fvals = [fvals,fval];
    alg = [alg,'ps'];
    iter = [iter,k];
    toc
    tic
    options = optimoptions('particleswarm','FunctionTolerance',0,'MaxIterations',100,'MaxStallIterations',100000);
    [b,fval] = particleswarm(nrmrsd,length(B0),lb,ub,options);
    bs=[bs,b];
    fvals = [fvals,fval];
    alg = [alg,'psw'];
    iter = [iter,k];
    toc
    
    
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
tmp = cropsig(custom_shift(conv(tau,h(b,tt_h), 'valid' ),b(3)),[(length(tt_h)-1)/2,(length(tt_h)-1)/2])*0.1-b(4);
plot(tmp)




end
