clear all
close all
clc

path = 'G:\Sdílené disky\Quantitative GAČR\data\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\';
D = dir([path '*well*']);

% % channel and medium parameters
% nu = 0.0072; % dyn*s/cm^2 (medium 10% serum, 37°C) - (g*cm/s^2)*s/cm^2 = g/cm*s
% 
% x = 0; % m - x position (left/right) in channel - 0 means centre
% h = (0.1/1000)/2; % m height
% b = (1/1000)/2; % m length
% y = -h; % m - y position (up/down) in channel - 0 means centre
% phi = 649.01/10^6/60; %l/s

%%
% image parameters
sample_time = 1/5; % Hz

% flow settings
dyn2ulmin = 12.98; % multiplication constant for transfer of flow units
dyn0 = 5;

% segmentation and analysis parameters
threshold = 0.3;
WeightFcn = @sum;
volumeThr = 6000; % time*pixels - sum of cell areas during time
areaThr = [100, inf]; % px - [minimal maximal] cell area
Med = [3,3,5]; % size of median filter [x,y,t]
Gauss = 0.5; % sigma of Gaussian filter



% export settings
figureSize = [50,100,1700,800];
videoFrameStep = 1;
upsampleFactor = 8;
contrast = [-0.5,2];

ERR = [];
%%
for experiment = 3%:length(D)
    disp(num2str(experiment))
    err = [];
