clc;clear all;close all;
addpath('utils')


tmp = load('real_data/data_1.mat');

tau = tmp.tau;  %shear stress
tau_t = tmp.tau_t; %casova osa shera stresu
gamma = tmp.gamma;  %shear strain (odezva hadičky + buńky)
gamma_bg = tmp.gamma_bg; %shear strain (odezva hadičky + buńky) bez odečtenáho pozadí - tady je potřeba optimalizovat i polynom
gamma_t = tmp.gamma_t; %casova osa gamma

ttt = max([tau_t(1),gamma_t(1)]):0.1:min([tau_t(end),gamma_t(end)]);  %převzorkujeme na společnou časovou osu


gamma = fillmissing(interp1(gamma_t,gamma,ttt),'nearest');
tau = fillmissing(interp1(tau_t,tau,ttt),'nearest');



tt_h = -0:0.1:40;% osa pro impuilzni charakteristiku


h = @(b,x) b(1)*b(2)*exp(-b(2)*x);

nrmrsd = @(b) norm(gamma - (custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*0.1-b(4)), 1);


B0 = [0.0139    0.4582  172.3600,0.04];
lb = [0.001 0.01 0 -1];
ub = [0.1 3 300 1];


options = optimoptions('particleswarm','FunctionTolerance',0,'MaxIterations',100,'MaxStallIterations',100000);
[b,fval] = particleswarm(nrmrsd,length(B0),lb,ub,options);



G = 1/b(1)
ni = G/b(2)


figure;
title([num2str(G) '   ' num2str(ni)])
hold on;
plot(gamma)
tmp = (custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*0.1-b(4));
plot(tmp)



