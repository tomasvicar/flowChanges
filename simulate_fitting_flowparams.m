clc;clear all;close all;


step=0.01;
t=0:step:40;



G = 60 ;
ni = 300;
RC = 0.1;

tau0 = 10;




tau = tau0*exp(-t/RC);
gamma = tau0*tau0/G*((1/RC*(G/ni))/((G/ni)-1/RC))*(exp(-1/RC*t)/(1/RC)-exp(-(G/ni)*t)/(G/ni));



tau_noise = tau + 0.1*randn(size(tau));
gamma_noise = gamma + 0.1*randn(size(gamma));



eq =  @(k0, k1, x) k0*exp(-k1*x);
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Robust','Bisquare',...
               'Lower',[0,0],...
               'Upper',[Inf,Inf],...
               'StartPoint',[1 1]);
ft = fittype(eq,'options',fo,'coefficients',{'k0','k1'});
f = fit( t', tau_noise', ft);

k0 = f.k0;
k1 = f.k1;

tau0 = k0;
RC = 1 / k1;




eq = @(m0, m1, x) k0*m0*((k1*m1)/(m1-k1))*(exp(-k1*x)/k1-exp(-m1*x)/m1);
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Robust','Bisquare',...
               'Lower',[0,0],...
               'Upper',[Inf,Inf],...
               'StartPoint',[1 1]);
ft = fittype(eq,'options',fo,'coefficients',{'m0','m1'});
f = fit( t', gamma_noise', ft);


m0 = f.m0;
m1 = f.m1;

G = tau0/m0;
ni = G/m1;







