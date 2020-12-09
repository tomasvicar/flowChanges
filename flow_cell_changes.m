clear all
close all
clc

path_load = '\\nas1.ubmi.feec.vutbr.cz\Data\CELL\HOLOGRAF_MU\';
folder1 = '2_frame_1-20'; % no flow image
folder2 = '2_frame_21-80'; % 1.5 ml/min flow image
folder3 = '2_frame_243-315'; % 5 ml/min flow image
folder4 = '2_frame_402-431'; % 10 ml/min flow image
% folder5 = '3_frame_95-119'; % 15 ml/min flow image
name = 'Compensated phase-pgpum2-001-001.tiff'; % image name
flow = [0,1.5,5,10];
num_flows = length(flow);

path_save = '\\nas1.ubmi.feec.vutbr.cz\Data\CELL\HOLOGRAF_MU\software\results\';

%% read images
window_size = 5;
% for i = 1:20
%     im1(:,:,i) = imread([path_load folder1 '\' name],i);
% end
% 
% for i = 1:60
%     im2(:,:,i) = imread([path_load folder2 '\' name],i);
% end
% 
% for i = 1:73
%     im3(:,:,i) = imread([path_load folder3 '\' name],i);
% end
% 
% for i = 1:30
%     im4(:,:,i) = imread([path_load folder4 '\' name],i);
% end
% for i = 1:25
%     im5(:,:,i) = imread([path_load folder5 '\' name],i);
% end
for k = 1:num_flows
    for i = 1:window_size
        im(:,:,i) = imread([path_load eval(['folder' num2str(k)]) '\' name],15+i);
    end
    im_time(:,:,k) = mean(im,3);
end
% im1_mean = mean(im1(:,:,1:window_size),3);
% im2_mean = mean(im2(:,:,1:window_size),3);
% im3_mean = mean(im3(:,:,1:window_size),3);
% im4_mean = mean(im4(:,:,1:window_size),3);

% im_time = im1_mean;
% im_time(:,:,2) = im2_mean;
% im_time(:,:,3) = im3_mean;
% im_time(:,:,4) = im4_mean;

% imshow5(im_time)

for i = 1:num_flows
    labels(:,:,i) = imread(['\\nas1.ubmi.feec.vutbr.cz\data\CELL\HOLOGRAF_MU\software\.imageLabelingSession_SessionData\Label_' num2str(i) '.png']);
end
% imfuse5(im_time,labels)


%%
labels_puv = labels;
labels(labels~=1)=0;
labels(labels==1)=1;
% labels(labels~=3 & labels~=5 & labels~=7)=0;
% labels(labels==3)=1;
% labels(labels==5)=2;
% labels(labels==7)=3;

num_cells = max(labels(:));

%% centroids

centres=table;
for i = 1:num_flows
    stats = regionprops('table',labels(:,:,i),im_time(:,:,i),'WeightedCentroid','Centroid');
    centres{end+1:end+num_cells,'WeightedCentroid'} = stats{:,'WeightedCentroid'};
    centres{end-num_cells+1:end,'Centroid'} = stats{:,'Centroid'};
    centres{end-num_cells+1:end,'FlowSpeed'} = flow(i);
end

for i = 1:num_flows-1
    C_diff = [];
    C_diff2 = [];
    for k = 1:num_cells
        C_diff(k,:) = [centres{k+(i)*num_cells,'WeightedCentroid'}(:,1)-centres{k,'WeightedCentroid'}(:,1),...
            centres{k+(i)*num_cells,'WeightedCentroid'}(:,2)-centres{k,'WeightedCentroid'}(:,2)];
        C_diff2(k,:) = [(centres{k+(i)*num_cells,'WeightedCentroid'}(:,1)-centres{k,'WeightedCentroid'}(:,1))-(centres{k+(i)*num_cells,'Centroid'}(:,1)-centres{k,'Centroid'}(:,1)),...
            (centres{k+(i)*num_cells,'WeightedCentroid'}(:,2)-centres{k,'WeightedCentroid'}(:,2))-(centres{k+(i)*num_cells,'Centroid'}(:,2)-centres{k,'Centroid'}(:,2))];
    end
    figure;
    compass(C_diff(:,1),C_diff(:,2))
    hold on
    compass(mean(C_diff(:,1)),mean(C_diff(:,2)),'r')
    hold off
    title(['Flow: ' num2str(flow(i+1)) ' ml/min, Weighted Centroid'])
    saveas(gcf,[path_save 'compass_weighted_centroid_with_shift_single_cell3_flow_' num2str(flow(i+1)) '_ml_min.png'])
    
    figure;
    compass(C_diff2(:,1),C_diff2(:,2))
    hold on
    compass(mean(C_diff2(:,1)),mean(C_diff2(:,2)),'r')
    hold off
    title(['Flow: ' num2str(flow(i+1)) ' ml/min, Weighted Centroid - Compensated Shift'])
    saveas(gcf,[path_save 'compass_weighted_centroid_compensated_shift_single_cell3_flow_' num2str(flow(i+1)) '_ml_min.png'])
end
%% differences
% close all
figure;
imshow(im_time(:,:,1),[])
% [x,y]=ginput(2);
x = [1,size(im_time,1)]; y = [1,size(im_time,2)];
y=round(y);
x=round(x);

for i = 1:num_flows-1
    im_diff(:,:,i) = im_time(:,:,i+1)-im_time(:,:,1);
end

c(1) = min(min(im_diff(y(1):y(2),x(1):x(2),end)));
c(2) = max(max(im_diff(y(1):y(2),x(1):x(2),end)));

for i = 1:num_flows-1
    figure;
    imagesc(im_diff(y(1):y(2),x(1):x(2),i),[c(1), c(2)])
    colormap parula
    colorbar
    
    hold on
    for k = 1:num_cells
        plot(centres{k,'WeightedCentroid'}(:,1),centres{k,'WeightedCentroid'}(:,2),'rx')
        plot(centres{k+(i)*num_cells,'WeightedCentroid'}(:,1),centres{k+(i)*num_cells,'WeightedCentroid'}(:,2),'ro')
        plot([centres{k,'WeightedCentroid'}(:,1),centres{k+(i)*num_cells,'WeightedCentroid'}(:,1)],[centres{k,'WeightedCentroid'}(:,2),centres{k+(i)*num_cells,'WeightedCentroid'}(:,2)],'r')
    end
    hold off
    title(['Flow: ' num2str(flow(i+1)) ' ml/min, Weighted Centroid'])
    saveas(gcf,[path_save 'image_weighted_centroid_position_change_single_cell3_flow_' num2str(flow(i+1)) '_ml_min.png'])
    
    figure;
    mask = single(labels(y(1):y(2),x(1):x(2),i+1));
    mask_ref = single(labels(y(1):y(2),x(1):x(2),1));
    mask(mask>0)=1;
    im_masked = im_diff(y(1):y(2),x(1):x(2),i);
    [mask_body,ra1,ra2,sl1,sl2,zz1,zz2] = bound3(mask,0);
    im_masked = im_masked(ra1:ra2,sl1:sl2);
    imagesc(im_masked)
    colormap parula
    colorbar
    
    hold on
    for k = 1:num_cells
        plot(centres{k,'WeightedCentroid'}(:,1),centres{k,'WeightedCentroid'}(:,2),'rx')
        plot(centres{k+(i)*num_cells,'WeightedCentroid'}(:,1),centres{k+(i)*num_cells,'WeightedCentroid'}(:,2),'ro')
        plot([centres{k,'WeightedCentroid'}(:,1),centres{k+(i)*num_cells,'WeightedCentroid'}(:,1)],[centres{k,'WeightedCentroid'}(:,2),centres{k+(i)*num_cells,'WeightedCentroid'}(:,2)],'r')
    end
    hold off
    title(['Flow: ' num2str(flow(i+1)) ' ml/min, Single Cell'])
    saveas(gcf,[path_save 'image_single_cell3_flow_' num2str(flow(i+1)) '_ml_min.png'])
end
