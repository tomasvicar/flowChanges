clear all;close all;clc;
addpath('utils')



data_folder = 'Z:\999992-nanobiomed\Holograf\21-03-12 - Shearstress';



paths = {};
infos = {};
flow_folders = {};



path = [data_folder '\for_export\'];
info = readtable([path 'for_export.xlsx']);
flow_folder = [path 'exp_for_export'];



paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];





start = 15;
stop = 260;
T_period = 0.05;
medSize = 2;

optShear.medSize = medSize;
optShear.start = start;
optShear.stop = stop;
optShear.T_period = T_period;




for main_folder_num = 1:length(paths)
    
    path =paths{main_folder_num};
    info = infos{main_folder_num};
    flow_folder = flow_folders{main_folder_num} ;
    
    
    
    tmp = dir([path 'results_1']);
    tmp = tmp(3).name;
    load([path 'results_1/' tmp '/results.mat'],'opt')
    
    
    path_load = [path 'results_1'];
    path_save = [path 'results_2'];
    
    
    
    
    
    if ~exist(path_save, 'dir')
        copyfile(path_load,path_save)
    end
    
    
    for fileNum = 1:height(opt.info)
        
        disp(num2str(fileNum))
        
        
        data = load([path_save '/' info.folder{fileNum} '\results.mat']);
        flowmeterValues = data.flowmeterValues;
        flowmeterTimes = data.flowmeterTimes;
        cell_WCdiff = data.cell_WCdiff;
        cell_Height = data.cell_Height;
        imageFrameTimes = data.imageFrameTimes;
        pumpFlowTimes = data.pumpFlowTimes;
        pumpFlowValues = data.pumpFlowValues;
        
        if fileNum==22%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            flowmeterTimes(flowmeterTimes<0) = 299.2495 + 9.8554 + flowmeterTimes(flowmeterTimes<0) +0.005;
        end
        T_flow = mean(abs(diff(flowmeterTimes)));
        
        flowmeterValues = medfilt1(flowmeterValues,odd(medSize/T_flow));
        
        
        max_time = min([flowmeterTimes(end),imageFrameTimes(end)]);
        
        
        time_all = (0:T_period:max_time)';
        
        
        tau_signal_all = interp1(flowmeterTimes,flowmeterValues,time_all)/12.98*0.1; %to Pa;
        
        
        pump_signal_all = interp1(pumpFlowTimes,pumpFlowValues,time_all)/12.98*0.1; %to Pa;
         
        
        num_cells = length(cell_WCdiff);
        
        gamma_signals = cell(1,num_cells);
        tau_signals = cell(1,num_cells);
        times = cell(1,num_cells);
        
        gamma_signals_orig = cell(1,num_cells);
        tau_signals_orig  = cell(1,num_cells);
        times_orig = cell(1,num_cells);
        
        taus = nan(1,num_cells);
        hs  = nan(1,num_cells);
        Gs = nan(1,num_cells);
        etas = nan(1,num_cells);
        
        polynoms = cell(1,num_cells);
        
        use_vector = zeros(1,num_cells);

        
        for cellNum = 1:num_cells
            
            

                WCdiff = cell_WCdiff{cellNum} ;
                cell_height = cell_Height{cellNum};

                gamma_signal_tmp = interp1(imageFrameTimes(1:length(WCdiff)),WCdiff,time_all)/opt.px2mum/median(cell_height);
                
                gamma_signals_orig{cellNum} = gamma_signal_tmp;
                tau_signals_orig{cellNum}  = tau_signal_all;
                times_orig{cellNum} = time_all;

                use = time_all>start & time_all<stop;
                gamma_signal = gamma_signal_tmp(use);
                time = time_all(use);
    %             tau_signal = tau_signal_all(use);
                pump_signal = pump_signal_all(use);

            if ~isempty(gamma_signal)
                if any(isnan(gamma_signal))||find(use,1,'last')>length(tau_signal_all)||max(time_all(:))<(stop-10)
                   
                    use_vector(cellNum) = 0;
                else
                   
                   use_vector(cellNum) = 1;
                end
                
            else
                use_vector(cellNum) = 0;
            end
                
            try
                gamma_signals{cellNum} = gamma_signal;
                tau_signals{cellNum} = tau_signal_all(use);
                times{cellNum} = time;


                tt_h = 0:T_period:50;
                tt_h = tt_h(:);

                ttt = time(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));
                gamma = gamma_signal(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));
                tau =  tau_signal_all;

                order = 3;
                h = @(b,x) b(1)*b(2)*exp(-b(2)*x);

                pred = @(b) (conv(crop_sig(custom_shift(tau,b(3)),use),h(b,tt_h), 'valid' )*T_period+polyval(coeffvalues(fit(ttt,(gamma - conv(crop_sig(custom_shift(tau,b(3)),use),h(b,tt_h), 'valid' )*T_period),['poly' num2str(order)],'Robust','LAR')),ttt));

                nrmrsd  = @(b) double(norm(gamma - pred(b) , 1) );

                B0 = [0.0139    0.4582  17/T_period];
                lb = [0.0005 0.005 10/T_period];
                ub = [2 25 30/T_period];

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
                    options = optimoptions('patternsearch','FunctionTolerance',0,'MaxIterations',175,'MeshTolerance',0,'StepTolerance',0,'MaxFunctionEvaluations',9999999,'UseParallel',true');
                    [b,fval] = patternsearch(nrmrsd,B0,Aneq,bneq,Aeq,beq,lb,ub,nonlcon,options);
                    bss=[bss,b];
                    fvals = [fvals,fval];
                    alg = [alg,'ps'];
                    iter = [iter,k];
                    toc



                end
                [~,tmp] = min(fvals);
                b = bss{tmp};

                G = 1/b(1);
                eta = G/b(2);

                hs(cellNum) = median(cell_height);
                Gs(cellNum) = G;
                etas(cellNum) = eta;
                
                

                close all force;
                hold off;
                title(['Cell' num2str(cellNum) '   '  num2str(G) '   ' num2str(eta)])
                hold on;
                tmp = pred(b);
                plot(0:T_period:(length(tmp)-1)*T_period,gamma)
                plot(0:T_period:(length(tmp)-1)*T_period,tmp)
                plot(0:T_period:(length(tmp)-1)*T_period,polyval(coeffvalues(fit(ttt,(gamma - conv(crop_sig(custom_shift(tau,b(3)),use),h(b,tt_h), 'valid' )*T_period),['poly' num2str(order)],'Robust','LAR')),ttt))
                drawnow;
                saveas(gcf,[path_save '/'  info.folder{fileNum} '/Cell' num2str(cellNum) '_fit.png'])
                saveas(gcf,[path_save '/'  info.folder{fileNum} '/Cell' num2str(cellNum) '_fit.fig'])
                saveas(gcf,[path_save '/'  info.folder{fileNum} '/Cell' num2str(cellNum) '_fit','epsc'])
                close(gcf)


                figure();
                yyaxis left
                tmp = tau;
                plot(time_all,tmp)
                yyaxis right
                polynom = polyval(coeffvalues(fit(ttt,(gamma - conv(crop_sig(custom_shift(tau,b(3)),use),h(b,tt_h), 'valid' )*T_period),['poly' num2str(order)],'Robust','LAR')),ttt);
                polynoms{cellNum} = polynom;
                tmp = gamma-polynom;
                plot(ttt,tmp)  
                hold on;
                tmp = pred(b)-polynom;
                plot(ttt,tmp,'-r')  
                title(['Cell' num2str(cellNum) '   '  num2str(G) '   ' num2str(eta)])
                drawnow;

                saveas(gcf,[path_save '/'  info.folder{fileNum} '/Cell' num2str(cellNum) '_fit2.png'])
                saveas(gcf,[path_save '/'  info.folder{fileNum} '/Cell' num2str(cellNum) '_fit2','epsc'])
                saveas(gcf,[path_save '/'  info.folder{fileNum} '/Cell' num2str(cellNum) '_fit2.fig'])
                    
                close(gcf)
            catch EM
               disp('error')
               use_vector(cellNum) = 0;
               save([path_save '/'  info.folder{fileNum} '/Cell' num2str(cellNum) 'error.mat'])
                
            end
            drawnow;
        end
        
        
        to_table = [use_vector;-1*ones(size(use_vector))];
        variable_names ={};
        for cellNum = 1:num_cells
            variable_names = [variable_names,['cell' num2str(cellNum)]];
        end
        
        if isempty(to_table)
            T = table();
        else
            T = array2table(to_table,'VariableNames',variable_names,'RowNames',{'use','num_cells'});
        end
        
        writetable(T,[path_save '/' info.folder{fileNum} '/table_what_use.xlsx'],'WriteRowNames',true)
        
        gamma_signals_orig{cellNum} = gamma_signal_tmp;
                tau_signals_orig{cellNum}  = tau_signal_all;
                times_orig{cellNum} = time_all;
        
        save([ path_save '/' info.folder{fileNum} '/signals.mat'],'gamma_signals','tau_signals','times','polynoms',...
            'gamma_signals_orig','tau_signals_orig','times_orig')
        
        save([ path_save '/' info.folder{fileNum} '/fit_params.mat'],'hs','Gs','etas','optShear')
        
        
        
    end
end