function [imageFrameTimes] = getImageFrameTimes(frameTime_file)
    imageFrameTimes = importdata(frameTime_file);
    dtv = datevec(datetime(imageFrameTimes.textdata(2:end,1),'InputFormat','yyyy-MM-dd HH:mm:ss.SSS'));
    da = duration(dtv(:,4:end));
    imageFrameTimes = seconds(da-da(1));
end

