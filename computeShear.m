clear all;close all;clc;
addpath('utils')


path = 'G:\Sdílené disky\Quantitative GAČR\data\21-01-28 - Shear stress 14h vs 1week PC3 untreated\results_1';


% path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\results';
% path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-10 - Shearstress PC3 calA ruzne dyny\results';
% path = 'G:\Sdílené disky\Quantitative GAČR\data\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results';

% time = datestr(datetime('now'),'mm_dd_yy__HH_MM');

% path_save = [path '_' time];


% copyfile(path,path_save)

mkdir('data_hard_soft_syringe')
load([path '/3/3results.mat'],'opt')




%% options
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


%% execution
for fileNum = [1:14 18:23]
    

    
    disp(num2str(fileNum))
    
    
    data = load([path '\' num2str(opt.info.experiment(fileNum)) '\' num2str(opt.info.experiment(fileNum)) 'results.mat']);
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
    
    
    time = (0:T_period:max_time)'; 
    

    tau = interp1(flowmeterTimes,flowmeterValues,time)/12.98*0.1; %to Pa;
    
    
    [edgePos] = get_edges(time,tau,odd(sumWin/T_period),minPeakHeight,peakDistance,inint_window,peakDistanceRangePer,T_period,pksWin);
    
    num_cells = length(cell_WCdiff);
    
    gammas = {};
    taus ={};
    times ={};
    
    for cellNum = 1:num_cells
        
        WCdiff = cell_WCdiff{cellNum} ;
        cell_height = cell_Height{cellNum};
        
        gamma = interp1(imageFrameTimes(1:length(WCdiff)),WCdiff,time)/opt.px2mum/median(cell_height);
        
        if sum(isnan(gamma))
            drawnow;
        end
        
        use = 1:find(~isnan(gamma),1,'last');
        gamma_cell = gamma(use);
        time_cell = time(use);
        tau_cell = tau(use);
        
        gammas = [gammas gamma_cell];
        taus = [taus tau_cell];
        times = [times time_cell];
        

        
    end
    
    
    save(['data_hard_soft_syringe/' opt.info.folder{fileNum}  '_signals.mat'],'optShear','gammas','taus','times','edgePos')    
    
    

end





