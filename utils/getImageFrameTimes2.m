function [imageFrameTimes] = getImageFrameTimes2(frameTime_file)
    

    fid  = fopen(frameTime_file);
    times = textscan(fid,'%s','Delimiter','\t');
    times = times{1};
    fclose(fid);
    
    times = cellfun(@(x) replace(x,'T',' '),times,'UniformOutput',false);
    
    dtv = datevec(datetime(times,'InputFormat','yyyy-MM-dd HH:mm:ss.SSS'));
    da = duration(dtv(:,4:end));
    imageFrameTimes = seconds(da-da(1));
end