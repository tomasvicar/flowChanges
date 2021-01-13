clear all;close all;clc;
addpath('utils')

path = 'G:\Sdílené disky\Quantitative GAÈR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\';
info = readtable([path 'info_18_12_20.xlsx']);

% path = 'G:\Sdílené disky\Quantitative GAÈR\data\20-12-10 - Shearstress PC3 calA ruzne dyny\';
% info = readtable([path 'info_10_12_20.xlsx']);

% path = 'G:\Sdílené disky\Quantitative GAÈR\data\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\';
% info = readtable([path 'info_19_11_20.xlsx']);



path_save = [path 'results_for_eps\'];

%% options
% segmentation and analysis parameters
threshold = 0.2;
volumeThr = 6000; % time*pixels - sum of cell areas during time
areaThr = [100, inf]; % px - [minimal maximal] cell area
minFrameFrac = 0.6; % relative of total frames
WeightFcn = @median; % method of cell weight
Med = [3,3,5]; % size of median filter [x,y,t]
Gauss = 0.5; % sigma of Gaussian filter

% export settings
figureSize = [50,100,1700,800];
videoFrameStep = 1;
upsampleFactor = 8;
contrast = [-0.5,2];
px2mum = 600/376;
videoFrameRate = 50;

listVars = whos;
for ii = 1:numel(listVars)
    opt.(listVars(ii).name) = eval(listVars(ii).name);
end
%% execution
for fileNum = [1,2,7,8]
    disp(num2str(fileNum))
    
%     err = [];
%     try
        
    flowMeter_file = [path info.folder{fileNum} '\flow' num2str(info.experiment(fileNum)) '.csv'];
    frameTime_file = [path info.folder{fileNum} '\segMotility.Path.csv'];
    image_file = [path info.folder{fileNum} '\Compensated phase - [0000, 0000].tiff'];
    
    imageFrameTimes = getImageFrameTimes(frameTime_file);
    
    flowmeterData = getFlowmeterData(flowMeter_file);
    flowmeterTimes = flowmeterData.RelativeTime;
    flowmeterValues = flowmeterData.FlowLinearized;
    %% prepare Theoretical Pump Flow
    pumpFlow = eval(info.flow{fileNum});
    delayFlow = eval(info.delay{fileNum});
    timeFlow = eval(info.time{fileNum});
    
    pumpFlowValues = [];
    pumpFlowTimes = [];
    for flowind = 1:length(pumpFlow)
        pumpFlowValues = [pumpFlowValues zeros(1,delayFlow(flowind))...
            pumpFlow(flowind)*ones(1,timeFlow(flowind))];
    end
    pumpFlowValues(end+1) = 0;
    pumpFlowTimes = 0:length(pumpFlowValues)-1; % sec
    pumpFlowValues(end+1) = 0;
    pumpFlowTimes(end+1) = flowmeterTimes(end);

    %% read image data
    %     Iorig = tiffreadVolume(image_file);
    imageSize = size(imread(image_file,1));
    
    if strcmp(image_file,'G:\Sdílené disky\Quantitative GAÈR\data\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\11_well06_PC3_untreated_48hseed_20spulse_mix100-200dyn\Compensated phase - [0000, 0000].tiff')
        imageFrameTimes = imageFrameTimes(1:2972);
    end
    
    frames = length(imageFrameTimes);

    I = zeros(imageSize(1),imageSize(2),frames,'single');
    parfor frame = 1:frames
        I(:,:,frame) = imread(image_file,frame);
    end
    
    %% image filtering and segmentation
    I = medfilt3(I,Med);
    I = imgaussfilt3(I,Gauss);
    Mask = I>threshold;
    
    parfor i = 1:frames
        mask = bwareafilt(Mask(:,:,i),areaThr);
        mask = imclearborder(mask);
        Mask(:,:,i) = mask;
    end
    Mask = imfill(Mask,26,'holes');
    Mask = bwareaopen(Mask, volumeThr);
    labels = bwlabeln(Mask);
    
    % nechutna filtrace
    BB = regionprops3(labels,labels,'MeanIntensity','BoundingBox','Volume');
    invalidIdx = BB.MeanIntensity(BB.BoundingBox(:,6) < minFrameFrac*frames |...
                                  BB.BoundingBox(:,3) ~= 0.5);
    BB(invalidIdx,:) = [];
    for cellID = 1:length(invalidIdx)
        labels(labels==invalidIdx(cellID)) = 0;
    end
    Mask = labels>0;
    labels = bwlabeln(Mask);
    BB = regionprops3(labels,labels,'MeanIntensity','BoundingBox','Volume');
    num_cells = height(BB);

    %% compute cell centres
    cellStats = table;
    for i = 1:frames
        stats = regionprops('table',labels(:,:,i),I(:,:,i),'Centroid','WeightedCentroid','PixelValues','Area');
        if isempty(stats)
            break
        end
        stats(stats.Area==0,:) = [];
        tmp2 = labels(:,:,i);
        cells_slice = unique(tmp2(:)); cells_slice(1)=[];
        num_cells_slice = length(cells_slice);
        cellStats{end+1:end+num_cells_slice,'MassCentroid'} = stats{:,'WeightedCentroid'};
        cellStats{end-num_cells_slice+1:end,'CellHeight'} = cellfun(@(x) WeightFcn(m2h(x)),stats{:,'PixelValues'});
        cellStats{end-num_cells_slice+1:end,'CellArea'} = stats{:,'Area'};
        cellStats{end-num_cells_slice+1:end,'BinaryCentroid'} = stats{:,'Centroid'};
        cellStats{end-num_cells_slice+1:end,'CellNumber'} = cells_slice;
        cellStats{end-num_cells_slice+1:end,'Frame'} = i.*ones(num_cells_slice,1);
    end

    %% compute centre differencies
    cell_WC = cell(1,num_cells);
    cell_WCdiff = cell(1,num_cells);
    cell_Height = cell(1,num_cells);
    for i = 1:num_cells
        cell_rows = cellStats{:,'CellNumber'} == i;
        cell_WC{i} = cellStats{cell_rows,'MassCentroid'};
        cell_WCdiff{i} = cell_WC{i} - cell_WC{i}(1,:);
        cell_WCdiff{i} = cell_WCdiff{i}(:,2);
        cell_Height{i} = cellStats{cell_rows,'CellHeight'};
    end

    %% Visualization
    mkdir([path_save num2str(info.experiment(fileNum))])
    
    for cellNum = 1:num_cells
        description = {['Exp' num2str(info.experiment(fileNum)) ' '...
        info.cell{fileNum} ' FOV' num2str(info.fov(fileNum))],...
        replace(info.folder{fileNum},'_',' ')};

        figure('Position',figureSize);
        yyaxis left
        plot(pumpFlowTimes,pumpFlowValues,'LineWidth',2)
        hold on
        plot(flowmeterTimes,flowmeterValues,'g','LineWidth',2)
        ylabel('Flow (\mul/min)')
        ylim([-10 max(pumpFlowValues)+5*12.98])

        yyaxis right
        plot(imageFrameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff{cellNum}/px2mum,'LineWidth',2)

        title([['Flow/Centre Measurement - Cell ' num2str(cellNum)] description])
        xlabel('Time (sec)')
        ylabel('Centre Difference (\mum)')
        legend({'Pump','Flowmeter','Centre Diff.'},'Location','northwest')
        set(gca,'FontSize',12)
        set(gca,'FontWeight','bold')
        saveas(gcf,[path_save num2str(info.experiment(fileNum)) '\Cell' num2str(cellNum) 'CentreDiff.png'])
        close(gcf)
    end

    figure('Position',figureSize);
    for cellNum = 1:num_cells
        plot(imageFrameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff{cellNum}/px2mum,'LineWidth',2)
        hold on
        L{cellNum} = ['Cell ' num2str(cellNum)];
    end
    title(['QPI Centre Change' description])
    xlabel('Time (sec)')
    ylabel('Centre Difference (\mum)')
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    legend(L,'Location','best')
    saveas(gcf,[path_save num2str(info.experiment(fileNum)) '\All_Cells_CentreDiff.png'])
    close(gcf)

    %% Export video of Cell BB
    for cellNum = 1:num_cells
        Ibb = I(ceil(BB.BoundingBox(cellNum,2)):ceil(BB.BoundingBox(cellNum,2))+ceil(BB.BoundingBox(cellNum,5))-1,...
            ceil(BB.BoundingBox(cellNum,1)):ceil(BB.BoundingBox(cellNum,1))+ceil(BB.BoundingBox(cellNum,4))-1,...
            ceil(BB.BoundingBox(cellNum,3)):ceil(BB.BoundingBox(cellNum,3))+ceil(BB.BoundingBox(cellNum,6))-1);
        Ibb = uint8(mat2gray(Ibb,contrast)*255);
        Ibb = Ibb(:,:,1:videoFrameStep:end);

        Mbb = Mask(ceil(BB.BoundingBox(cellNum,2)):ceil(BB.BoundingBox(cellNum,2))+ceil(BB.BoundingBox(cellNum,5))-1,...
            ceil(BB.BoundingBox(cellNum,1)):ceil(BB.BoundingBox(cellNum,1))+ceil(BB.BoundingBox(cellNum,4))-1,...
            ceil(BB.BoundingBox(cellNum,3)):ceil(BB.BoundingBox(cellNum,3))+ceil(BB.BoundingBox(cellNum,6))-1);
        Mbb = uint8(double(Mbb).*255);
        Mbb = Mbb(:,:,1:videoFrameStep:end);

        posWC = [cell_WC{cellNum}(:,1)-ceil(BB.BoundingBox(cellNum,1)),...
            cell_WC{cellNum}(:,2)-ceil(BB.BoundingBox(cellNum,2))];

        v = VideoWriter([path_save num2str(info.experiment(fileNum)) '\Cell' num2str(cellNum) 'BBVideo.avi'],'Grayscale AVI');
        v.FrameRate = videoFrameRate;
%         v.Quality = 100;
        open(v)
        for frame = 1:size(Ibb,3)
            writeVideo(v,imresize(Ibb(:,:,frame),upsampleFactor))
        end
        close(v)
    end
    
    save([path_save num2str(info.experiment(fileNum)) '\'...
        num2str(info.experiment(fileNum)) 'results.mat'],...
        'cellStats','cell_WC','cell_WCdiff','cell_Height',...
        'flowmeterTimes','flowmeterValues','pumpFlowValues',...
        'pumpFlowTimes','imageFrameTimes','opt','num_cells')
    
%     catch err
%     save([path_save num2str(info.experiment(fileNum)) 'error.mat'],'err');
%     end
end