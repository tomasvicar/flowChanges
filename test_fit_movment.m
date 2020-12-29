clear all;close all;clc;

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\';
path_save = [path 'results\'];
load([path 'results\1\1results.mat'],'opt')


dynThr = 10*12.98;
medSize = 101;
pksWin = 15;

optShear.dynThr = dynThr;
optShear.medSize = medSize;
optShear.pksWin = pksWin;

for fileNum = 1:height(opt.info)
    disp(num2str(fileNum))
    
    load([path 'results\' num2str(opt.info.experiment(fileNum)) '\' num2str(opt.info.experiment(fileNum)) 'results.mat'])
    
    
    
    for cellNum = 1:num_cells
        signal0 = cell_WCdiff{cellNum};
        
        signal = signal0;
        
        
        time = imageFrameTimes;
        
        
        
%         [bg] = bg_fit_iterative_polynom(time,signal);
        [bg] = bg_fit_iterative_gauss(signal);
        
        
        

        
        figure();
        plot(signal0);
        hold on
        plot(bg);
        plot(signal0-bg);
        
        
    end
    
    break 
    
end

