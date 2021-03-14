clear all;close all;clc;
addpath('utils')


% data_folder = 'Z:\999992-nanobiomed\Holograf\21-03-12 - Shearstress';
data_folder = 'E:\Sdílené disky\Quantitative GAČR\data\21-03-12 - Shearstress';

paths = {};
infos = {};
flow_folders = {};



path = [data_folder '\21-03-12 - Shearstress PC3 PC3doc PC3CytD\'];
info = readtable([path 'info_12_03_21.xlsx']);
flow_folder = [path 'exp_12_03_21'];


paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];



main_folder_num = 1;
path =paths{main_folder_num};
info = infos{main_folder_num};
flow_folder = flow_folders{main_folder_num} ;




info_used = info(:,{'folder','cell','fov','note'});




path = [data_folder '\21-03-12 - Shearstress PC3 PC3doc PC3CytD\'];
file_name_tmp ={...
    '01_WP1_21-03-12_Well1_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,'PC3 cislo pasaze 23 (vsechny bunky dneska)'
    '02_WP1_21-03-12_Well1_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,''
    '03_WP1_21-03-12_Well1_FOV3_PC-3_ unt_48h_50only_30s','PC-3',3,''
    '04_WP1_21-03-12_Well1_FOV4_PC-3_ unt_48h_50only_30s','PC-3',4,''
    '05_WP1_21-03-12_Well2_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,''
    '06_WP1_21-03-12_Well2_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,'10:51 urvaly se bunky'
    '07_WP1_21-03-12_Well3_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,'11:02 urvalo se hodne bunek'
    '08_WP1_21-03-12_Well4_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,''
    '09_WP1_21-03-12_Well4_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,'buňky trošku hnusný oproti předch zp'
    '10_WP1_21-03-12_Well4_FOV3_PC-3_ unt_48h_50only_30s','PC-3',3,''
    '11_WP1_21-03-12_Well4_FOV4_PC-3_ unt_48h_50only_30s','PC-3',4,''
    '12_WP1_21-03-12_Well5_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,''
    '13_WP1_21-03-12_Well5_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,'praskyly nebrat'
    '14_WP2_21-03-12_Well1_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,''
    '15_WP2_21-03-12_Well1_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,''
    '16_WP2_21-03-12_Well1_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,'podivně strmé pulsy (jakože hezké)'
    '17_WP2_21-03-12_Well1_FOV4_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',4,''
    '18_WP2_21-03-12_Well2_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,''
    '19_WP2_21-03-12_Well2_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,''
    '20_WP2_21-03-12_Well2_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,''
    '21_WP2_21-03-12_Well2_FOV4_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',4,''
    '22_WP2_21-03-12_Well3_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,''
    '23_WP2_21-03-12_Well3_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,''
    '24_WP2_21-03-12_Well3_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,''
    '25_WP3_21-03-12_Well1_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,''
    '26_WP3_21-03-12_Well1_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,''
    '27_WP3_21-03-12_Well1_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,'bliká hodně nevím jestli to pude'
    '28_WP3_21-03-12_Well1_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,''
    '29_WP3_21-03-12_Well2_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,''
    '30_WP3_21-03-12_Well2_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,''
    '31_WP3_21-03-12_Well2_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,''
    '32_WP3_21-03-12_Well2_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,''
    '33_WP3_21-03-12_Well3_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,''
    '34_WP3_21-03-12_Well3_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,''
    '35_WP3_21-03-12_Well3_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,''
    '36_WP3_21-03-12_Well3_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,''
    '37_WP3_21-03-12_Well4_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,''
    '38_WP3_21-03-12_Well4_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,''
    '39_WP3_21-03-12_Well4_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,''
    '40_WP3_21-03-12_Well4_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,'17:05 pumpa prázdná???'
    '41_WP3_21-03-12_Well5_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,''
    '42_WP3_21-03-12_Well5_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,''
    '43_WP3_21-03-12_Well5_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,''
    '44_WP3_21-03-12_Well5_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,''
    '45_WP3_21-03-12_Well6_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,''
    '46_WP3_21-03-12_Well6_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,''
    '47_WP3_21-03-12_Well6_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,''
    '48_WP3_21-03-12_Well6_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,''
    };















