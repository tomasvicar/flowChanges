clc;clear all;close all;



orig = "Z:\999992-nanobiomed\Holograf\21-01-26 - Shearstress 24h-4h PC3\01_WP1_21-01-26_Well1_FOV1_PC-3_untreated_24h_50-100\Compensated phase - [0000, 0000]_orig.tiff";



new = "Z:\999992-nanobiomed\Holograf\21-01-26 - Shearstress 24h-4h PC3\01_WP1_21-01-26_Well1_FOV1_PC-3_untreated_24h_50-100\Compensated phase - [0000, 0000].tiff";


time = "Z:\999992-nanobiomed\Holograf\21-01-26 - Shearstress 24h-4h PC3\01_WP1_21-01-26_Well1_FOV1_PC-3_untreated_24h_50-100\time.txt";



fid  = fopen(time);

times = textscan(fid,'%s','Delimiter','\t');
times = times{1};
fclose(fid);


for k = 1:length(times)

    I1 = imread(orig,k);
    I2 = imread(new,k);
    
    tmp = abs(I1 -I2);
    tmp = sum(tmp(:));
    disp(tmp)
end




