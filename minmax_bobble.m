clc;clear all;close all force;
addpath('utils')

file_names = subdir('data_bubble/*_signals.mat');

% file_names = file_names([1,7]);

for file_num = 1:length(file_names)
    
    file_name = file_names(file_num).name
    
    data = load(file_name);
    
    Gs = [];
    nis = [];
    bs = {};
    
    for cellNum = 1:length(data.gammas)
        cellNum
        
        tau = data.taus{cellNum};
        gamma0 = data.gammas{cellNum};
        time = data.times{cellNum};
        T_period = data.optShear.T_period;
        edgePos = data.edgePos;
        
        
        bg = bg_fit_iterative_polynom(time,gamma0);
        gamma = gamma0- bg;

        WCextremaPoss = [];
        WCextremaVals = [];
        flowExtremaPoss = [];
        flowExtremaVals = [];
        shears_all{cellNum} = [];
        for edgeNum  = 1:min([7,length(edgePos)])
            
            idx2 = edgePos(edgeNum);
            idx = edgePos(edgeNum);
            
            pksWin = 5;
            isMax = mod(edgeNum,2)==0;
            [WCextremaPos,WCextremaVal] = get_window_extrema(gamma,idx,round(pksWin/T_period),isMax);
            [flowExtremaPos,flowExtremaVal] = get_window_extrema(tau,idx2,round(pksWin/T_period),isMax);
        
            
            
            shears_all{cellNum}(edgeNum) = flowExtremaVal;
            
            
            WCextremaPoss(edgeNum) = WCextremaPos;
            WCextremaVals(edgeNum) = WCextremaVal;
            flowExtremaPoss(edgeNum) = flowExtremaPos;
            flowExtremaVals(edgeNum) = flowExtremaVal;

        end
        taus = diff(shears_all{cellNum}); 
        
        GG = taus./diff(WCextremaVals); 
        
        
        GG = GG(1:min([6,length(GG)]));
        
        G = median(GG);
        ni = nan;
        
        b ='?';
        Gs = [Gs,G];
        nis = [nis,ni];
        bs = [bs,b];
        
    end
    
    
    
    
    save(replace(file_names(file_num).name,'_signals','_results_minmax'),'Gs','nis','bs')
    
end