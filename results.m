clc;clear all;close all force;
addpath('utils')
addpath('utils/plotSpread')

file_names = subdir('data_hard_soft_syringe/*_signals.mat');

% file_names = file_names([1:11]);


Gs_all = [];
nis_all = [];
group = {};


for file_num = 1:length(file_names)
    
    file_name = file_names(file_num).name
    
    data = load(file_name);
    
    
%     res = load(replace(file_names(file_num).name,'_signals','_results_polynom_whole'));
    res = load(replace(file_names(file_num).name,'_signals','_results_polynom_5Pa'))
%     res = load(replace(file_names(file_num).name,'_signals','_results_fit'));


    [filepath,name,ext] = fileparts(file_name);
    
    Gs_all = [Gs_all,res.Gs ];
    nis_all = [nis_all,res.nis ];
    group = [group, repmat({name},[1,length(res.nis)])];
    
%     Gs_all = [Gs_all,median(res.Gs)];
%     nis_all = [nis_all,median(res.nis)];
%     group = [group,name];
end
remove= [];

% remove= [remove find(cellfun(@(x) contains(x,'9_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'12_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'18_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'21_WP'),group))];


% soft = cellfun(@(x) contains(x,'20mlBraunSyringe'),group)  ;
% group(soft)={'soft'} ;
% group(~soft)={'hard'} ;



Gs_all(remove) =[];
nis_all(remove) =[];
group(remove) =[];


figure;
boxplot_special(group,Gs_all)
ylabel('G')
xtickangle(-45)
[h,p] = ttest2(Gs_all(strcmp(group,'hard')),Gs_all(strcmp(group,'soft')));
title(['p=' num2str(p)]);

figure;
boxplot_special(group,nis_all)
ylabel('ni')
xtickangle(-45)
[h,p] = ttest2(nis_all(strcmp(group,'hard')),nis_all(strcmp(group,'soft')));
title(['p=' num2str(p)]);







