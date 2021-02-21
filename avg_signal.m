clc;clear all;close all force;
addpath('utils')


file_names = subdir('data_hard_soft_syringe/*_signals.mat');

% file_names = file_names([1,7]);


taus_soft = {};
taus_hard = {};
gamma_soft = {};
gamma_hard = {};


for file_num = 1:length(file_names)
    
    file_name = file_names(file_num).name
    
    data = load(file_name);
    
    Gs = [];
    nis = [];
    bs = {};
    
    for cell_num = 1:length(data.gammas)
        cell_num
        
        tau = data.taus{cell_num};
        gamma = data.gammas{cell_num};
        time = data.times{cell_num};
        T_period = data.optShear.T_period;
        
        
        tt_h = 0:T_period:40;
        tt_h = tt_h(:);
        
        
        use = (65-10)/T_period:(65+8*20-2)/T_period; % 5 Pa
%         use = (65+5*20)/T_period:(65+14*20)/T_period; % 10 Pa
%         use(use>length(tau)) = [];

        if use>length(tau)
            
           continue 
        end


%         tau = tau(use);
        gamma = gamma(use);
        time = time(use);
        tau = tau(use);
        
        
        
        
        if isempty(tau)
            continue;
        end
        time = time(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));
        gamma = gamma(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));
        tau = tau(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));
        
        if contains(file_name,'20mlBraunSyringe')
            taus_soft = [taus_soft,tau];
            gamma_soft = [gamma_soft,gamma];
        else
            taus_hard = [taus_hard,tau];
            gamma_hard = [gamma_hard,gamma];
        end
        
        
    end
    
    
 
end


% gamma_final = [];
% 
% gammas = gamma_soft;
% 
% use  = 2;
% gamma_example = gammas{use};
% 
% for k = 1:length(gammas)
% 
%     gamma = gammas{k};
%     
%     
% %    d = finddelay(gamma_example,gamma,50);
%     
%    shifts=  -50:50;
%    mii =zeros(1,length(shifts));
%     for shift_num = 1:length(shifts) 
% 
%         [gamma_tmp]=imshift([shifts(shift_num),0], 'replicate', gamma);
%         mii(shift_num) = MutualInformation(double(gamma_tmp),double(gamma_example));
%     end
%     
%     
%     [mi_max,pos] = max(mii);
%     d = shifts(pos);
%     
%     drawnow;
%    
% 
%    
%     
% %     R = corrcoef(gamma,gamma_example);
%     
%     hold off
%     plot(gamma_example);
%     hold on
%     plot(gamma);
%     title([num2str(mi_max) '   ' num2str(d)])
%     
%     
%     drawnow;
%     
%     gamma_final = [gamma_final,gamma]; 
% end



gamma_hard_final = cat(2,gamma_hard{:});
gamma_soft_final = cat(2,gamma_soft{:});

figure;
hold off
tmp = medfilt1(median(gamma_hard_final,2),13,'truncate');
plot(0:T_period:(length(tmp)-1)*T_period,tmp-min(tmp));
hold on
tmp = medfilt1(median(gamma_soft_final,2),13,'truncate');
plot(0:T_period:(length(tmp)-1)*T_period,tmp-min(tmp));
legend({'hard','soft'})
ylabel('\gamma (-)')
xlabel('t(s)')
print_png_eps_svg_fig('res/average_gamma_signal')




tau_hard_final = cat(2,taus_hard{:});
tau_soft_final = cat(2,taus_soft{:});

figure;
hold off
plot(0:T_period:(length(tmp)-1)*T_period,medfilt1(median(tau_hard_final,2),27,'truncate'));
hold on
plot(0:T_period:(length(tmp)-1)*T_period,medfilt1(median(tau_soft_final,2),27,'truncate'));
legend({'hard','soft'})
ylabel('\tau (Pa)')
xlabel('t(s)')
print_png_eps_svg_fig('res/average_tau_signal')

