clc;clear all;close all force;
addpath('utils')
addpath('utils/plotSpread')


file_names = subdir('data_bubble/*_signals.mat');



% file_names = file_names([1:11]);



GGG = [];
nnn = [];
groupp ={};



Gs_all = [];
nis_all = [];
group = {};


for file_num = 1:length(file_names)
    
    file_name = file_names(file_num).name
    
    data = load(file_name);
    
    
%     res = load(replace(file_names(file_num).name,'_signals','_results_polynom_whole'));
%     res = load(replace(file_names(file_num).name,'_signals','_results_polynom_5Pa'))
    res = load(replace(file_names(file_num).name,'_signals','_results_fit'));


    [filepath,name,ext] = fileparts(file_name);
    
    Gs_all = [Gs_all,res.Gs ];
    nis_all = [nis_all,res.nis ];
    group = [group, repmat({name},[1,length(res.nis)])];
    
%     Gs_all = [Gs_all,median(res.Gs)];
%     nis_all = [nis_all,median(res.nis)];
%     group = [group,name];
end
remove= [];

% group(1:6)={'hard'}  ;
% group(7:end)={'soft'}  ;
% remove= [remove 4];


% remove= [remove find(cellfun(@(x) contains(x,'05_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'06_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'07_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'08_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'09_WP'),group))];

bubble = cellfun(@(x) contains(x,'bubble'),group)  ;
group(bubble)={'w/ bubble fit'} ;
group(~bubble)={'w/o bubble fit'} ;


% remove= [remove 66:78];
% remove =  [remove 167:194];
% remove =  [remove find(nis_all<20|nis_all>400)];
% remove =  [remove find(Gs_all<12|Gs_all>80)];
Gs_all(remove) =[];
nis_all(remove) =[];
group(remove) =[];



GGG = [GGG,Gs_all];
nnn = [nnn,nis_all];
groupp = [groupp,group];



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
% remove= [];

% group(1:6)={'hard'}  ;
% group(7:end)={'soft'}  ;
% remove= [remove 4];

% 
% remove= [remove find(cellfun(@(x) contains(x,'05_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'06_WP'),group))];

bubble = cellfun(@(x) contains(x,'bubble'),group)  ;
group(bubble)={'w/ bubble deconv'} ;
group(~bubble)={'w/o bubble deconv'} ;


% remove= [remove 66:78];
% remove =  [remove 167:194];
% remove =  [remove find(nis_all<20|nis_all>400)];
% remove =  [remove find(Gs_all<12|Gs_all>80)];
Gs_all(remove) =[];
nis_all(remove) =[];
group(remove) =[];



GGG = [GGG,Gs_all];
nnn = [nnn,nis_all];
groupp = [groupp,group];



Gs_all = [];
nis_all = [];
group = {};



for file_num = 1:length(file_names)
    
    file_name = file_names(file_num).name
    
    data = load(file_name);
    
    
%     res = load(replace(file_names(file_num).name,'_signals','_results_polynom_whole'));
%     res = load(replace(file_names(file_num).name,'_signals','_results_polynom_5Pa'))
%     res = load(replace(file_names(file_num).name,'_signals','_results_fit'));
    res = load(replace(file_names(file_num).name,'_signals','_results_minmax'));

    [filepath,name,ext] = fileparts(file_name);
    
    Gs_all = [Gs_all,res.Gs ];
    group = [group, repmat({name},[1,length(res.nis)])];
    
    
    
    
%     Gs_all = [Gs_all,median(res.Gs)];
%     nis_all = [nis_all,median(res.nis)];
%     group = [group,name];
end
% remove= [];

% group(1:6)={'hard'}  ;
% group(7:end)={'soft'}  ;
% remove= [remove 4];



% remove= [remove find(cellfun(@(x) contains(x,'05_WP'),group))];
% remove= [remove find(cellfun(@(x) contains(x,'06_WP'),group))];

bubble = cellfun(@(x) contains(x,'bubble'),group)  ;
group(bubble)={'w/ bubble minmax'} ;
group(~bubble)={'w/o bubble minmax'} ;


% remove= [remove 66:78];
% remove =  [remove 167:194];
% remove =  [remove find(nis_all<20|nis_all>400)];
% remove =  [remove find(Gs_all<12|Gs_all>80)];
Gs_all(remove) =[];
group(remove) =[];




GGG = [GGG,Gs_all];
% nnn = [nnn,nis_all];
groupp_G = [groupp,group];
groupp_ni = groupp;






figure;
boxplot_special(groupp_G,GGG)
ylabel('G')
xtickangle(-45)
% [h,p] = ttest2(Gs_all(strcmp(group,'hard')),Gs_all(strcmp(group,'soft')));
% title(['p=' num2str(p)]);

figure;
boxplot_special(groupp_ni,nnn)
ylabel('ni')
xtickangle(-45)
% [h,p] = ttest2(nis_all(strcmp(group,'hard')),nis_all(strcmp(group,'soft')));
% title(['p=' num2str(p)]);







