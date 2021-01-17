clc;clear all;close all;


% save('real_data.mat','imageFrameTimes','WCdiff','WCextremaPoss','h','flowmeterTimes','flowmeterValues','flowExtremaPoss','opt')
 
edgeNum=2;
load('real_data.mat')


xdata0 = imageFrameTimes(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1));
shift_x = xdata0(1);
t_img = xdata0 - shift_x;

% h = heights_all{cellNum}(edgeNum);
gamma = (WCdiff(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1))/opt.px2mum)/h;


xdata2 = flowmeterTimes(flowExtremaPoss(edgeNum)+200:flowExtremaPoss(edgeNum+1));
shift_x2 = xdata2(1);
t_flow = xdata2 - shift_x2;

%%%bude potřeba detekovat bodík hodně doprava

tau = (flowmeterValues(flowExtremaPoss(edgeNum)+200:flowExtremaPoss(edgeNum+1))/12.98)*0.1;


tau = tau-tau(end);
gamma = gamma-gamma(end);



eq = 'A*exp(-lam*x)';
fo = fitoptions('Method','NonlinearLeastSquares',...
   'Robust','Bisquare',...
   'Lower',[0,0],...
   'Upper',[Inf,Inf],...
   'StartPoint',[1 1]);
ft = fittype(eq,'options',fo,'coefficients',{'A','lam'});
f = fit( t_img, gamma, ft);

A = f.A;
lam = f.lam;

G1 = tau(1)/A
ni1 = G1/lam





drawnow;


eq =  @(k0, k1, x) k0*exp(-k1*x);   
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Robust','Bisquare',...
               'Lower',[0,0,0],...
               'Upper',[Inf,Inf,5],...
               'StartPoint',[1 1]);
ft = fittype(eq,'options',fo,'coefficients',{'k0','k1'});
f = fit( t_flow, tau, ft);

k0 = f.k0;
k1 = f.k1;

tau0 = k0;
RC = 1 / k1;

figure;
hold on;
plot(t_flow,tau)
plot(t_flow,eq(k0,k1,t_flow));

drawnow;

eq = @(m0, m1, x) k0*m0*((k1*m1)/(m1-k1))*(exp(-k1*x)/k1-exp(-m1*x)/m1);
% eq = @(m0, m1, x) k0*m0*((k1*m1)/(m1-k1))*(exp(-k1*x)/k1-exp(-m1*x)/m1);
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Robust','Bisquare',...
               'Lower',[0,0],...
               'Upper',[Inf,Inf],...
               'StartPoint',[1 1]);
ft = fittype(eq,'options',fo,'coefficients',{'m0','m1'});
f = fit( t_img, gamma, ft);


m0 = f.m0;
m1 = f.m1;

G = 1/m0
ni = G/m1



figure;
hold on;
plot(t_img,gamma)
plot(t_img,eq(m0,m1,t_img));





