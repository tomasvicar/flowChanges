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




info_used = info(:,{'folder','cell','fov','firstflow','starttime','note'});



path = [data_folder '\21-03-12 - Shearstress PC3 PC3doc PC3CytD\'];
file_name_tmp ={...
    '01_WP1_21-03-12_Well1_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.409722222222222,0.418750000000000,'PC3 cislo pasaze 23 (vsechny bunky dneska)'
    '02_WP1_21-03-12_Well1_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.409722222222222,0.429166666666667,''
    '03_WP1_21-03-12_Well1_FOV3_PC-3_ unt_48h_50only_30s','PC-3',3,0.409722222222222,0.434027777777778,''
    '04_WP1_21-03-12_Well1_FOV4_PC-3_ unt_48h_50only_30s','PC-3',4,0.409722222222222,0.438888888888889,''
    '05_WP1_21-03-12_Well2_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.443750000000000,0.447222222222222,''
    '06_WP1_21-03-12_Well2_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.443750000000000,0.450694444444444,'10:51 urvaly se bunky'
    '07_WP1_21-03-12_Well3_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.454861111111111,0.459027777777778,'11:02 urvalo se hodne bunek'
    '08_WP1_21-03-12_Well4_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.464583333333333,0.470138888888889,''
    '09_WP1_21-03-12_Well4_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.464583333333333,0.474305555555556,'buňky trošku hnusný oproti předch zp'
    '10_WP1_21-03-12_Well4_FOV3_PC-3_ unt_48h_50only_30s','PC-3',3,0.464583333333333,0.477777777777778,''
    '11_WP1_21-03-12_Well4_FOV4_PC-3_ unt_48h_50only_30s','PC-3',4,0.464583333333333,0.482638888888889,''
    '12_WP1_21-03-12_Well5_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.489583333333333,0.492361111111111,''
    '13_WP1_21-03-12_Well5_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.489583333333333,0.497916666666667,'praskyly nebrat'
    '14_WP2_21-03-12_Well1_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,0.550694444444445,0.555555555555556,''
    '15_WP2_21-03-12_Well1_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,0.550694444444445,0.559722222222222,''
    '16_WP2_21-03-12_Well1_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,0.550694444444445,0.568055555555556,'podivně strmé pulsy (jakože hezké)'
    '17_WP2_21-03-12_Well1_FOV4_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',4,0.550694444444445,0.572222222222222,''
    '18_WP2_21-03-12_Well2_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,0.578472222222222,0.581944444444445,''
    '19_WP2_21-03-12_Well2_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,0.578472222222222,0.586111111111111,''
    '20_WP2_21-03-12_Well2_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,0.578472222222222,0.589583333333333,''
    '21_WP2_21-03-12_Well2_FOV4_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',4,0.578472222222222,0.593750000000000,''
    '22_WP2_21-03-12_Well3_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,0.601388888888889,0.605555555555556,''
    '23_WP2_21-03-12_Well3_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,0.601388888888889,0.611111111111111,''
    '24_WP2_21-03-12_Well3_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,0.601388888888889,0.615277777777778,''
    '25_WP3_21-03-12_Well1_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,0.635416666666667,0.636805555555556,''
    '26_WP3_21-03-12_Well1_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,0.635416666666667,0.640972222222222,''
    '27_WP3_21-03-12_Well1_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,0.635416666666667,0.645833333333333,'bliká hodně nevím jestli to pude'
    '28_WP3_21-03-12_Well1_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,0.635416666666667,0.649305555555556,''
    '29_WP3_21-03-12_Well2_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,0.654861111111111,0.658333333333333,''
    '30_WP3_21-03-12_Well2_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,0.654861111111111,0.661805555555556,''
    '31_WP3_21-03-12_Well2_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,0.654861111111111,0.665277777777778,''
    '32_WP3_21-03-12_Well2_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,0.654861111111111,0.669444444444444,''
    '33_WP3_21-03-12_Well3_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,0.674305555555556,0.677083333333333,''
    '34_WP3_21-03-12_Well3_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,0.674305555555556,0.680555555555556,''
    '35_WP3_21-03-12_Well3_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,0.674305555555556,0.684027777777778,''
    '36_WP3_21-03-12_Well3_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,0.674305555555556,0.688194444444444,''
    '37_WP3_21-03-12_Well4_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,0.692361111111111,0.697916666666667,''
    '38_WP3_21-03-12_Well4_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,0.692361111111111,0.701388888888889,''
    '39_WP3_21-03-12_Well4_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,0.692361111111111,0.705555555555556,''
    '40_WP3_21-03-12_Well4_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,0.692361111111111,0.709027777777778,'17:05 pumpa prázdná???'
    '41_WP3_21-03-12_Well5_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,0.715972222222222,0.720833333333333,''
    '42_WP3_21-03-12_Well5_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,0.715972222222222,0.724305555555556,''
    '43_WP3_21-03-12_Well5_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,0.715972222222222,0.727777777777778,''
    '44_WP3_21-03-12_Well5_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,0.715972222222222,0.731944444444444,''
    '45_WP3_21-03-12_Well6_FOV1_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',1,0.736111111111111,0.740277777777778,''
    '46_WP3_21-03-12_Well6_FOV2_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',2,0.736111111111111,0.744444444444445,''
    '47_WP3_21-03-12_Well6_FOV3_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',3,0.736111111111111,0.748611111111111,''
    '48_WP3_21-03-12_Well6_FOV4_PC-3_ 1uM_CytD_3h_1210added_48h_50only_30s','PC-3+1uM_CytD_3h',4,0.736111111111111,0.752083333333333,''
    };















