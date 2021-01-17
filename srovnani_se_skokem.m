clc;clear all;close all;



step=0.01;
t=0:step:20;


k1=1000;
k0=3;
a = k0*exp(-k1*t);



m1=0.7;
m0=9;
b = m0*exp(-m1*t);
figure(1);
plot(t,a)
hold on
plot(t,b)






ha = k0*k1*exp(-k1*t);



hb = m0*m1*exp(-m1*t);

figure(2)
plot(t,ha)
hold on
plot(t,hb)

tt = -300:step:300;
stepf = double(tt<0);



figure(3)
hold on
plot(tt,stepf)
sig1 = conv(stepf,ha,'same')*step;
plot(tt,sig1)
sig2 = conv(sig1,hb,'same')*step;
plot(tt,sig2)

xlim([-50,20])



figure(5)
ab = k0*m0*((k1*m1)/(m1-k1))*(+exp(-k1*t)/k1-exp(-m1*t)/m1);
plot(t,ab)

