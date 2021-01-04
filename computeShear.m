clear all;close all;clc;
addpath('utils')

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\results';

time = datestr(datetime('now'),'mm_dd_yy__HH_MM');

path_save = [path '_bg'];

load([path '/1/1results.mat'],'opt')




%% options
minPeakHeight = 15*12.98;
minPeakDistance = 10;
medSize = 0.5;
sumWin = 0.1;
pksWin = 5;


optShear.minPeakHeight = minPeakHeight;
optShear.minPeakDistance = minPeakDistance;
optShear.medSize = medSize;
optShear.sumWin = sumWin;
optShear.pksWin = pksWin;

%% execution
for fileNum = 1:height(opt.info)
    
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
    
    [edgeTimes] = get_edges(flowmeterTimes,flowmeterValues,odd(sumWin/T_flow),minPeakHeight,minPeakDistance);
    
    
    numEdges = length(edgeTimes);
    imgEdgeIdx = zeros(1,numEdges);
    flowEdgeIdx = zeros(1,numEdges);
    for edgeNum = 1:numEdges
        [~,imgEdgeIdx(edgeNum)] = min(abs(imageFrameTimes-edgeTimes(edgeNum)));
        [~,flowEdgeIdx(edgeNum)] = min(abs(flowmeterTimes-edgeTimes(edgeNum)));
    end
    

    
    
    
    num_cells = length(cell_WCdiff);
    shears = cell(1,num_cells);
    dxs  = cell(1,num_cells);
    heights  = cell(1,num_cells);
    G_all = cell(1,num_cells);
    E_all = cell(1,num_cells);
    ni_all = cell(1,num_cells);
    
    for cellNum = 1:num_cells
        
        WCdiff0 = cell_WCdiff{cellNum} ;
        
        bg = bg_fit_iterative_gauss(WCdiff0);
        WCdiff = WCdiff0- bg;
        
        figure('Position',opt.figureSize);
        hold on
        plot(WCdiff0)
        plot(bg)
        plot(WCdiff)
        
 
        saveas(gcf,[path_save '/' num2str(fileNum) '/Cell'  num2str(cellNum)   'bg_signal_check.png'])
        close(gcf)
        
        cell_height = cell_Height{cellNum};
        
        WCextremaPoss = [];
        WCextremaVals = [];
        flowExtremaPoss = [];
        flowExtremaVals = [];
        
        for edgeNum = 1:numEdges
            
            idx2 = flowEdgeIdx(edgeNum);
            idx = imgEdgeIdx(edgeNum);
            if (idx>length(WCdiff))||(idx2>length(flowmeterValues))
                continue
                
            end

            isMax = mod(edgeNum,2)==0;
            [WCextremaPos,WCextremaVal] = get_window_extrema(WCdiff,idx,round(pksWin/T_img),isMax);
            
            
            [flowExtremaPos,flowExtremaVal] = get_window_extrema(flowmeterValues,idx2,round(pksWin/T_flow),isMax);

            height = cell_height(WCextremaPos);
            
            
            shears{cellNum}(edgeNum) = (flowExtremaVal/12.98)*0.1; %to Pa
            dxs{cellNum}(edgeNum) = WCextremaVal/opt.px2mum;
            heights{cellNum}(edgeNum) = height;
            
            
            WCextremaPoss(edgeNum) = WCextremaPos;
            WCextremaVals(edgeNum) = WCextremaVal;
            flowExtremaPoss(edgeNum) = flowExtremaPos;
            flowExtremaVals(edgeNum) = flowExtremaVal;
            
        end
        
        taus = diff(shears{cellNum}); 
        rcom = diff(dxs{cellNum}); 
        
        G_all{cellNum} = taus./rcom.*heights{cellNum}(1:end-1);
        
        
        lams = []; % E/n
        As = []; % stress/E
        shifts_x =[];
        shifts_y =[];
        eqs = {};
        xs = {};
        Es=[];
        nis=[];
        hs =[];
        for edgeNum = 1:numEdges-1
            
            
            
            xdata = imageFrameTimes(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1));
            shift_x = xdata(1);
            xdata = xdata - shift_x;
            
            h = heights{cellNum}(edgeNum);
            ydata = (WCdiff(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1))/opt.px2mum)/h;
            
            
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
            
            lams = [lams lam]; % E/n
            As = [As A];
            shifts_x =[shifts_x,shift_x];
            shifts_y =[shifts_y,shift_y];
            eqs = [eqs,eq];
            xs = [xs,x];
            
            E = abs(taus(edgeNum))/A;
            Es=[Es,E];
            ni = E/lam;
            nis=[nis,ni];
            hs = [hs h];
        end
        
        E_all{cellNum} = Es;
        ni_all{cellNum} = nis;        
        
        description = {['Exp' num2str(opt.info.experiment(fileNum)) ' '...
            opt.info.cell{fileNum} ' FOV' num2str(opt.info.fov(fileNum))],...
            replace(opt.info.folder{fileNum},'_',' ')};
        
        figure('Position',opt.figureSize);
        yyaxis left
        plot(flowmeterTimes,flowmeterValues)
        hold on
        plot(edgeTimes,minPeakHeight*ones(1,length(edgeTimes)),'ro')
        plot(flowmeterTimes(flowExtremaPoss),flowExtremaVals,'mo')
        ylabel('Flow (\mul/min)')
        ylim([-10 max(pumpFlowValues)+5*12.98])

        yyaxis right
        plot(imageFrameTimes(1:length(WCdiff)),WCdiff/opt.px2mum)
        hold on
        plot(imageFrameTimes(WCextremaPoss),WCextremaVals/opt.px2mum,'go')
        
        for edgeNum = 1:numEdges-1
            lam = lams(edgeNum); 
            A = As(edgeNum);
            shift_x = shifts_x(edgeNum);
            shift_y = shifts_y(edgeNum);
            eq = eqs{edgeNum};
            x = xs{edgeNum};
            h = hs(edgeNum);
            
            tmp = (eval(eq)+shift_y)*h;
            plot(x+shift_x,tmp ,'-','Color',[1 0.5 0])
            
            
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
        
    
    save([path_save '/' num2str(fileNum) '/results_G.mat'],'shears','dxs','heights','G','optShear')
    
    
    max_length = max(cellfun(@length,G));
    to_table = nan(max_length+1,num_cells);
    variable_names ={};
    for cellNum = 1:num_cells
        variable_names = [variable_names,['cell' num2str(cellNum)]];
        to_table(1:length(G{cellNum}),cellNum) = 1;
    end
    row_names = {};
    for k = 1:max_length
        row_names = [row_names,['value' num2str(k)]];
    end
    row_names = [row_names,'num_cells_in_cluster'];
    T = array2table(to_table,'VariableNames',variable_names,'RowNames',row_names);
    
    
    writetable(T,[path_save '/' num2str(fileNum) '/table_what_use_'  time  '.xlsx'],'WriteRowNames',true)
    

    
end





