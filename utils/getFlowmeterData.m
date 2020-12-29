function [flowmeterData] = getFlowmeterData(flowMeter_file)
    a = importdata(flowMeter_file);
    varNames = strsplit(replace(replace(replace(replace(eraseBetween(replace(replace(a{16},'"',''),' ',''),'[',']'),'[',''),']',''),'#',''),'lin','Lin'),';');
    tmp = cell2mat(cellfun(@(x) str2num(replace(replace(x,',','.'),'"',''))',a(17:end),'UniformOutput',false));
    flowmeterData = table(tmp(:,1),tmp(:,2)-tmp(1,2),tmp(:,3).*1000,tmp(:,4),tmp(:,5),'VariableNames',varNames);
end

