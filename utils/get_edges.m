function [edgeTimes] = get_edges(flowmeterTimes,flowmeterValues,sumWin,minPeakHeight,minPeakDistance)



flowDiff = padarray(diff(flowmeterValues),[1,0],'post','replicate');
flowDiff = conv(flowDiff,ones(sumWin,1),'same');

[~,posEdgeTimes] = findpeaks(flowDiff,flowmeterTimes,'MinPeakHeight',minPeakHeight,'MinPeakDistance',minPeakDistance);
[~,negEdgeTimes] = findpeaks(-flowDiff,flowmeterTimes,'MinPeakHeight',minPeakHeight,'MinPeakDistance',minPeakDistance);



D = pdist2(posEdgeTimes,negEdgeTimes,@(x,y) x-y);
D(D<minPeakDistance/2) = NaN;

[assignment,~] = munkres(D);

posEdgeTimes = posEdgeTimes(assignment>0);
negEdgeTimes = negEdgeTimes(assignment(assignment>0));


edgeTimes = [];
for k = 1:length(posEdgeTimes)
    edgeTimes = [edgeTimes,posEdgeTimes(k),negEdgeTimes(k)];
end


end

function d = mydist(x,y)

    d = y-x;
    

end