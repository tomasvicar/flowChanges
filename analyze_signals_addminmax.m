clear all;close all;clc;
addpath('utils')


% data_folder = 'Z:\999992-nanobiomed\Holograf\data_shear_stress_2021';
data_folder = 'G:\Sdílené disky\Quantitative GAČR\data\data_shear_stress_2021';


paths = {};
infos = {};
flow_folders = {};


path = [data_folder '\21-02-04 - Shearstress 22Rv1 + PC3-50rez 48h\'];
info = readtable([path 'info_04_02_21.xlsx']);
flow_folder = [path 'exp_04_02_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\21-01-28 - Shear stress 14h vs 1week PC3 untreated\'];
info = readtable([path 'info_28_01_21.xlsx']);
flow_folder = [path 'exp_28_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];



path =  [data_folder '\21-01-26 - Shearstress 24h-4h PC3\'];
info = readtable([path 'info_26_01_21.xlsx']);
flow_folder = [path 'exp_26_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\21-02-05 - Shearstress PC3 docetax 200nM 24h cytD 1uM\'];
info = readtable([path 'info_05_02_21.xlsx']);
flow_folder = [path 'exp_05_02_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\'];
info = readtable([path 'info_29_01_21.xlsx']);
flow_folder = [path 'exp_29_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = [data_folder '\21-01-27 - Shear stress vzestupny 22Rv1 PC3\'];
info = readtable([path 'info_27_01_21.xlsx']);
flow_folder = [path 'exp_27_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\20-12-10 - Shearstress PC3 calA ruzne dyny\'];
info = readtable([path 'info_10_12_20.xlsx']);
flow_folder = [path 'exp_10_12_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = [data_folder '\20-12-18 PC3 vs 22Rv1_4days_post_seeding\'];
info = readtable([path 'info_18_12_20.xlsx']);
flow_folder = [path 'exp_18_12_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = [data_folder '\20-11-19 - Shearstress PC3 various dyn time\'];
info = readtable([path 'info_19_11_20.xlsx']);
flow_folder = [path 'exp_19_11_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];




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
         

        if (peakDistance>max(time_all))  %%problem for short signals
            edgePos = [];
        else
            if isempty(time_all)
                edgePos = [];
            else
                [edgePos] = get_edges(time_all,tau_signal_all,odd(sumWin/T_period),minPeakHeight,peakDistance,...
                    inint_window,peakDistanceRangePer,T_period,pksWin);
            end
        end
        num_cells = length(cell_WCdiff);
        
        gamma_signals = {};
        tau_signals ={};
        times ={};
        
        
        taus_all= cell(1,num_cells);
        hs_all  = cell(1,num_cells);
        Gs_all = cell(1,num_cells);
        etas_all = cell(1,num_cells);
        Gs_minmax_all = cell(1,num_cells);
        edgePos_cells = cell(1,num_cells);
        
        for cellNum = 1:num_cells
            
            WCdiff = cell_WCdiff{cellNum} ;
            cell_height = cell_Height{cellNum};
            
            gamma_signal_tmp = interp1(imageFrameTimes(1:length(WCdiff)),WCdiff,time_all)/opt.px2mum/median(cell_height);
            
            
            use = 1:find(~isnan(gamma_signal_tmp),1,'last');
            gamma_signal = gamma_signal_tmp(use);
            time = time_all(use);
            tau_signal = tau_signal_all(use);
            pump_signal = pump_signal_all(use);
            
            edgePos_cell = edgePos;
            edgePos_cell(edgePos_cell>length(time)) = [];
            
            gamma_signals = [gamma_signals gamma_signal];
            tau_signals = [tau_signals tau_signal];
            times = [times time];
            edgePos_cells = [edgePos_cells edgePos_cell];
            
            
            gamma_signal0 = gamma_signal;
            if length(time)>20 %%problem for short signals
                bg = bg_fit_iterative_polynom(time,gamma_signal0);
            else
                bg = zeros(size(gamma_signal0));
            end
            gamma_signal = gamma_signal0 - bg;
            

            WCextremaPoss = [];
            WCextremaVals = [];
            flowExtremaPoss = [];
            flowExtremaVals = [];
            
            for edgeNum  = 1:length(edgePos_cell)
            
                
                idx = edgePos_cell(edgeNum);
                if (idx>length(gamma_signal))||(idx>length(tau_signal))
                    continue
                end

                isMax = mod(edgeNum,2)==0;
                [WCextremaPos,WCextremaVal] = get_window_extrema(gamma_signal,idx,round(pksWin/T_period),isMax);
                [flowExtremaPos,flowExtremaVal] = get_window_extrema(tau_signal,idx,round(pksWin/T_period),isMax);


                WCextremaPoss(edgeNum) = WCextremaPos;
                WCextremaVals(edgeNum) = WCextremaVal;
                flowExtremaPoss(edgeNum) = flowExtremaPos;
                flowExtremaVals(edgeNum) = flowExtremaVal;
            
            end
            
            taus = diff(flowExtremaVals); 
            dif_gamma = diff(WCextremaVals);
            
            Gs_minmax = (taus./dif_gamma);
            

            
            
            
            Gs_minmax_all{cellNum} = Gs_minmax;
            
            
            

        end

        save([ path_save '/' info.folder{fileNum} '/fit_params2.mat'],'Gs_minmax_all')

        drawnow;
    end
end