function [flowmeterTimes,flowmeterValues,header] = getFlowmeterData(fname_flow)

    header = containers.Map;
    is_header = true;

    times = [];
    flows = [];
    fileID = fopen(fname_flow, 'r');
    while ~feof(fileID)
        line = fgetl(fileID);
        if is_header
            if contains(line, '###header_end###')
                is_header = false;
            else
                split_line = split(line, ' ');
                key = split_line{1};
                rest = strjoin(split_line(2:end), ' ');
                header(key) = strtrim(rest);
            end
        else
            data_split = split(line, ';');
            time = to_sec(data_split{1});
            flow = str2double(data_split{2});
            times(end+1) = time;
            flows(end+1) = flow;
        end
    end
    fclose(fileID);

    if ~isKey(header, 'Pa_is_xx_ml/min')
        rates_pa = str2double(split(header('rates_Pa'), ','));
        rates_mlmin = str2double(split(header('rates_ml/min'), ','));
        header('Pa_is_xx_ml/min') = num2str(nanmedian(rates_mlmin ./ rates_pa));
    end

    flow_ts = times - times(1);
    flows = flows;

    flowmeterTimes = flow_ts;
        
    flowmeterValues = flows*1000;

%     if isstruct(a)
%         a = a.textdata;
%         b = cell(size(a,1),1);
%         
%         for k=1:size(a,1)
%             if k<17
%                 b{k} = a{k,1};
%             else
%                 b{k} = strjoin(a(k,:),',');
%             end
%         end
%         a = b;
%     end
%     
%     varNames = strsplit(replace(replace(replace(replace(eraseBetween(replace(replace(a{16},'"',''),' ',''),'[',']'),'[',''),']',''),'#',''),'lin','Lin'),';');
%     
%     tmp = a(17:end);
%     tmp = cellfun(@(x) str2num(replace(replace(replace(x,',','.'),'"',''),' ',''))',tmp,'UniformOutput',false);
%     tmp = cell2mat(tmp);
%     flowmeterData = table(tmp(:,1),tmp(:,2)-tmp(1,2),tmp(:,3).*1000,tmp(:,4),tmp(:,5),'VariableNames',varNames);
end


function seconds = to_sec(time_str)
    time_split = split(time_str, ':');
    h = str2double(time_split(1));
    m = str2double(time_split(2));
    s = str2double(time_split(3));
    seconds = h * 60 * 60 + m * 60 + s;
end