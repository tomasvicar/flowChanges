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
        
            drawnow;
            
            shears_all{cellNum}(edgeNum) = flowExtremaVal;
            WCextremaPoss(edgeNum) = WCextremaPos;
            WCextremaVals(edgeNum) = WCextremaVal;
            flowExtremaPoss(edgeNum) = flowExtremaPos;
            flowExtremaVals(edgeNum) = flowExtremaVal;

        end
        taus = diff(shears_all{cellNum}); 
        
        GG = [];
        nini = [];
        
        for edgeNum  = 1:min([6,length(edgePos)-1])
            
            xdata = time(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1));
            shift_x = xdata(1);
            xdata = xdata - shift_x;
            
            ydata = gamma(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1));
        
            if mod(edgeNum,2)
                eq = 'A*(1-exp(-lam*x))';
                shift_y = ydata(1);
            else
                eq = 'A*exp(-lam*x)';
                shift_y = ydata(end);
            end
            ydata = ydata - shift_y;
            
            fo = fitoptions('Method','NonlinearLeastSquares',...
               'Robust','Bisquare',...
               'Lower',[0,0],...
               'Upper',[Inf,Inf],...
               'StartPoint',[1 1]);
            ft = fittype(eq,'options',fo,'coefficients',{'A','lam'});
            f = fit( xdata, ydata, ft);
            

            x = xdata;
            A = f.A;
            lam = f.lam;
            
            E = abs(taus(edgeNum))/A;
            GG = [GG,E];
            nini = [nini, E/lam];
            
        end
        
        G = median(GG);
        ni = median(nini);
        
        b ='?';
        Gs = [Gs,G];
        nis = [nis,ni];
        bs = [bs,b];
        
    end
    
    
    
    
    save(replace(file_names(file_num).name,'_signals','_results_fit'),'Gs','nis','bs')
    
end