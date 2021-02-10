clc;clear all;close all force;
addpath('utils')

file_names = subdir('data_hard_soft_syringe/*_signals.mat');

% file_names = file_names([1,7]);

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
        
        
        use = (65)/T_period:(65+8*20)/T_period; % 5 Pa
%         use = (65+5*20)/T_period:(65+14*20)/T_period; % 10 Pa
        use(use>length(tau)) = [];
%         tau = tau(use);
        gamma = gamma(use);
        time = time(use);
        if isempty(tau)
            continue;
        end
        time = time(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));
        gamma = gamma(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));
        
        
        
        
        ttt = time;
        
        order = 5;
        h = @(b,x) b(1)*b(2)*exp(-b(2)*x);
        
        pred = @(b) (conv(crop_sig(custom_shift(tau,b(3)),use),h(b,tt_h), 'valid' )*T_period+polyval(coeffvalues(fit(ttt,(gamma - conv(crop_sig(custom_shift(tau,b(3)),use),h(b,tt_h), 'valid' )*T_period),['poly' num2str(order)],'Robust','LAR')),ttt));
%         pred = @(b) (custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*T_period+polyval(coeffvalues(fit(ttt,(gamma - custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*T_period),['poly' num2str(order)],'Robust','LAR')),ttt));
        
        nrmrsd  = @(b) double(norm(gamma - pred(b) , 1) );
        
        B0 = [0.0139    0.4582  17/T_period];
        lb = [0.001 0.01 10/T_period];
        ub = [0.1 5 30/T_period];

        Aneq = [];
        bneq = [];
        Aeq = [];
        beq = [];
        nonlcon = [];



        bss={};
        fvals = [];
        alg = {};
        iter = [];
        iters = 1 ;
        for k = 1:iters
            tic
%             'PlotFcn','psplotbestf'
            options = optimoptions('patternsearch','FunctionTolerance',0,'MaxIterations',200,'MeshTolerance',0,'StepTolerance',0,'MaxFunctionEvaluations',9999999,'UseParallel',true);
            [b,fval] = patternsearch(nrmrsd,B0,Aneq,bneq,Aeq,beq,lb,ub,nonlcon,options);
            bss=[bss,b];
            fvals = [fvals,fval];
            alg = [alg,'ps'];
            iter = [iter,k];
            toc


%             options = optimoptions('particleswarm','FunctionTolerance',0,'MaxIterations',100,'MaxStallIterations',999999,'PlotFcn','pswplotbestf','UseParallel',true);
%             [bb,fval] = particleswarm(nrmrsd,length(B0),lb,ub,options);
%             bss=[bss,bb];
%             fvals = [fvals,fval];
%             alg = [alg,'psw'];
%             iter = [iter,k];
%             toc
            
            
        end
        [~,tmp] = min(fvals);
        b = bss{tmp};
        
        
        G = 1/b(1);
        ni = G/b(2);
        
        Gs = [Gs,G];
        nis = [nis,ni];
        bs = [bs,b];
        
        
        close all force;
        hold off;
        title([num2str(G) '   ' num2str(ni)])
        hold on;
        plot(gamma)
        tmp = pred(b);
        plot(tmp)
        drawnow;
        mkdir('../results_polynom_5Pa')
        
        [filepath,name,ext] = fileparts(file_name);
        print(['../results_polynom_5Pa/' name num2str(cell_num,'%03.f')],'-dpng')
        
        
        figure();
        hold on;
        plot(gamma)
        plot(polyval(coeffvalues(fit(ttt,(gamma - conv(crop_sig(custom_shift(tau,b(3)),use),h(b,tt_h), 'valid' )*T_period),['poly' num2str(order)],'Robust','LAR')),ttt))
        
        drawnow;
    end
    
    
    
    
    save(replace(file_names(file_num).name,'_signals','_results_polynom_5Pa'),'Gs','nis','bs')
    
end