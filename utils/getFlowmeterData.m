function [flowmeterData] = getFlowmeterData(flowMeter_file)
    a = importdata(flowMeter_file);
    if isstruct(a)
        a = a.textdata;
        b = cell(size(a,1),1);
        
        for k=1:size(a,1)
            if k<17
                b{k} = a{k,1};
            else
                b{k} = strjoin(a(k,:),',');
            end
        end
        a = b;
    end
    
    varNames = strsplit(replace(replace(replace(replace(eraseBetween(replace(replace(a{16},'"',''),' ',''),'[',']'),'[',''),']',''),'#',''),'lin','Lin'),';');
    
    tmp = a(17:end);
    tmp = cellfun(@(x) str2num(replace(replace(replace(x,',','.'),'"',''),' ',''))',tmp,'UniformOutput',false);
    tmp = cell2mat(tmp);
    flowmeterData = table(tmp(:,1),tmp(:,2)-tmp(1,2),tmp(:,3).*1000,tmp(:,4),tmp(:,5),'VariableNames',varNames);
end

