function [extremaPos,extremaVal] = get_window_extrema(signal,idx,pksWin,isMax)



ind = idx-pksWin:idx+pksWin;
ind(ind<=0 | ind>length(signal))=[];
window = signal(ind);
if isMax
    [extremaVal,pos] = max(window);
else
    [extremaVal,pos] = min(window);
end

extremaPos = pos+idx-pksWin-1;

                
                
end