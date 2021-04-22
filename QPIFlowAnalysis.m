clear all;close all;clc;
addpath('utils')

% data_folder = 'Z:\999992-nanobiomed\Holograf\21-03-12 - Shearstress';
% 
% path = [data_folder '\21-03-12 - Shearstress PC3 PC3doc PC3CytD\'];
% info = readtable([path 'info_12_03_21.xlsx']);
% flow_folder = [path 'exp_12_03_21'];



data_folder = 'Z:\999992-nanobiomed\Holograf\21-03-12 - Shearstress';

path = [data_folder '\21-03-25 - Shearstress 22Rv1\'];
info = readtable([path 'info_25_03_21.xlsx']);
flow_folder = [path 'exp_25_03_21'];



path_save = [path 'results_1\'];

%% options
% segmentation and analysis parameters
threshold = 0.2;
volumeThr = 6000; % time*pixels - sum of cell areas during time
areaThr = [100, inf]; % px - [minimal maximal] cell area
minFrameFrac = 0.6; % relative of total frames
WeightFcn = @median; % method of cell weight
Med = [3,3,7]; % size of median filter [x,y,t]
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
for fileNum = 1:size(info,1)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp(num2str(fileNum))
    
%     err = [];
%     try
        
    flowMeter_file = [flow_folder '\flow' num2str(info.experiment(fileNum)) '.csv'];
    
    image_file = [path info.folder{fileNum} '\Compensated phase - [0000, 0000].tiff'];
    
    tmp1 = [path info.folder{fileNum} '\segMotility.Path.csv'];
    tmp2 = [path info.folder{fileNum} '\time.txt'];
    if isfile(tmp1)
        imageFrameTimes = getImageFrameTimes(tmp1);
    elseif isfile(tmp2)
        imageFrameTimes = getImageFrameTimes2(tmp2);
    else
        error('no time file')
    end
        
    
    
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
    
    if strcmp(image_file,'Z:\999992-nanobiomed\Holograf\20-11-19 - Shearstress PC3 various dyn time\11_well06_PC3_untreated_48hseed_20spulse_mix100-200dyn\Compensated phase - [0000, 0000].tiff')
        imageFrameTimes = imageFrameTimes(1:2972);
    end
    
    frames = length(imageFrameTimes);

    I = zeros(imageSize(1),imageSize(2),frames,'single');
    fprintf(1,'Img loading:\n')
    fprintf(1,'%s\n\n',repmat('.',1,frames));
    parfor frame = 1:frames
        I(:,:,frame) = imread(image_file,frame);
        fprintf(1,'\b|\n');
    end
    fprintf(1,'\n loading finished')
    
    %% image filtering and segmentation
    fprintf(1,'\n filters')
    I = medfilt3(I,Med);
    I = imgaussfilt3(I,Gauss);
    Mask = I>threshold;
    
    fprintf(1,'\n mask filtering 2D')
    parfor i = 1:frames
        mask = bwareafilt(Mask(:,:,i),areaThr);
        mask = imclearborder(mask);
        Mask(:,:,i) = mask;
    end
    
    fprintf(1,'\n mask filtering 3D')
    Mask = imfill(Mask,26,'holes');
    Mask = bwareaopen(Mask, volumeThr);
    labels = bwlabeln(Mask);
    
    fprintf(1,'\n bb')
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
    fprintf(1,'\n shear stress')
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
    fprintf(1,'\n visualisation')
    
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
    mkdir([path_save info.folder{fileNum}])
    
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
        saveas(gcf,[path_save info.folder{fileNum} '\Cell' num2str(cellNum) 'CentreDiff.png'])
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
    saveas(gcf,[path_save info.folder{fileNum} '\All_Cells_CentreDiff.png'])
    close(gcf)

    %% Export video of Cell BB
    for cellNum = 1:num_cells
        Ibb = I(ceil(BB.BoundingBox(cellNum,2)):ceil(BB.BoundingBox(cellNum,2))+ceil(BB.BoundingBox(cellNum,5))-1,...
            ceil(BB.BoundingBox(cellNum,1)):ceil(BB.BoundingBox(cellNum,1))+ceil(BB.BoundingBox(cellNum,4))-1,...
            ceil(BB.BoundingBox(cellNum,3)):ceil(BB.BoundingBox(cellNum,3))+ceil(BB.BoundingBox(cellNum,6))-1);
        Ibb = uint8(mat2gray(Ibb,contrast)*255);
        Ibb = Ibb(:,:,1:videoFrameStep:end);

        
       
        Mbb = labels(ceil(BB.BoundingBox(cellNum,2)):ceil(BB.BoundingBox(cellNum,2))+ceil(BB.BoundingBox(cellNum,5))-1,...
            ceil(BB.BoundingBox(cellNum,1)):ceil(BB.BoundingBox(cellNum,1))+ceil(BB.BoundingBox(cellNum,4))-1,...
            ceil(BB.BoundingBox(cellNum,3)):ceil(BB.BoundingBox(cellNum,3))+ceil(BB.BoundingBox(cellNum,6))-1)==cellNum;
        Mbb = uint8(double(Mbb).*255);
        Mbb = Mbb(:,:,1:videoFrameStep:end);

        posWC = [cell_WC{cellNum}(:,1)-ceil(BB.BoundingBox(cellNum,1)),...
            cell_WC{cellNum}(:,2)-ceil(BB.BoundingBox(cellNum,2))];

        v = VideoWriter([path_save info.folder{fileNum} '\Cell' num2str(cellNum) 'BBVideo.avi'],'MPEG-4');
        v.FrameRate = videoFrameRate;
        v.Quality = 100;
        open(v)
        for frame = 1:size(Ibb,3)
            writeVideo(v,insertMarker(labeloverlay(repmat(imresize(Ibb(:,:,frame),upsampleFactor),[1 1 3]),...
                boundarymask(imresize(Mbb(:,:,frame),upsampleFactor,'nearest')),'Transparency',0.5),...
                upsampleFactor.*posWC(frame,:),'x','color','y','size',5))
        end
        close(v)
    end
    
    save([path_save info.folder{fileNum} '\'...
        'results.mat'],...
        'cellStats','cell_WC','cell_WCdiff','cell_Height',...
        'flowmeterTimes','flowmeterValues','pumpFlowValues',...
        'pumpFlowTimes','imageFrameTimes','opt','num_cells')
    
%     catch err
%     save([path_save num2str(info.experiment(fileNum)) 'error.mat'],'err');
%     end
end