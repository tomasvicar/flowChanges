function [edgePos] = get_edges(flowmeterTimes,flowmeterValues,sumWin,minPeakHeight,peakDistance,inint_window,peakDistanceRangePer,T_period,pksWin)

minPeakDistance = peakDistance*(1-peakDistanceRangePer);
maxPeakDistance = peakDistance*(1+peakDistanceRangePer);



flowDiff = padarray(diff(flowmeterValues),[1,0],'post','replicate');
flowDiff = conv(flowDiff,ones(sumWin,1),'same');

[~,edgeTimes] = findpeaks(abs(flowDiff),flowmeterTimes,'MinPeakHeight',minPeakHeight,'MinPeakDistance',minPeakDistance);



numEdges = length(edgeTimes);
flowEdgeIdx = zeros(1,numEdges);
for edgeNum = 1:numEdges
    [~,flowEdgeIdx(edgeNum)] = min(abs(flowmeterTimes-edgeTimes(edgeNum)));
end

flowDiffValues = flowDiff(flowEdgeIdx);

posEdgeTimes = edgeTimes(flowDiffValues>0);
negEdgeTimes = edgeTimes(flowDiffValues<0);

posEdgeTimes(posEdgeTimes<inint_window) = [];
negEdgeTimes(negEdgeTimes<inint_window) = [];

if isempty(posEdgeTimes)||isempty(negEdgeTimes)
    edgePos =[];
    return
end
D = pdist2(posEdgeTimes,negEdgeTimes,@(x,y) x-y);
D(D<minPeakDistance) = NaN;
D(D>maxPeakDistance) = NaN;
D = abs(peakDistance-D);



[assignment,~] = munkres(D);

posEdgeTimes = posEdgeTimes(assignment>0);
negEdgeTimes = negEdgeTimes(assignment(assignment>0));

[posEdgeTimes,sort_vec] = sort(posEdgeTimes);
negEdgeTimes = negEdgeTimes(sort_vec);


edgeTimes = [];
for k = 1:length(posEdgeTimes)
    edgeTimes = [edgeTimes,posEdgeTimes(k),negEdgeTimes(k)];
end

edgeTimes(edgeTimes>(flowmeterTimes(end)-pksWin)) = [];

edgePos = round(edgeTimes/T_period +1);


end

function d = mydist(x,y)

    d = y-x;
    

end