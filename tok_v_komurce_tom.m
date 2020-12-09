clear all
close all
clc


% channel and medium parameters
nu = 0.0072; % dyn*s/cm^2 (medium 10% serum, 37°C) - (g*cm/s^2)*s/cm^2 = g/cm*s

% x = 0; % m - x position (left/right) in channel - 0 means centre
% h = (0.1/1000)/2; % m height
% b = (1/1000)/2; % m length
% y = -h; % m - y position (up/down) in channel - 0 means centre
% phi = 649.01/10^6/60; %l/s



h = (0.1/10)/2; % cm height
b = (1/10)/2; % cm length
phi = 649.01/10^3/60; %ml/s



%%
C1=[];
for n = 0:100
    C1(n+1) = (1/((2*n+1)^5))*tanh(((2*n+1)*pi*h)/(2*b));
end
q = ((4/3)*h*(b^3)) - (((8*(b^4))*((2/pi)^5))*sum(C1));




tau = [];
y_ind = 1;
yy=[linspace(-h,h,1000)];
xx=[linspace(-b,b,250)] ;
for y = yy
    x_ind = 1;
    for x = xx
        C2=[];
        for n = 0:100
            C2(n+1) = ((((((-1)^n)*b*pi)/(2*n+1)^2)*...
                (2/pi)^3)*(sinh((2*n+1)*((pi*y)/(2*b)))/cosh((2*n+1)*((pi*y)/(2*b))))...
                *cos(((2*n+1)*pi*x)/(2*b)));
        end
        tau(y_ind,x_ind) = ((nu*(phi/q)*sum(C2)));
        
        
        
        
        C3=[];
        for n = 0:100
            C3(n+1) = ( (((-1)^n)*(2*b^2)) / (2*n+1)^3 ) * ((2/pi)^3)...
                * (( cosh((2*n+1)*((pi*y)/(2*b))) )...
                / ( cosh((2*n+1)*((pi*h)/(2*b))) ))...
                * cos(((2*n+1)*pi*x)/(2*b));
        end
        
        v(y_ind,x_ind) = (phi/q)*( (b^2)/2 -...
            (x^2)/2 - sum(C3));
        
        x_ind = x_ind+1;
    end
    y_ind = y_ind+1;
end



figure
mesh(v)


figure
mesh(tau)

% plot(tau(:,round(size(tau,1)/2)))

v_cm_s = v;

v_um_s = v*10^4;

osa_y_um = yy*10^4;
v_um_s_profile = v_um_s(:,round(size(v_um_s,2)/2));
plot(osa_y_um, v_um_s_profile)


h_cell_um = 10;

w_cell_um = 25;

indexy_bunky =osa_y_um<(-50+h_cell_um);
v_prumer_um_s = sum(v_um_s_profile(indexy_bunky))/sum(indexy_bunky);



v_prumer_m_s  = v_prumer_um_s/(10^6);




A_um2 = w_cell_um * h_cell_um;

A_m2  = A_um2 / (10^6)^2;


ro_g_ml = 40.9/50;

ro_g_cm3 = ro_g_ml;

ro_kg_m3 = ro_g_ml ;



 F = ro_kg_m3 * A_m2 * v_prumer_m_s^2;
 
 
 tlak_pa = ro_kg_m3 * v_prumer_m_s^2;
 
 tlak_dyne = tlak_pa*10

 










