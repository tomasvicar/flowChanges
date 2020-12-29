clear all;close all;clc;
addpath('utils')

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\results';

path_save = path;

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
        continue
    end
    
    disp(num2str(fileNum))
    
    
    data = load([path '\' num2str(opt.info.experiment(fileNum)) '\' num2str(opt.info.experiment(fileNum)) 'results.mat']);
    flowmeterValues = data.flowmeterValues;
    flowmeterTimes = data.flowmeterTimes;
    cell_WCdiff = data.cell_WCdiff;
    cell_Height = data.cell_Height;
    imageFrameTimes = data.imageFrameTimes;
    
    
    T_flow = mean(abs(diff(flowmeterTimes)));
    T_img = mean(abs(diff(imageFrameTimes)));
    
    
    flowmeterValues = medfilt1(flowmeterValues,odd(medSize/T_flow));
    
    [edgeTimes] = get_edges(flowmeterTimes,flowmeterValues,odd(sumWin/T_flow),minPeakHeight,minPeakDistance);
    
    
    numEdges = length(edgeTimes);
    imgEdgeIdx = zeros(1,numEdges);
    for edgeNum = 1:numEdges
        [~,imgEdgeIdx(edgeNum)] = min(abs(imageFrameTimes-edgeTimes(edgeNum)));
    end
    

    
    
    
    num_cells = length(cell_WCdiff);
    shears = cell(1,num_cells);
    dxs  = cell(1,num_cells);
    heights  = cell(1,num_cells);
    for cellNum = 1:num_cells
        
        WCdiff0 = cell_WCdiff{cellNum} ;
        
        bg = bg_fit_iterative_gauss(WCdiff);
        WCdiff = WCdiff0 - bg;
        
        figure('Position',opt.figureSize);
        hold on
        plot(WCdiff0)
        plot(bg)
        plot(WCdiff)
 
        saveas([path_save '/' num2str(fileNum) '/Cell'  num2str(cellNum)   'bg_signal_check.png']
        
        cell_height = cell_Height{cellNum};
        
        for edgeNum = 1:numEdges
            
            idx = imgEdgeIdx(edgeNum);
            if idx>length(WCdiff)
                continue
                
            end

            isMax = mod(edgeNum,2)==0;
            [WCextremaPos,WCextremaVal] = get_window_extrema(WCdiff,idx,round(pksWin/T_img),isMax);
            
            [~,idx2] = min(abs(flowmeterTimes-imageFrameTimes(WCextremaPos)));
            
            [flowExtremaPos,flowExtremaVal] = get_window_extrema(flowmeterValues,idx2,round(pksWin/T_flow),isMax);

            height = cell_height(WCextremaPos);
            
            
            shears{cellNum}(edgeNum) = (flowExtremaVal/12.98)*0.1; %to Pa
            dxs{cellNum}(edgeNum) = WCextremaVal;
            heights{cellNum}(edgeNum) = height;
            
            
        end
    end
        
    G = cell(1,num_cells);
    for cellNum = 1:num_cells
        
        G{cellNum} = diff(shears{cellNum})./diff(shears{cellNum}).*heights{cellNum}(1:end-1);

    end
    
    save([path_save '/' num2str(fileNum) '/results_G.mat'],'shears','dxs','heights','G')
    
    
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
    
    
    writetable(T,[path_save '/' num2str(fileNum) '/table_what_use.xlsx'],'WriteRowNames',true)
    
    
    
     for cellNum = 1:num_cells
        description = {['Exp' num2str(opt.info.experiment(fileNum)) ' '...
                opt.info.cell{fileNum} ' FOV' num2str(opt.info.fov(fileNum))],...
                replace(opt.info.folder{fileNum},'_',' ')};

        figure('Position',opt.figureSize);
        yyaxis left
        plot(flowmeterTimes,flowFiltered)
        hold on
        plot(edgeFlowTimes,dynThr*ones(1,length(edgeFlowTimes)),'ro')
        ylabel('Flow (\mul/min)')
        ylim([-10 max(pumpFlowValues)+5*12.98])

        yyaxis right
        plot(imageFrameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff{cellNum}/opt.px2mum)
        hold on
        plot(imageFrameTimes(extremaPos{cellNum}),extremaValue{cellNum}/opt.px2mum,'go')

        title([['Flow/Centre Static Points - Cell ' num2str(cellNum)] description])
        xlabel('Time (sec)')
        ylabel('Centre Difference (\mum)')
        legend({'Pump Flow Filt.','Pulse Edges','Centre Diff.','rCOM Values'},'Location','northwest')
        set(gca,'FontSize',12)
        set(gca,'FontWeight','bold')
        saveas(gcf,[path_save num2str(opt.info.experiment(fileNum)) '\Cell' num2str(cellNum) 'rCOM.png'])
        close(gcf)
    end
    
    
    
    
end





