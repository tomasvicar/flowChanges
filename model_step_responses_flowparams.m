clc;clear all;close all;


step=0.01;
t=0:step:40;



G = 60 ;
ni = 300;
RC = 0.1;

tau0 = 10;




tau = tau0*exp(-t/RC);

plot(t,tau)



gamma_0 = tau0/G*exp(-(G/ni)*t);
figure(1);
plot(t,tau)
hold on
plot(t,gamma_0)




h_tau = -tau0*1/RC*exp(-t/RC);

h_gamma_0 = -(G/ni)*tau0/G*exp(-(G/ni)*t);

figure(2)
plot(t,h_tau)
hold on
plot(t,h_gamma_0)



h_num=conv(h_tau,h_gamma_0,'full');
figure(3)
plot(h_num*step)
hold on
h = tau0*tau0/G*((1/RC*(G/ni))/((G/ni)-1/RC))*(exp(-1/RC*t)-exp(-(G/ni)*t));

plot(h)




figure(4)
gamma_num=-cumsum(h_num*step*step)+ tau0*tau0/G;
plot(gamma_num)

figure(5)
gamma = tau0*tau0/G*((1/RC*(G/ni))/((G/ni)-1/RC))*(exp(-1/RC*t)/(1/RC)-exp(-(G/ni)*t)/(G/ni));
plot(gamma)

