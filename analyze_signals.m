clear all;close all;clc;
addpath('utils')


% data_folder = 'Z:\999992-nanobiomed\Holograf\data_shear_stress_2021';
data_folder = 'G:\Sdílené disky\Quantitative GAČR\data';


paths = {};
infos = {};
flow_folders = {};


path = [data_folder '\21-02-04 - Shearstress 22Rv1 + PC3-50rez 48h\'];
info = readtable([path 'info_04_02_21.xlsx']);
flow_folder = [path 'exp_04_02_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

%
% path = [data_folder '\21-01-28 - Shear stress 14h vs 1week PC3 untreated\'];
% info = readtable([path 'info_28_01_21.xlsx']);
% flow_folder = [path 'exp_28_01_21'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];
%
%
%
% path =  [data_folder '\21-01-26 - Shearstress 24h-4h PC3\'];
% info = readtable([path 'info_26_01_21.xlsx']);
% flow_folder = [path 'exp_26_01_21'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];
%
%
% path = [data_folder '\21-02-05 - Shearstress PC3 docetax 200nM 24h cytD 1uM\'];
% info = readtable([path 'info_05_02_21.xlsx']);
% flow_folder = [path 'exp_05_02_21'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];
%
%
% path = [data_folder '\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\'];
% info = readtable([path 'info_29_01_21.xlsx']);
% flow_folder = [path 'exp_29_01_21'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];
%
% path = [data_folder '\21-01-27 - Shear stress vzestupny 22Rv1 PC3\'];
% info = readtable([path 'info_27_01_21.xlsx']);
% flow_folder = [path 'exp_27_01_21'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];
%
%
% path = [data_folder '\20-12-10 - Shearstress PC3 calA ruzne dyny\'];
% info = readtable([path 'info_10_12_20.xlsx']);
% flow_folder = [path 'exp_10_12_20'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];
%
% path = [data_folder '\20-12-18 PC3 vs 22Rv1_4days_post_seeding\'];
% info = readtable([path 'info_18_12_20.xlsx']);
% flow_folder = [path 'exp_18_12_20'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];
%
% path = [data_folder '\20-11-19 - Shearstress PC3 various dyn time\'];
% info = readtable([path 'info_19_11_20.xlsx']);
% flow_folder = [path 'exp_19_11_20'];
%
% paths =[paths path];
% infos = [infos {info}];
% flow_folders = [flow_folders flow_folder];




minPeakHeight = 7*0.1;
peakDistance = 20;
peakDistanceRangePer = 0.4;
medSize = 2;
sumWin = 1;
pksWin = 5;
inint_window = 70;
T_period = 0.05;


optShear.minPeakHeight = minPeakHeight;
optShear.peakDistance = peakDistance;
optShear.peakDistanceRangePer = peakDistanceRangePer;
optShear.medSize = medSize;
optShear.sumWin = sumWin;
optShear.pksWin = pksWin;
optShear.inint_window = inint_window;
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
        
        
        T_flow = mean(abs(diff(flowmeterTimes)));
        
        flowmeterValues = medfilt1(flowmeterValues,odd(medSize/T_flow));
        
        
        max_time = min([flowmeterTimes(end),imageFrameTimes(end)]);
        
        
        time_all = (0:T_period:max_time)';
        
        
        tau_signal_all = interp1(flowmeterTimes,flowmeterValues,time_all)/12.98*0.1; %to Pa;
        
        
        pump_signal_all = interp1(pumpFlowTimes,pumpFlowValues,time_all)/12.98*0.1; %to Pa;
         

        
        [edgePos] = get_edges(time_all,tau_signal_all,odd(sumWin/T_period),minPeakHeight,peakDistance,inint_window,peakDistanceRangePer,T_period,pksWin);
        
        num_cells = length(cell_WCdiff);
        
        gamma_signals = {};
        tau_signals ={};
        times ={};
        
        
        taus_all= cell(1,num_cells);
        hs_all  = cell(1,num_cells);
        Gs_all = cell(1,num_cells);
        etas_all = cell(1,num_cells);
        
        for cellNum = 1:num_cells
            
            WCdiff = cell_WCdiff{cellNum} ;
            cell_height = cell_Height{cellNum};
            
            gamma_signal_tmp = interp1(imageFrameTimes(1:length(WCdiff)),WCdiff,time_all)/opt.px2mum/median(cell_height);
            
            if sum(isnan(gamma_signal_tmp))
                drawnow;
            end
            
            use = 1:find(~isnan(gamma_signal_tmp),1,'last');
            gamma_signal = gamma_signal_tmp(use);
            time = time_all(use);
            tau_signal = tau_signal_all(use);
            pump_signal = pump_signal_all(use);
            
            gamma_signals = [gamma_signals gamma_signal];
            tau_signals = [tau_signals tau_signal];
            times = [times time];
            
            
            
            gamma_signal0 = gamma_signal;
            bg = bg_fit_iterative_polynom(time,gamma_signal0);
            gamma_signal = gamma_signal0 - bg;
            

            WCextremaPoss = [];
            WCextremaVals = [];
            flowExtremaPoss = [];
            flowExtremaVals = [];
            
            for edgeNum  = 1:length(edgePos)
            
                
                idx = edgePos(edgeNum);

                isMax = mod(edgeNum,2)==0;
                [WCextremaPos,WCextremaVal] = get_window_extrema(gamma_signal,idx,round(pksWin/T_period),isMax);
                [flowExtremaPos,flowExtremaVal] = get_window_extrema(tau_signal,idx,round(pksWin/T_period),isMax);


                WCextremaPoss(edgeNum) = WCextremaPos;
                WCextremaVals(edgeNum) = WCextremaVal;
                flowExtremaPoss(edgeNum) = flowExtremaPos;
                flowExtremaVals(edgeNum) = flowExtremaVal;
            
            end
            
            taus = diff(flowExtremaVals); 
            
            
            Gs = [];
            etas = [];
            params1 = {};
            params2 = {};
            
            for edgeNum  = 1:length(edgePos)-1
                xdata = time(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1));
                shift_x = xdata(1);
                xdata = xdata - shift_x;

                ydata = gamma_signal(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1));

                if mod(edgeNum,2)
                    eq = @(A,lam,shift_y,x) A*(1-exp(-lam*x))+shift_y;
                else
                    eq = @(A,lam,shift_y,x) A*exp(-lam*x)+shift_y;
                end

                fo = fitoptions('Method','NonlinearLeastSquares',...
                   'Robust','Bisquare',...
                   'Lower',[0,0,0],...
                   'Upper',[Inf,Inf,Inf],...
                   'StartPoint',[1 1 1]);
                ft = fittype(eq,'options',fo,'coefficients',{'A','lam','shift_y'});
                f = fit( xdata, ydata, ft);


                x = xdata;
                A = f.A;
                lam = f.lam;
                shift_y = f.shift_y;
                
                para2 = struct(); 
                para2.shift_y = shift_y;
                para2.eq = eq;
                
                params1 = [params1,f];
                params2 = [params2,para2];

                G = abs(taus(edgeNum))/A;
                
                
                Gs = [Gs,G];
                etas = [etas, G/lam];
            
            
            end
            
            
            taus_all{cellNum} = taus;
            hs_all{cellNum}  = median(cell_height);
            Gs_all{cellNum} = Gs ;
            etas_all{cellNum} = etas;
            
            
            
            
            description = {['Exp' num2str(opt.info.experiment(fileNum)) ' '...
                opt.info.cell{fileNum} ' FOV' num2str(opt.info.fov(fileNum))],...
                replace(opt.info.folder{fileNum},'_',' ')};

            
            
            figure('Position',opt.figureSize);
            yyaxis left
            plot(time,tau_signal)
            hold on
            plot(time(edgePos),tau_signal(edgePos),'ro')
            plot(time(flowExtremaPoss),tau_signal(flowExtremaPoss),'mo')
            
            ylabel('Shear stress (Pa)')
            ylim([-1 max(pump_signal)+2])

            yyaxis right
            plot(time,gamma_signal)
            hold on
            plot(time(WCextremaPoss),gamma_signal(WCextremaPoss),'go')

            drawnow;
            
            
            for edgeNum = 1:numEdges_used_minus1
                lam = lams(edgeNum); 
                A = As(edgeNum);
                shift_x = shifts_x(edgeNum);
                shift_y = shifts_y(edgeNum);
                eq = eqs{edgeNum};
                x = xs{edgeNum};
                h = hs(edgeNum);

                if ~isnan(eq)
                    tmp = (eval(eq)+shift_y)*h;
                    plot(x+shift_x,tmp ,'-','Color',[1 0.5 0])
                end

            end




            text( imageFrameTimes(WCextremaPoss(1:end-1))' + diff(imageFrameTimes(WCextremaPoss))'/3 ,...
                 WCextremaVals(1:end-1)/opt.px2mum + diff(WCextremaVals/opt.px2mum)/2,...
                 strsplit(num2str(G_all{cellNum},'%66666.1f')))

            text( imageFrameTimes(WCextremaPoss(1:end-1))' + diff(imageFrameTimes(WCextremaPoss))'/3 ,...
                 WCextremaVals(1:end-1)/opt.px2mum + diff(WCextremaVals/opt.px2mum)/4*3,...
                 strsplit(num2str(E_all{cellNum},'%66666.1f')),'Color',[1 .5 0])

            text( imageFrameTimes(WCextremaPoss(1:end-1))' + diff(imageFrameTimes(WCextremaPoss))'/3 ,...
                 WCextremaVals(1:end-1)/opt.px2mum + diff(WCextremaVals/opt.px2mum)/4,...
                 strsplit(num2str(1:length(G_all{cellNum}),'%66666.1f')),'Color','red')

            title([['Flow/Centre Static Points - Cell ' num2str(cellNum)] description])
            xlabel('Time (sec)')
            ylabel('Centre Difference (\mum)')
            legend({'Pump Flow','Pulse Edges','Pulse Extrema','Centre Diff.','Centre Diff. Extrema.'},'Location','northwest')
            set(gca,'FontSize',12)
            set(gca,'FontWeight','bold')
    %         saveas(gcf,[path_save '/' num2str(opt.info.experiment(fileNum)) '/Cell' num2str(cellNum) 'rCOM.eps'],'epsc')
            saveas(gcf,[path_save '/' num2str(opt.info.experiment(fileNum)) '/Cell' num2str(cellNum) 'rCOM.png'])
            close(gcf)


        end


        max_length = max(cellfun(@length,G_all));
        to_table = nan(max_length+1,num_cells);
        variable_names ={};
        for cellNum = 1:num_cells
            variable_names = [variable_names,['cell' num2str(cellNum)]];
            to_table(1:length(G_all{cellNum}),cellNum) = 1;
        end
        row_names = {};
        for k = 1:max_length
            row_names = [row_names,['value' num2str(k)]];
        end
        row_names = [row_names,'num_cells_in_cluster'];
        T = array2table(to_table,'VariableNames',variable_names,'RowNames',row_names);


        writetable(T,[path_save '/' num2str(opt.info.experiment(fileNum)) '/table_what_use.xlsx'],'WriteRowNames',true)
        
        save([ path_save '/' info.folder{fileNum} '/signals.mat'],'optShear','gamma_signals','tau_signals','times','edgePos')
        
        save([ path_save '/' info.folder{fileNum} '/fit_params.mat'],'taus_all','hs_all','Gs_all','etas_all','optShear')
    
        break
    end
    break
end