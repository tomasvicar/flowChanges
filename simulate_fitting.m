clc;clear all;close all;



step=0.01;
t=0:step:20;


k1_orig=0.4;
k0_orig=3;
m1_orig=0.7;
m0_orig=9;


a = k0_orig*exp(-k1_orig*t);
ab = k0_orig*m0_orig*((k1_orig*m1_orig)/(m1_orig-k1_orig))*(exp(-k1_orig*t)/k1_orig-exp(-m1_orig*t)/m1_orig);



a_noise = a + 0.1*randn(size(a));
ab_noise = ab + 0.1*randn(size(ab));



eq =  @(k0, k1, x) k0*exp(-k1*x);
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Robust','Bisquare',...
               'Lower',[0,0],...
               'Upper',[Inf,Inf],...
               'StartPoint',[1 1]);
ft = fittype(eq,'options',fo,'coefficients',{'k0','k1'});
f = fit( t', a_noise', ft);


k0 = f.k0;
k1 = f.k1;



eq = @(m0, m1, x) k0*m0*((k1*m1)/(m1-k1))*(exp(-k1*x)/k1-exp(-m1*x)/m1);
fo = fitoptions('Method','NonlinearLeastSquares',...
               'Robust','Bisquare',...
               'Lower',[0,0],...
               'Upper',[Inf,Inf],...
               'StartPoint',[1 1]);
ft = fittype(eq,'options',fo,'coefficients',{'m0','m1'});
f = fit( t', ab_noise', ft);


m0 = f.m0;
m1 = f.m1;









