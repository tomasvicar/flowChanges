clc;clear all;close all;

addpath('utils')

path = 'G:\Sdílené disky\Quantitative GAČR\data\20-12-18 PC3 vs 22Rv1_4days_post_seeding\results_for_eps2';


files = subdir([path '/*.avi']);

for k =1:length(files)
    
    file = files(k).name;
    
    v = VideoReader(file);
    frames = read(v,[1 Inf]);
    
    img = squeeze(frames(:,round(size(frames,2)/2),:,:));
    
    imwrite(img,replace(file,'.avi','_unroll.png'))
    
    
end