%     try
    C = strsplit(D(experiment).name,'_');
    expNum = str2double(C(1));
    expCell = C(3);
    expFOV = C(2);
    
    step_length = str2double(C{end}(1:2)); % sec
    step_pause = str2double(C{end}(1:2)); % sec
    delay_length = 60; % sec
    
    if contains(C{end},'mix')
        dyn1 = str2double(C{end}(end-9:end-7));
        dyn2 = str2double(C{end}(end-5:end-3));
    else
        dyn1 = str2double(C{end}(end-4:end-3));
        dyn2 = str2double(C{end}(end-4:end-3));
    end
    expFlowSettings = {'repmat([dyn1 dyn1 dyn1 dyn2 dyn2 dyn2],[1,3])'}; %dyn
    
    flowMeter_file = [path 'flowmeter\a' num2str(expNum) '.csv'];
    path_save = [path 'results\'];
    frameTime_file = [path D(experiment).name '\segMotility.Path.csv'];
    mkdir([path_save num2str(expNum)])

    description = {['Exp' num2str(expNum) ' ' expCell{:} ' ' expFOV{:}], [num2str(dyn1) '/' num2str(dyn2) 'dyn/cm^2 - ' num2str(step_pause) '/' num2str(step_length) 'sec intervals']};
    file = dir([path D(experiment).name '\*phase*']);
    frameTimes = importdata(frameTime_file);
    dtv = datevec(datetime(frameTimes.textdata(2:end,1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSS'));
    da = duration(dtv(:,4:end));
    frameTimes = seconds(da-da(1));
    %% import FlowMeter data
    a = importdata(flowMeter_file);
    varNames = strsplit(replace(replace(replace(replace(eraseBetween(replace(replace(a{16},'"',''),' ',''),'[',']'),'[',''),']',''),'#',''),'lin','Lin'),';');
    tmp = cell2mat(cellfun(@(x) str2num(replace(replace(x,',','.'),'"',''))',a(17:end),'UniformOutput',false));
    T = table(tmp(:,1),tmp(:,2)-tmp(1,2),tmp(:,3).*1000,tmp(:,4),tmp(:,5),'VariableNames',varNames);

    %% prepare Theoretical Pump Flow
    PumpFlow = eval(expFlowSettings{:}).*dyn2ulmin; % ul/min

    step_time=step_length/sample_time; % sec
    delay_time=delay_length/sample_time; % sec

    time=[];
    FlowTheoretical=[];
    for k=1:length(PumpFlow)
        time=[time,(1:(delay_time+step_time))+(k-1)*(delay_time+step_time)];
        FlowTheoretical=[FlowTheoretical,zeros(1,delay_time),PumpFlow(k)*ones(1,step_time)];
    end
    
    time = [linspace(1,60*sample_time,60*sample_time) time+60*sample_time];
    FlowTheoretical = [ones(1,60*sample_time).*dyn0 FlowTheoretical];

    %% read image data
    info = imfinfo([file.folder '\' file.name]);
    frames = length(info);
    Time = 0:sample_time:(frames-1)*sample_time;

    if length(FlowTheoretical)<frames
        FlowTheoretical(end:end+(frames-length(time))) = NaN;
    elseif length(FlowTheoretical)>frames
        FlowTheoretical(frames+1:end) = [];
    end
    
    if length(frameTimes)<frames
        frameTimes(end:end+(frames-length(frameTimes))) = NaN;
    elseif length(frameTimes)>frames
        frameTimes(frames+1:end) = [];
    end

    I = zeros(info(1).Height,info(1).Width,frames,'single');
    I(:,:,1) = imread([file.folder '\' file.name],1);

    Iorig = zeros(info(1).Height,info(1).Width,frames,'single');
    parfor i = 1:frames
        Iorig(:,:,i) = imread([file.folder '\' file.name],i);
    end
    
    I = medfilt3(Iorig,Med);
    I = imgaussfilt3(I,Gauss);
    M = I>threshold;
    
    parfor i = 1:frames
        mask = bwareafilt(M(:,:,i),areaThr);
        mask = imclearborder(mask);
        M(:,:,i) = mask;
    end
    M = imfill(M,26,'holes');
    M = bwareaopen(M, volumeThr);
    labels = bwlabeln(M);

    %% compute cell centres
    BB = regionprops3(labels,labels,'MeanIntensity','BoundingBox','Volume');
% %     labelsDelete = BB.MeanIntensity(BB.Volume<volumeThr | BB.BoundingBox(:,3)~=0.5 | BB.BoundingBox(:,6)~=frames);
%     labelsDelete = BB.MeanIntensity(BB.Volume<areaThr);
%     for LD = 1:length(labelsDelete)
%         labels(labels==labelsDelete(LD)) = 0;
%         M(labels==labelsDelete(LD)) = 0;
%         I(labels==labelsDelete(LD)) = 0;
%     end
%     BB(BB.Volume<volumeThr | BB.BoundingBox(:,3)~=0.5 | BB.BoundingBox(:,6)~=frames,:) = [];
%     BB(BB.Volume<areaThr,:) = [];
    num_cells = height(BB);
    
%     for i = 1:num_cells
%         labels(labels==BB.MeanIntensity(i)) = i;
%         BB.MeanIntensity(i) = i;
%     end
    
    centres = table;
    for i = 1:length(info)
        stats = regionprops('table',labels(:,:,i),I(:,:,i),'Centroid','WeightedCentroid','PixelValues','Area');
        if isempty(stats)
            break
        end
        stats(stats.Area==0,:) = [];
        tmp2 = labels(:,:,i);
        cells_slice = unique(tmp2(:)); cells_slice(1)=[];
        num_cells_slice = length(cells_slice);
        centres{end+1:end+num_cells_slice,'WeightedCentroid'} = stats{:,'WeightedCentroid'};
        centres{end-num_cells_slice+1:end,'WeightMedian'} = cellfun(WeightFcn,stats{:,'PixelValues'});
        centres{end-num_cells_slice+1:end,'AreaPX'} = stats{:,'Area'};
        centres{end-num_cells_slice+1:end,'Centroid'} = stats{:,'Centroid'};
        centres{end-num_cells_slice+1:end,'CellNumber'} = cells_slice;
        centres{end-num_cells_slice+1:end,'TimeSample'} = i.*ones(num_cells_slice,1);
    end

    %% compute centre differencies
    for i = 1:num_cells
        cell_rows = centres{:,'CellNumber'} == i;
        cell_C{i} = centres{cell_rows,'Centroid'};
        cell_WC{i} = centres{cell_rows,'WeightedCentroid'};
        cell_weight{i} = centres{cell_rows,'WeightMedian'};
        cell_area{i} = centres{cell_rows,'AreaPX'};

        % Euclidean distance
%         cell_WCdiff{i} = (cell_WC{i} - cell_WC{i}(1,:)).^2;
%         cell_WCdiff{i} = sqrt(cell_WCdiff{i}(:,1) + cell_WCdiff{i}(:,2));
        % y distance
        cell_WCdiff{i} = cell_WC{i} - cell_WC{i}(1,:);
        cell_WCdiff{i} = cell_WCdiff{i}(:,2);
        cell_WCdiff_weightNorm{i} = cell_WCdiff{i}./cell_weight{i};

        cell_Cdiff{i} = (cell_C{i} - cell_C{i}(1,:)).^2;
        cell_Cdiff{i} = sqrt(cell_Cdiff{i}(:,1) + cell_Cdiff{i}(:,2));

        cell_WCdiff_compensatedShift{i} = cell_WCdiff{i}-cell_Cdiff{i};

        cell_WCdiff_compensatedShift_weightNorm{i} = cell_WCdiff_compensatedShift{i}./cell_weight{i};
    end

    %% Visualisation of Flow - Theoretical vs. Real and Cell Centre Differnece
    for cellNum = 1:num_cells
        % Pure
        figure('Position',figureSize);
        yyaxis left
        plot(Time,FlowTheoretical,'LineWidth',2)
        hold on
        plot(T.RelativeTime,T.FlowLinearized,'g','LineWidth',2)
        ylabel('Flow (\mul/min)')

        yyaxis right
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff{cellNum},'LineWidth',2)
        hold on
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff_compensatedShift{cellNum},'k','LineWidth',2)

        title([['Flow/Centre Measurement - Cell ' num2str(cellNum)] description])
        xlabel('Time (sec)')
        ylabel('Centre Difference (px)')
        legend({'Pump - Theoretical','Flowmeter - Measured','Cell Centre Difference','Cell Centre Difference - Compensated Shift'},'Location','best')
        set(gca,'FontSize',12)
        set(gca,'FontWeight','bold')
        saveas(gcf,[path_save num2str(expNum) '\Cell' num2str(cellNum) 'CentreDiff.png'])
        close(gcf)

        % Wight normalized
        figure('Position',figureSize);
        yyaxis left
        plot(Time,FlowTheoretical,'LineWidth',2)
        hold on
        plot(T.RelativeTime,T.FlowLinearized,'g','LineWidth',2)
        ylabel('Flow (\mul/min)')

        yyaxis right
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff_weightNorm{cellNum},'LineWidth',2)
        hold on
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff_compensatedShift_weightNorm{cellNum},'k','LineWidth',2)

        title([['Flow/Centre Measurement - Weight Normalized - Cell ' num2str(cellNum)] description])
        xlabel('Time (sec)')
        ylabel('Centre Difference (??)')
        legend({'Pump - Theoretical','Flowmeter - Measured','Cell Centre Difference','Cell Centre Difference - Compensated Shift'},'Location','best')
        set(gca,'FontSize',12)
        set(gca,'FontWeight','bold')
        saveas(gcf,[path_save num2str(expNum) '\Cell' num2str(cellNum) 'CentreDiff_WN.png'])
        close(gcf)
    end

    %% Visualisation of Cell Centre Changes
    figure('Position',figureSize);
    for cellNum = 1:num_cells
        % subplot(121)
        % plot(cell_WCdiff{cellNum},'LineWidth',2)
        % % hold on
        % % plot(cell_WCdiff{4},'LineWidth',2)
        % % plot(cell_WCdiff{5},'LineWidth',2)
        % % plot(cell_WCdiff{6},'LineWidth',2)
        % % plot(cell_WCdiff{7},'LineWidth',2)
        % title(['QPI Centre Change' description])
        % xlabel('Time (samples)')
        % ylabel('Centroid Difference (px)')
        % % legend({'Cell 1','Cell 2','Cell 3','Cell 4','Cell 5',},'Location','best')
        % set(gca,'FontSize',12)
        % set(gca,'FontWeight','bold')

        % figure;
        % subplot(122)
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff_weightNorm{cellNum},'LineWidth',2)
        hold on
        % hold on
        % plot(cell_WCdiff_weightNorm{4},'LineWidth',2)
        % plot(cell_WCdiff_weightNorm{5},'LineWidth',2)
        % plot(cell_WCdiff_weightNorm{6},'LineWidth',2)
        % plot(cell_WCdiff_weightNorm{7},'LineWidth',2)
        L{cellNum} = ['Cell ' num2str(cellNum)];
    end
    title(['QPI Centre Change' description])
    xlabel('Time (sec)')
    ylabel('Weight Normalized Centre Difference (?)')
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    legend(L,'Location','best')
    saveas(gcf,[path_save num2str(expNum) '\All_Cells_CentreDiff_WN.png'])
    close(gcf)

    figure('Position',figureSize);
    for cellNum = 1:num_cells
        % subplot(121)
        % plot(cell_WCdiff{cellNum},'LineWidth',2)
        % % hold on
        % % plot(cell_WCdiff{4},'LineWidth',2)
        % % plot(cell_WCdiff{5},'LineWidth',2)
        % % plot(cell_WCdiff{6},'LineWidth',2)
        % % plot(cell_WCdiff{7},'LineWidth',2)
        % title(['QPI Centre Change' description])
        % xlabel('Time (samples)')
        % ylabel('Centroid Difference (px)')
        % % legend({'Cell 1','Cell 2','Cell 3','Cell 4','Cell 5',},'Location','best')
        % set(gca,'FontSize',12)
        % set(gca,'FontWeight','bold')

        % figure;
        % subplot(122)
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_WCdiff_compensatedShift_weightNorm{cellNum},'LineWidth',2)
        hold on
        % hold on
        % plot(cell_WCdiff_weightNorm{4},'LineWidth',2)
        % plot(cell_WCdiff_weightNorm{5},'LineWidth',2)
        % plot(cell_WCdiff_weightNorm{6},'LineWidth',2)
        % plot(cell_WCdiff_weightNorm{7},'LineWidth',2)
        L{cellNum} = ['Cell ' num2str(cellNum)];
    end
    title(['QPI Centre Change - Compensated Shift' description])
    xlabel('Time (sec)')
    ylabel('Weight Normalized Centre Difference (?)')
    set(gca,'FontSize',12)
    set(gca,'FontWeight','bold')
    legend(L,'Location','best')
    saveas(gcf,[path_save num2str(expNum) '\All_Cells_CentreDiff_WNCS.png'])
    close(gcf)
    %% Visualisation of Cell Area, Position and Weight Changes
    for cellNum = 1:num_cells
        figure('Position',figureSize);
        yyaxis left
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_area{cellNum},'LineWidth',2)
        ylabel('Area (px)')

        yyaxis right
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_weight{cellNum},'LineWidth',2)

        title([['QPI Cell Area/Weight Change - Cell ' num2str(cellNum)] description])
        xlabel('Time (sec)')
        ylabel('Weight (pg)')
        set(gca,'FontSize',12)
        set(gca,'FontWeight','bold')
        saveas(gcf,[path_save num2str(expNum) '\Cell' num2str(cellNum) 'Area_Weight.png'])
        close(gcf)

        figure('Position',figureSize);
        plot(frameTimes(1:length(cell_WCdiff{cellNum})),cell_Cdiff{cellNum},'LineWidth',2)
        title([['QPI Cell Position Change - Cell ' num2str(cellNum)] description])
        xlabel('Time (sec)')
        ylabel('Distance from Start (px)')
        set(gca,'FontSize',12)
        set(gca,'FontWeight','bold')
        saveas(gcf,[path_save num2str(expNum) '\Cell' num2str(cellNum) 'Position.png'])
        close(gcf)
    end
    %% Export video of Cell BB
    for cellNum = 1:num_cells
        Ibb = I(ceil(BB.BoundingBox(cellNum,2)):ceil(BB.BoundingBox(cellNum,2))+ceil(BB.BoundingBox(cellNum,5))-1,...
            ceil(BB.BoundingBox(cellNum,1)):ceil(BB.BoundingBox(cellNum,1))+ceil(BB.BoundingBox(cellNum,4))-1,...
            ceil(BB.BoundingBox(cellNum,3)):ceil(BB.BoundingBox(cellNum,3))+ceil(BB.BoundingBox(cellNum,6))-1);
        Ibb = uint8(mat2gray(Ibb,contrast)*255);
        Ibb = Ibb(:,:,1:videoFrameStep:end);

        Mbb = M(ceil(BB.BoundingBox(cellNum,2)):ceil(BB.BoundingBox(cellNum,2))+ceil(BB.BoundingBox(cellNum,5))-1,...
            ceil(BB.BoundingBox(cellNum,1)):ceil(BB.BoundingBox(cellNum,1))+ceil(BB.BoundingBox(cellNum,4))-1,...
            ceil(BB.BoundingBox(cellNum,3)):ceil(BB.BoundingBox(cellNum,3))+ceil(BB.BoundingBox(cellNum,6))-1);
        Mbb = uint8(double(Mbb).*255);
        Mbb = Mbb(:,:,1:videoFrameStep:end);

        posWC = [cell_WC{cellNum}(:,1)-ceil(BB.BoundingBox(cellNum,1)),...
            cell_WC{cellNum}(:,2)-ceil(BB.BoundingBox(cellNum,2))];

        posC = [cell_C{cellNum}(:,1)-ceil(BB.BoundingBox(cellNum,1)),...
            cell_C{cellNum}(:,2)-ceil(BB.BoundingBox(cellNum,2))];

        v = VideoWriter([path_save num2str(expNum) '\Cell' num2str(cellNum) 'BBVideo.avi'],'MPEG-4');
        v.FrameRate = 50;
        v.Quality = 100;
        open(v)
        for frame = 1:size(Ibb,3)
            writeVideo(v,insertMarker(labeloverlay(repmat(imresize(Ibb(:,:,frame),upsampleFactor),[1 1 3]),...
                boundarymask(imresize(Mbb(:,:,frame),upsampleFactor,'nearest')),'Transparency',0.5),...
                upsampleFactor.*[posWC(frame,:); posC(frame,:)],'x','color',{'y','r'},'size',5))
        end
        close(v)
    end
%     catch err
%         ERR{experiment} = err;
%         close all
%     end
end