clc;clear all;close all force;
addpath('utils')
addpath('utils/plotSpread')

file_names = subdir('data_hard_soft_syringe/*_signals.mat');

file_names = file_names([1:11]);


Gs_all = [];
nis_all = [];
group = {};



for file_num = 1:length(file_names)
    
    file_name = file_names(file_num).name
    
    data = load(file_name);
    
    
    res = load(replace(file_names(file_num).name,'_signals','_results_polynom_whole'));
    
    
    [filepath,name,ext] = fileparts(file_name);
    
    Gs_all = [Gs_all,res.Gs ];
    nis_all = [nis_all,res.nis ];
    group = [group, repmat({name},[1,length(res.nis)])];
    
    
    
end

figure;
boxplot_special(group,Gs_all)
ylabel('G')
xtickangle(-45)

figure;
boxplot_special(group,nis_all)
ylabel('ni')
xtickangle(-45)