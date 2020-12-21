clear all
close all
clc

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-10 - Shearstress PC3 calA ruzne dyny\';
path_save = [path 'results\'];

%% options
dynThr = 25*12.98;
medSize = 12;
pksWin = 25;

%% execution
for fileNum = 1:height(opt.info)
    disp(num2str(fileNum))
    
    load([path 'results\' num2str(fileNum) '\' num2str(fileNum) 'results.mat'])
    
    %%% odstranit - neni potreba pro nove zpracovana data
    frameTime_file = [path opt.info.folder{fileNum} '\segMotility.Path.csv'];
    imageFrameTimes = getImageFrameTimes(frameTime_file);
    num_cells = length(cell_WCdiff);
    %%%
    
    flowFiltered = medfilt1(flowmeterValues,medSize);

    edgeFlowSamples = find(diff(flowFiltered>dynThr)~=0)';
    edgeFlowTimes = flowmeterTimes(edgeFlowSamples);
    numEdges = length(edgeFlowTimes);
    edgeFlowDirections = repmat([1 -1],[1,numEdges/2]);

    for edgeNum = 1:numEdges
        [~,idx(edgeNum)] = min(abs(imageFrameTimes-edgeFlowTimes(edgeNum)));
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
    f = figure('Position',opt.figureSize);
    boxplot(gca,Gboxplot)
    xlabel('Number of Cell (-)')
    ylabel('Shear Modulus G (Pa)')
    title(['Shear Modulus - Cells' description])
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    saveas(gcf,[path_save num2str(opt.info.experiment(fileNum)) '\ShearModulus_cells.png'])
    close(gcf)
    
    f = figure('Position',opt.figureSize);
    histogram(gca,meanG,num_cells)
    xlabel('Shear Modulus G (Pa)')
    ylabel('Cell Count (-)')
    title(['Shear Modulus - Total' description])
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    saveas(gcf,[path_save num2str(opt.info.experiment(fileNum)) '\ShearModulus.png'])
    close(gcf)
end