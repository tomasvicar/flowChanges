clc;clear all;close all;
addpath('utils')


load('real_data.mat')


t = imageFrameTimes(WCextremaPoss(1):WCextremaPoss(end));

% h = heights_all{cellNum}(edgeNum);
gamma = (WCdiff(WCextremaPoss(1):WCextremaPoss(end))/opt.px2mum)/h;


tt = flowmeterTimes(flowExtremaPoss(1):flowExtremaPoss(end));

tau = (flowmeterValues(flowExtremaPoss(1):flowExtremaPoss(end))/12.98)*0.1;


ttt = tt(1):0.1:tt(end);


gamma = fillmissing(interp1(t,gamma,ttt),'nearest');

tau = fillmissing(interp1(tt,tau,ttt),'nearest');

plot(gamma)
hold on 
plot(tau)


[T,S]=deconvolution(gamma,tau);

figure
plot(S)
hold on
plot(conv(tau,S,'same'))





