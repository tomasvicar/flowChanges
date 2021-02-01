clc;clear all;close all force;
addpath('utils')

file_names = subdir('data_hard_soft_syringe/*_signals.mat');

% file_names = file_names([1,7]);

for file_num = 11:length(file_names)
    
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
        
%         use = 1500:4100; % 5 Pa
%         tau = tau(use);
%         gamma = gamma(use);
%         time = time(use);
        
        tt_h = 0:T_period:40;
        tt_h = tt_h(:);
        ttt = time;
        
        order = 5;
        h = @(b,x) b(1)*b(2)*exp(-b(2)*x);
        
        pred = @(b) (custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*T_period+polyval(coeffvalues(fit(ttt,(gamma - custom_shift(conv(tau,h(b,tt_h), 'same' ),b(3))*T_period),['poly' num2str(order)],'Robust','LAR')),ttt));

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
            options = optimoptions('patternsearch','FunctionTolerance',0,'MaxIterations',250,'MeshTolerance',0,'StepTolerance',0,'MaxFunctionEvaluations',9999999,'UseParallel',true);
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
        mkdir('../results_polynom_whole')
        
        [filepath,name,ext] = fileparts(file_name);
        print(['../results_polynom_whole/' name num2str(cell_num,'%03.f')],'-dpng')
        
    end
    
    
    
    
    save(replace(file_names(file_num).name,'_signals','_results_polynom_whole'),'Gs','nis','bs')
    
end