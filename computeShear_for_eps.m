clear all;close all;clc;
addpath('utils')

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\results_for_eps';
% path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-10 - Shearstress PC3 calA ruzne dyny\results';
% path = 'G:\Sdílené disky\Quantitative GAČR\data\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results';

% time = datestr(datetime('now'),'mm_dd_yy__HH_MM');


path_save = [path '2'];
% path_save = [path '_with_eps'];

copyfile(path,path_save)


load([path '/1/1results.mat'],'opt')




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

%% execution
for fileNum = [1,2,7,8]
    
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
    
    [edgeTimes] = get_edges(flowmeterTimes,flowmeterValues,odd(sumWin/T_flow),minPeakHeight,peakDistance,inint_window,peakDistanceRangePer);
    
    edgeTimes(edgeTimes>(imageFrameTimes(end)-pksWin)) = [];
    
    numEdges = length(edgeTimes);
    imgEdgeIdx = zeros(1,numEdges);
    flowEdgeIdx = zeros(1,numEdges);
    for edgeNum = 1:numEdges
        [~,imgEdgeIdx(edgeNum)] = min(abs(imageFrameTimes-edgeTimes(edgeNum)));
        [~,flowEdgeIdx(edgeNum)] = min(abs(flowmeterTimes-edgeTimes(edgeNum)));
    end
    

    
    
    num_cells = length(cell_WCdiff);
    shears_all= cell(1,num_cells);
    dxs_all  = cell(1,num_cells);
    heights_all  = cell(1,num_cells);
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
        
 
        saveas(gcf,[path_save '/' num2str(opt.info.experiment(fileNum)) '/Cell'  num2str(cellNum)   'bg_signal_check.png'])
        close(gcf)
        
        cell_height = cell_Height{cellNum};
        
        WCextremaPoss = [];
        WCextremaVals = [];
        flowExtremaPoss = [];
        flowExtremaVals = [];
        shears_all{cellNum} = [];
        dxs_all{cellNum} = [];
        heights_all{cellNum} = [];
        
        last_edge=1;
        for edgeNum = 1:numEdges
            
            idx2 = flowEdgeIdx(edgeNum);
            idx = imgEdgeIdx(edgeNum);
            if (idx>length(WCdiff))||(idx2>length(flowmeterValues))
                continue
                
            end

            isMax = mod(edgeNum,2)==0;
            [WCextremaPos,WCextremaVal] = get_window_extrema(WCdiff,idx,round(pksWin/T_img),isMax);
            

            
            [flowExtremaPos,flowExtremaVal] = get_window_extrema(flowmeterValues,idx2,round(pksWin/T_flow),isMax);

            height_ = cell_height(WCextremaPos);
            
            
            shears_all{cellNum}(edgeNum) = (flowExtremaVal/12.98)*0.1; %to Pa
            dxs_all{cellNum}(edgeNum) = WCextremaVal/opt.px2mum;
            heights_all{cellNum}(edgeNum) = height_;
            
            
            WCextremaPoss(edgeNum) = WCextremaPos;
            WCextremaVals(edgeNum) = WCextremaVal;
            flowExtremaPoss(edgeNum) = flowExtremaPos;
            flowExtremaVals(edgeNum) = flowExtremaVal;
            
        end
        
        taus = diff(shears_all{cellNum}); 
        rcom = diff(dxs_all{cellNum}); 
        
        G_all{cellNum} = taus./rcom.*heights_all{cellNum}(1:end-1);
        
        
        
        numEdges_used_minus1 = length(G_all{cellNum});
        
        lams = nan(1,numEdges_used_minus1); % E/n
        As = nan(1,numEdges_used_minus1); % stress/E
        shifts_x = nan(1,numEdges_used_minus1);
        shifts_y = nan(1,numEdges_used_minus1);
        eqs = num2cell(nan(1,numEdges_used_minus1));
        xs = num2cell(nan(1,numEdges_used_minus1));
        Es = nan(1,numEdges_used_minus1);
        nis = nan(1,numEdges_used_minus1);
        hs = nan(1,numEdges_used_minus1);
        
        for edgeNum = 1:numEdges_used_minus1
            
            
            
            xdata = imageFrameTimes(WCextremaPoss(edgeNum):WCextremaPoss(edgeNum+1));
            shift_x = xdata(1);
            xdata = xdata - shift_x;
            
            h = heights_all{cellNum}(edgeNum);
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
            
            lams(edgeNum) = lam; % E/n
            As(edgeNum) = A;
            shifts_x(edgeNum) = shift_x;
            shifts_y(edgeNum) = shift_y;
            eqs{edgeNum} = eq;
            xs{edgeNum} = x;
            
            E = abs(taus(edgeNum))/A;
            Es(edgeNum)=E;
            ni = E/lam;
            nis(edgeNum)= ni;
            hs(edgeNum) = h;
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
%         saveas(gcf,[path_save '/' num2str(opt.info.experiment(fileNum)) '/Cell' num2str(cellNum) 'rCOM.png'])
        print_png_eps_svg_fig([path_save '/' num2str(opt.info.experiment(fileNum)) '/Cell' num2str(cellNum) 'rCOM'])
        close(gcf)
        
        
    end
        
    
    save([path_save '/' num2str(opt.info.experiment(fileNum)) '/results_G.mat'],'shears_all','dxs_all','heights_all','G_all','E_all','ni_all','optShear')
    
    
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
    

    
end





