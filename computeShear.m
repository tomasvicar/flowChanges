clear all
close all
clc

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\';
path_save = [path 'results_tmp/'];


load([path 'results\1\1results.mat'],'opt')

%% options
dynThr = 10*12.98;
medSize = 101;
pksWin = 15;

optShear.dynThr = dynThr;
optShear.medSize = medSize;
optShear.pksWin = pksWin;

%% execution
for fileNum = 1:height(opt.info)
    disp(num2str(fileNum))
    
    if ~isfolder([path_save num2str(fileNum)])
         mkdir([path_save  num2str(fileNum)])
    end
    
    load([path 'results\' num2str(opt.info.experiment(fileNum)) '\' num2str(opt.info.experiment(fileNum)) 'results.mat'])
    
    flowFiltered = medfilt1(flowmeterValues,medSize);

    edgeFlowSamples = find(diff(flowFiltered>dynThr)~=0)';
    edgeFlowTimes = flowmeterTimes(edgeFlowSamples);
    numEdges = length(edgeFlowTimes);
    edgeFlowDirections = repmat([1 -1],[1,numEdges/2]);

    idx = zeros(1,numEdges);
    for edgeNum = 1:numEdges
        [~,idx(edgeNum)] = min(abs(imageFrameTimes-edgeFlowTimes(edgeNum)));
    end

    
    for cellNum = 1:num_cells
        cell_WCdiff{cellNum} = cell_WCdiff{cellNum} - bg_fit_iterative_gauss(cell_WCdiff{cellNum});
    end
    
    meanG = nan(1,num_cells);
    stdG = nan(1,num_cells);
    G = cell(1,num_cells);
    extremaValue = cell(1,num_cells);
    extremaPos = cell(1,num_cells);
    for cellNum = 1:num_cells
        if length(cell_WCdiff{cellNum})>idx(end)
            for edgeNum = 1:2:numEdges
                window = cell_WCdiff{cellNum}(idx(edgeNum)-pksWin:idx(edgeNum)+pksWin);
                [extremaValue{cellNum}(edgeNum),pos] = min(window);
                extremaPos{cellNum}(edgeNum) = pos+idx(edgeNum)-pksWin;

                window = cell_WCdiff{cellNum}(idx(edgeNum+1)-pksWin:idx(edgeNum+1)+pksWin);
                [extremaValue{cellNum}(edgeNum+1),pos] = max(window);
                extremaPos{cellNum}(edgeNum+1) = pos+idx(edgeNum+1)-pksWin;
            end

            idx2 = zeros(1,numEdges);
            for edgeNum = 1:numEdges
                [~,idx2(edgeNum)] = min(abs(imageFrameTimes(extremaPos{cellNum}(edgeNum))-flowmeterTimes));
            end

            flowDiffExtrema = abs(flowFiltered(idx2(1:2:end)) - flowFiltered(idx2(2:2:end)))'; % ul/min
            rCOM = abs(extremaValue{cellNum}(1:2:end) - extremaValue{cellNum}(2:2:end))/opt.px2mum; % um in flow direction only (y-axis)

            flowDiffExtrema = (flowDiffExtrema/12.98)*0.1; % flow to pressure in Pa
            G{cellNum} = (flowDiffExtrema./rCOM).*median(cell_Height{cellNum}); % shear modulus for each pulse
            meanG(cellNum) = mean(G{cellNum}); % average shear modulus of cell
            stdG(cellNum) = std(G{cellNum}); % standard deviation of shear modulus of cell through pulses
        end
    end

%% visualization
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
    
    Gboxplot = nan(numEdges/2,num_cells);
    for cellNum = 1:num_cells
        if ~isempty(G{cellNum})
            Gboxplot(:,cellNum) = G{cellNum};
        end
    end
    figure('Position',opt.figureSize);
    boxplot(gca,Gboxplot)
    xlabel('Number of Cell (-)')
    ylabel('Shear Modulus G (Pa)')
    title(['Shear Modulus - Cells' description])
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    saveas(gcf,[path_save num2str(opt.info.experiment(fileNum)) '\ShearModulus_cells.png'])
    close(gcf)
    
    figure('Position',opt.figureSize);
    histogram(gca,meanG,num_cells)
    xlabel('Shear Modulus G (Pa)')
    ylabel('Cell Count (-)')
    title(['Shear Modulus - Total' description])
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    saveas(gcf,[path_save num2str(opt.info.experiment(fileNum)) '\ShearModulus.png'])
    close(gcf)
    
    save([path_save num2str(opt.info.experiment(fileNum)) '\'...
        num2str(opt.info.experiment(fileNum)) 'results.mat'],'optShear','G','-append')
end