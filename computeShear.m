clear all
close all
clc

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-10 - Shearstress PC3 calA ruzne dyny\';
load([path 'results\5\5results.mat'])
frameTime_file = [path '05_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions\segMotility.Path.csv']; 
imageFrameTimes = getImageFrameTimes(frameTime_file);

%%
cellNum = 25;
dynThr = 25*12.98;
medSize = 12;
pksWin = 25;

flowFiltered = medfilt1(flowmeterValues,medSize);

edgeFlowSamples = find(diff(flowFiltered>dynThr)~=0)';
edgeFlowTimes = flowmeterTimes(edgeFlowSamples);
numEdges = length(edgeFlowTimes);
edgeFlowDirections = repmat([1 -1],[1,numEdges/2]);

for edgeNum = 1:numEdges
    [~,idx(edgeNum)] = min(abs(imageFrameTimes-edgeFlowTimes(edgeNum)));
end

for edgeNum = 1:2:numEdges
    window = cell_WCdiff{cellNum}(idx(edgeNum)-pksWin:idx(edgeNum)+pksWin);
    [extremaValue(edgeNum),pos] = min(window);
    extremaPos(edgeNum) = pos+idx(edgeNum)-pksWin;
    
    window = cell_WCdiff{cellNum}(idx(edgeNum+1)-pksWin:idx(edgeNum+1)+pksWin);
    [extremaValue(edgeNum+1),pos] = max(window);
    extremaPos(edgeNum+1) = pos+idx(edgeNum+1)-pksWin;
end


G = (([50 50 50 50 100 100 100 100]/10)./abs(extremaValue(1:2:end)-extremaValue(2:2:end))).*median(cell_Height{cellNum});
meanG = mean(G);

%%
figure
yyaxis left
plot(flowmeterTimes,flowFiltered)
hold on
plot(edgeFlowTimes,dynThr*ones(1,length(edgeFlowTimes)).*edgeFlowDirections,'ro')
yyaxis right
plot(imageFrameTimes,cell_WCdiff{cellNum})
plot(imageFrameTimes(extremaPos),extremaValue,'go')