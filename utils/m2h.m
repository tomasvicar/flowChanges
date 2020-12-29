function [h] =  m2h(m)

alpha = 0.18;
lambda = 0.65;

n_bunka = 1.351; %moje maximum
% n_bunka = 1.344;%jardovo měření

n_medium = 1.331;% moje min
% n_medium = 1.334;% bez FBS
% n_medium = 1.3369;%s FBS


phi = (m*2*pi*alpha)/(lambda);



h = (phi*lambda)/(2*pi*(n_bunka-n_medium));


end