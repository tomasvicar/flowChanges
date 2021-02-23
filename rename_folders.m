clear all;close all;clc;
addpath('utils')

paths = {};
infos = {};
flow_folders = {};


path = 'Z:\999992-nanobiomed\Holograf\21-02-04 - Shearstress 22Rv1 + PC3-50rez 48h\';
info = readtable([path 'info_04_02_21.xlsx']);
flow_folder = [path 'exp_04_02_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = 'Z:\999992-nanobiomed\Holograf\21-01-28 - Shear stress 14h vs 1week PC3 untreated\';
info = readtable([path 'info_28_01_21.xlsx']);
flow_folder = [path 'exp_28_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];



path = 'Z:\999992-nanobiomed\Holograf\21-01-26 - Shearstress 24h-4h PC3\';
info = readtable([path 'info_26_01_21.xlsx']);
flow_folder = [path 'exp_26_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = 'Z:\999992-nanobiomed\Holograf\21-02-05 - Shearstress PC3 docetax 200nM 24h cytD 1uM\';
info = readtable([path 'info_05_02_21.xlsx']);
flow_folder = [path 'exp_05_02_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = 'Z:\999992-nanobiomed\Holograf\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\';
info = readtable([path 'info_29_01_21.xlsx']);
flow_folder = [path 'exp_29_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = 'Z:\999992-nanobiomed\Holograf\21-01-27 - Shear stress vzestupny 22Rv1 PC3\';
info = readtable([path 'info_27_01_21.xlsx']);
flow_folder = [path 'exp_27_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = 'Z:\999992-nanobiomed\Holograf\20-12-10 - Shearstress PC3 calA ruzne dyny\';
info = readtable([path 'info_10_12_20.xlsx']);
flow_folder = [path 'exp_10_12_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = 'Z:\999992-nanobiomed\Holograf\20-12-18 PC3 vs 22Rv1_4days_post_seeding\';
info = readtable([path 'info_18_12_20.xlsx']);
flow_folder = [path 'exp_18_12_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = 'Z:\999992-nanobiomed\Holograf\20-11-19 - Shearstress PC3 various dyn time\';
info = readtable([path 'info_19_11_20.xlsx']);
flow_folder = [path 'exp_19_11_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];





for main_folder_num = 1:length(paths)

    path =paths{main_folder_num};
    info = infos{main_folder_num};
    flow_folder = flow_folders{main_folder_num} ;


    path_save = [path 'results_1\'];


    
    for fileNum = 1:size(info,1)
        
        
        src = [path_save num2str(info.experiment(fileNum)) '\' num2str(info.experiment(fileNum)) 'results.mat'];
        dst = [path_save num2str(info.experiment(fileNum)) '\' 'results.mat'];
        
        movefile(src,dst)
        
        drawnow;
        
        
        
        src = [path_save num2str(info.experiment(fileNum))];
        dst = [path_save info.folder{fileNum}];
        
        movefile(src,dst)
        
        
        
    end
    
    
    
end

