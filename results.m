clear all;close all;clc;
addpath('utils')



data_folder = 'Z:\999992-nanobiomed\Holograf';


paths = {};
infos = {};
flow_folders = {};



path = [data_folder '\23-04-13 - shearstress zinc res_tmp_matlab\'];
% info = readtable([path 'info_25_03_21.xlsx']);
flow_folder = [path 'flow'];


paths =[paths path];
% infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


filenames = subdir([path '*.tiff']);


main_folder_num =1;
    
path =paths{main_folder_num};
%     info = infos{main_folder_num};
flow_folder = flow_folders{main_folder_num} ;


path_save = [path 'results_2'];

tmp = dir([path 'results_1']);
tmp = tmp(3).name;

Gs_all = [];
groups_all = {};


for fileNum = 1:length(filenames)

    tmp_name = filenames(fileNum).name;
    image_file = tmp_name;
    [tmp_filepath,tmp_name,tmp_ext] = fileparts(tmp_name);
    tmp_name = split(tmp_filepath,'\');
    tmp_name = tmp_name{end};

    data = load([ path_save '/' tmp_name '/fit_params.mat']);

    hs = data.hs;
    Gs = data.Gs;
    etas = data.etas;
    optShear = data.optShear;

    group = split(tmp_name,'_');
    group= group{end};

    for num = 1:length(Gs)
        Gs_all = [Gs_all, Gs(num)];
        groups_all = [groups_all, group];

    end
    drawnow;

end

boxchart(categorical(groups_all),Gs_all)
ylim([0,60])