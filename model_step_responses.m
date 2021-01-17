clc;clear all;close all;



step=0.01;
t=0:step:20;


k1=0.4;
k0=3;
a = k0*exp(-k1*t);



m1=0.7;
m0=9;
b = m0*exp(-m1*t);
figure(1);
plot(t,a)
hold on
plot(t,b)






ha = -k0*k1*exp(-k1*t);



hb = -m0*m1*exp(-m1*t);

figure(2)
plot(t,ha)
hold on
plot(t,hb)



h_num=conv(ha,hb,'full');
figure(3)
plot(h_num*step)
hold on
h = k0*m0*((k1*m1)/(m1-k1))*(exp(-k1*t)-exp(-m1*t));
plot(h)




figure(4)
ab_num=-cumsum(h_num*step*step)+k0*m0;
plot(ab_num)

figure(5)
ab = k0*m0*((k1*m1)/(m1-k1))*(+exp(-k1*t)/k1-exp(-m1*t)/m1);
plot(ab)

