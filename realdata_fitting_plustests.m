clc;clear all;close all;


% save('real_data.mat','imageFrameTimes','WCdiff','WCextremaPoss','h','flowmeterTimes','flowmeterValues','flowExtremaPoss','opt')
 
edgeNum=6;
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


% tau = tau-tau(end);
% gamma = gamma-gamma(end);



eq = @(A,lam,xsift,ysift,x) A*exp(-lam*(x-xsift))-ysift;
fo = fitoptions('Method','NonlinearLeastSquares',...
   'Robust','Bisquare',...
   'Lower',[0,0,0,-Inf],...
   'Upper',[Inf,Inf,2,Inf],...
   'StartPoint',[0.065 0.26,0,0],...
   'Algorithm', 'Trust-Region');
ft = fittype(eq,'options',fo,'coefficients',{'A','lam','xsift','ysift'});
f = fit( t_img, gamma, ft);

A = f.A;
lam = f.lam;
xsift = f.xsift;
ysift = f.ysift;

G1 = tau(1)/A
ni1 = G1/lam



figure;
hold on;
plot(t_img,gamma)
plot(t_img,eq(A,lam,xsift,ysift,t_img));







% eq = @(b,x) b(1)*exp(-b(2)*(x))-b(3);
% nrmrsd = @(b) norm(gamma - eq(b,t_img));
% B0 = [0.065 0.26,0];
% [f,rnrm] = fminsearch(nrmrsd, B0);
% 
% 
% A = f(1);
% lam = f(2);
% ysift = f(3);
% 
% 
% 
% 
% G1 = tau(1)/A
% ni1 = G1/lam
% 
% 
% 
% figure;
% hold on;
% plot(t_img,gamma)
% plot(t_img,eq([A,lam,ysift],t_img));



