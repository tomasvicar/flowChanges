clear all;close all;clc;
addpath('utils')

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\tmp';
% path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-10 - Shearstress PC3 calA ruzne dyny\results';
% path = 'G:\Sdílené disky\Quantitative GAČR\data\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results';

% time = datestr(datetime('now'),'mm_dd_yy__HH_MM');

path_save = [path];
% path_save = [path '_with_eps'];

% copyfile(path,path_save)


load([path '/3/3results.mat'],'opt')




%% options
minPeakHeight = 7*12.98;
peakDistance = 20;
peakDistanceRangePer = 0.4;
medSize = 2;
sumWin = 1;
pksWin = 5;
inint_window = 70;


optShear.minPeakHeight = minPeakHeight;
optShear.peakDistance = peakDistance;
optShear.peakDistanceRangePer = peakDistanceRangePer;
optShear.medSize = medSize;
optShear.sumWin = sumWin;
optShear.pksWin = pksWin;
optShear.inint_window = inint_window;



index = 0;

%% execution
for fileNum = 1:3%:height(opt.info)
    
%     if opt.info.experiment(fileNum)==3 || opt.info.experiment(fileNum)==4 %%%%%%%%%%%%%%%%%%%%%!!!!!!!!!!!!
%         peakDistance = 10;
%         
%     else
%         peakDistance = 20;
%         
%     end
    
    
    
    if ~isfolder([path_save '/' num2str(fileNum)])
        mkdir([path_save '/' num2str(fileNum)])
    end
    
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
    T_img = mean(abs(diff(imageFrameTimes)));
    
    
    flowmeterValues = medfilt1(flowmeterValues,odd(medSize/T_flow));
    
    num_cells = length(cell_WCdiff);
    
    for cellNum = 1:num_cells
        
        index = index + 1;

        
        
        WCdiff0 = cell_WCdiff{cellNum} ;
        
        bg = bg_fit_iterative_gauss(WCdiff0);
        WCdiff = WCdiff0- bg;
        
        cell_height = cell_Height{cellNum};
        
    
        tau = flowmeterValues/12.98*0.1;
        tau_t = flowmeterTimes;
        
        gamma = WCdiff/opt.px2mum/median(cell_height);
        gamma_bg = WCdiff0/opt.px2mum/median(cell_height);
        gamma_t = imageFrameTimes;
        
        
        save(['real_data/data_' num2str(index) '.mat'],'tau','tau_t','gamma','gamma_bg','gamma_t')
        
        drawnow;
        
    
    end
    
end





