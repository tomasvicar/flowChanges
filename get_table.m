clear all;close all;clc;
addpath('utils')


% data_folder = 'Z:\999992-nanobiomed\Holograf\data_shear_stress_2021';
data_folder = 'G:\Sdílené disky\Quantitative GAČR\data\data_shear_stress_2021';


paths = {};
infos = {};
flow_folders = {};


path = [data_folder '\21-02-04 - Shearstress 22Rv1 + PC3-50rez 48h\'];
info = readtable([path 'info_04_02_21.xlsx']);
flow_folder = [path 'exp_04_02_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\21-01-28 - Shear stress 14h vs 1week PC3 untreated\'];
info = readtable([path 'info_28_01_21.xlsx']);
flow_folder = [path 'exp_28_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];



path =  [data_folder '\21-01-26 - Shearstress 24h-4h PC3\'];
info = readtable([path 'info_26_01_21.xlsx']);
flow_folder = [path 'exp_26_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\21-02-05 - Shearstress PC3 docetax 200nM 24h cytD 1uM\'];
info = readtable([path 'info_05_02_21.xlsx']);
flow_folder = [path 'exp_05_02_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\'];
info = readtable([path 'info_29_01_21.xlsx']);
flow_folder = [path 'exp_29_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = [data_folder '\21-01-27 - Shear stress vzestupny 22Rv1 PC3\'];
info = readtable([path 'info_27_01_21.xlsx']);
flow_folder = [path 'exp_27_01_21'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


path = [data_folder '\20-12-10 - Shearstress PC3 calA ruzne dyny\'];
info = readtable([path 'info_10_12_20.xlsx']);
flow_folder = [path 'exp_10_12_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = [data_folder '\20-12-18 PC3 vs 22Rv1_4days_post_seeding\'];
info = readtable([path 'info_18_12_20.xlsx']);
flow_folder = [path 'exp_18_12_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];

path = [data_folder '\20-11-19 - Shearstress PC3 various dyn time\'];
info = readtable([path 'info_19_11_20.xlsx']);
flow_folder = [path 'exp_19_11_20'];

paths =[paths path];
infos = [infos {info}];
flow_folders = [flow_folders flow_folder];


main_folder_num = 9;
path =paths{main_folder_num};
info = infos{main_folder_num};
flow_folder = flow_folders{main_folder_num} ;




info_used = info(:,{'folder','cell','fov','note'});



path = [data_folder '\21-02-04 - Shearstress 22Rv1 + PC3-50rez 48h\'];
file_names_tmp = {...
    '01_WP1_21-02-04_Well1_FOV1_22Rv1_untreated_48h_50-100','22Rv1',1,'48h','opakovani 22Rv1 - predtim byly v male denzite. prvni jamka divne slaby signal'
    '02_WP1_21-02-04_Well1_FOV2_22Rv1_untreated_48h_50-100','22Rv1',2,'48h',''
    '03_WP1_21-02-04_Well1_FOV3_22Rv1_untreated_48h_50-100','22Rv1',3,'48h',''
    '04_WP1_21-02-04_Well2_FOV1_22Rv1_untreated_48h_50-100','22Rv1',1,'48h','well 2 bublina splachla pred merenim dost bunek. pumpa ma od zacatku divne oscilace'
    '05_WP1_21-02-04_Well4_FOV1_PC-3-50_Zn_48h_50-100','PC-3-50',1,'48h',''
    '06_WP1_21-02-04_Well4_FOV2_PC-3-50_Zn_48h_50-100','PC-3-50',2,'48h',''
    '07_WP1_21-02-04_Well4_FOV3_PC-3-50_Zn_48h_50-100','PC-3-50',3,'48h',''
    '08_WP1_21-02-04_Well5_FOV1_PC-3-50_Zn_48h_50-100','PC-3-50',1,'48h',''
    '09_WP1_21-02-04_Well5_FOV2_PC-3-50_Zn_48h_50-100','PC-3-50',2,'48h',''
    '10_WP1_21-02-04_Well5_FOV3_PC-3-50_Zn_48h_50-100','PC-3-50',3,'48h',''
    '11_WP1_21-02-04_Well5_FOV4_PC-3-50_Zn_48h_50-100','PC-3-50',4,'48h',''
    '12_WP1_21-02-04_Well6_FOV1_PC-3-50_Zn_48h_50-100_glass+bubble','PC-3-50',1,'48h','schvalne pridana cca 0.5 ml bublina/9ml medium - test dekonvoluce'
    '13_WP1_21-02-04_Well6_FOV2_PC-3-50_Zn_48h_50-100_glass+bubble','PC-3-50',2,'48h',''
    '14_WP1_21-02-04_Well6_FOV3_PC-3-50_Zn_48h_50-100_glass+bubble','PC-3-50',3,'48h','13:08 bublina, urvala 2 bunky a pozdeji vsechny ostatni'
    };

path = [data_folder '\21-01-28 - Shear stress 14h vs 1week PC3 untreated\'];
file_names_tmp = {...
    '01_WP1_21-01-28_Well1_FOV1_PC-3_untreated_14h_50-100','PC-3',1,'14h','pumpa se chova divne - ale bnejake vychylovani videt je. v komore jsou bubliny i po prepojeni proto pak do druhe jamy'
    '02_WP1_21-01-28_Well2_FOV1_PC-3_untreated_14h_50-100','PC-3',1,'14h',''
    '03_WP1_21-01-28_Well2_FOV2_PC-3_untreated_14h_50-100','PC-3',2,'14h',''
    '04_WP1_21-01-28_Well2_FOV3_PC-3_untreated_14h_50-100','PC-3',3,'14h','cca 300 um od horniho okraje. 11:07 cvakanec, po manualni korekci se urvaly vsechny bb'
    '05_WP1_21-01-28_Well3_FOV1_PC-3_untreated_14h_50-100','PC-3',1,'14h','divny prutok  - bublina?'
    '06_WP1_21-01-28_Well3_FOV2_PC-3_untreated_14h_50-100','PC-3',2,'14h',''
    '07_WP1_21-01-28_Well3_FOV3_PC-3_untreated_14h_50-100','PC-3',3,'14h',''
    '08_WP1_21-01-28_Well3_FOV4_PC-3_untreated_14h_50-100','PC-3',4,'14h','12:36 pukanec'
    '09_WP2_21-01-28_Well1_FOV1_PC-3_untreated_1w_50-100','PC-3',1,'7days','vyssi confluence'
    '10_WP2_21-01-28_Well1_FOV2_PC-3_untreated_1w_50-100','PC-3',2,'7days',''
    '11_WP2_21-01-28_Well1_FOV3_PC-3_untreated_1w_50-100','PC-3',3,'7days',''
    '12_WP2_21-01-28_Well2_FOV1_PC-3_untreated_1w_50-100','PC-3',1,'7days','13:29 konec - cvakla pumpa'
    '13_WP2_21-01-28_Well2_FOV2_PC-3_untreated_1w_50-100','PC-3',2,'7days',''
    '14_WP2_21-01-28_Well2_FOV3_PC-3_untreated_1w_50-100','PC-3',3,'7days',''
    '15_WP2_21-01-28_Well3_FOV1_PC-3_untreated_1w_30-to-120_ascending','PC-3',1,'7days',''
    '16_WP2_21-01-28_Well3_FOV2_PC-3_untreated_1w_30-to-120_ascending','PC-3',2,'7days',''
    '17_WP2_21-01-28_Well3_FOV3_PC-3_untreated_1w_30-to-120_ascending','PC-3',3,'7days',''
    '18_WP2_21-01-28_Well3_FOV1_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',1,'7days',''
    '19_WP2_21-01-28_Well3_FOV2_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',2,'7days',''
    '20_WP2_21-01-28_Well3_FOV3_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',3,'7days','3:41 poklesla kvalita signalu, jinak ale bunky ok'
    '21_WP2_21-01-28_Well4_FOV1_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',1,'7days',''
    '22_WP2_21-01-28_Well4_FOV2_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',2,'7days',''
    '23_WP2_21-01-28_Well4_FOV3_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',3,'7days',''
    };


path =  [data_folder '\21-01-26 - Shearstress 24h-4h PC3\'];
file_names_tmp = {...
    '01_WP1_21-01-26_Well1_FOV1_PC-3_untreated_24h_50-100','PC-3',1,'24h','NA kompenzace pozadi jiz na 0.3. Novy QPHASE software. nejdriv tekla privodni hadice, vyreseno, ale pak malo bunek. uz i z PC3 to vymackava bleby.  pocinaje dneskem 3x50 a 3x100'
    '02_WP1_21-01-26_Well1_FOV2_PC-3_untreated_24h_50-100','PC-3',2,'24h','vicejaderna bunka, nebyvale hodne sedi. brat s opatrnosti, ale ok'
    '03_WP1_21-01-26_Well1_FOV3_PC-3_untreated_24h_50-100','PC-3',3,'24h',''
    '04_WP1_21-01-26_Well2_FOV1_PC-3_untreated_24h_50-100','PC-3',1,'24h',''
    '05_WP1_21-01-26_Well2_FOV2_PC-3_untreated_24h_50-100','PC-3',2,'24h',''
    '06_WP1_21-01-26_Well2_FOV3_PC-3_untreated_24h_50-100','PC-3',3,'24h',''
    '07_WP1_21-01-26_Well3_FOV1_PC-3_untreated_24h_50-100','PC-3',1,'24h','abort-bublina'
    '08_WP1_21-01-26_Well3_FOV2_PC-3_untreated_24h_50-100','PC-3',2,'24h','po predchozi bubline vypadaji potrhane, nebrat, pak  se stejne utrhly.'
    '09_WP2_21-01-26_Well1_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'4h','bublina nebrat'
    '10_WP2_21-01-26_Well2_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'4h',''
    '11_WP2_21-01-26_Well2_FOV2_PC-3_untreated_4h_50-100','PC-3',2,'4h',''
    '12_WP2_21-01-26_Well2_FOV3_PC-3_untreated_4h_50-100','PC-3',3,'4h',''
    '13_WP2_21-01-26_Well3_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'4h',''
    '14_WP2_21-01-26_Well3_FOV3_PC-3_untreated_4h_50-100','PC-3',2,'4h',''
    '15_WP2_21-01-26_Well3_FOV3_PC-3_untreated_4h_50-100','PC-3',3,'4h',''
    '16_WP2_21-01-26_Well5_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'4h','4 zor pole bublina, nejsou ani data, proto rovnou na 5. bunky se ale urvaly v pulce mereni'
    '17_WP2_21-01-26_Well6_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'4h','14:43 neco prolitlo a utrhlo cast bunek - nebo to byl zacatek pulzu?'
    '18_WP2_21-01-26_Well6_FOV2_PC-3_untreated_4h_50-100','PC-3',2,'4h',''
    '19_WP2_21-01-26_Well6_FOV3_PC-3_untreated_4h_50-100','PC-3',3,'4h','15:00 pukanec - průůtok pak divný'
    };


path = [data_folder '\21-02-05 - Shearstress PC3 docetax 200nM 24h cytD 1uM\'];
file_names_tmp = {...
    '10_WP1_21-02-05_Well6_FOV1_PC-3_ CytD_1uM_845_added_48h_50-100','PC-3',1,'48h','prvnich10s docetaxelem se neuložilo;rozdrbalo se nastaveni restaqrt a ztracime cas;neuložilo se'
    '11_WP1_21-02-05_Well6_FOV2_PC-3_ CytD_1uM_845_added_48h_50-100','PC-3',2,'48h',''
    '12_WP1_21-02-05_Well1_FOV1_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',1,'48h',''
    '13_WP1_21-02-05_Well1_FOV2_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',2,'48h',''
    '14_WP1_21-02-05_Well1_FOV3_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',3,'48h',''
    '15_WP1_21-02-05_Well1_FOV4_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',4,'48h',''
    '16_WP1_21-02-05_Well2_FOV1_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',1,'48h',''
    '17_WP1_21-02-05_Well2_FOV2_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',2,'48h',''
    '18_WP1_21-02-05_Well2_FOV3_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',3,'48h',''
    '19_WP1_21-02-05_Well2_FOV4_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',4,'48h',''
    '20_WP1_21-02-05_Well3_FOV1_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',1,'48h',''
    '21_WP1_21-02-05_Well3_FOV2_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',2,'48h',''
    '22_WP1_21-02-05_Well3_FOV3_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',3,'48h',''
    };


path = [data_folder '\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\'];
file_names_tmp = {...
    '01_WP1_21-01-29_Well2_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'48h','po druhem odpojeni odtrzeny vsechny bunky, prvni jamka testovaci proto; hnusny pomaly nastup signalu'
    '02_WP1_21-01-29_Well2_FOV2_PC-3_untreated_48h_50-100','PC-3',1,'48h','hnusny signal'
    '03_WP1_21-01-29_Well3_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'48h','prvni dobra nahravka dneska. po vymene vsech hadic'
    '04_WP1_21-01-29_Well3_FOV2_PC-3_untreated_48h_50-100','PC-3',2,'48h',''
    '05_WP1_21-01-29_Well3_FOV3_PC-3_untreated_48h_50-100','PC-3',3,'48h',''
    '06_WP1_21-01-29_Well3_FOV4_PC-3_untreated_48h_50-100','PC-3',4,'48h',''
    '07_WP1_21-01-29_Well3_FOV5_PC-3_untreated_48h_50-100','PC-3',5,'48h',''
    '08_WP1_21-01-29_Well6_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'48h','well 4 nebyly skoro  zadne, 5 preskakuji'
    '09_WP1_21-01-29_Well6_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'48h',''
    '10_WP1_21-01-29_Well6_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'48h',''
    '11_WP1_21-01-29_Well6_FOV4_PC-3_CytD_3h_10uM_48h_50','PC-3',4,'48h','divne - vubec se nehybou oproti prvniho prutoku.....'
    '12_WP1_21-01-29_Well5_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'48h',''
    '13_WP1_21-01-29_Well5_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'48h',''
    '14_WP1_21-01-29_Well5_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'48h',''
    };



path = [data_folder '\21-01-27 - Shear stress vzestupny 22Rv1 PC3\'];
file_names_tmp = {...
    '01_WP1_21-01-27_Well1_FOV1_PC-3_untreated_48h_seq30-to-150','PC-3',1,'48h','velka bublina co nejde odplachnout ani 40 dyny, presto zkusime merit. 11:32 cvaknuti'
    '02_WP1_21-01-27_Well1_FOV1_PC-3_untreated_48h_seq30-to-150','PC-3',1,'48h','stejne zp znova - cvaknuti pumpy v predeslem runu. 11:46 utrzeni pri zmizeni bubliny - abort'
    '03_WP1_21-01-27_Well1_FOV2_PC-3_untreated_48h_seq30-to-150','PC-3',2,'48h','11:55 klapnuti - netece pri posl pulzu'
    '04_WP1_21-01-27_Well2_FOV1_PC-3_untreated_48h_seq30-to-150','PC-3',1,'48h','na začátku divný průtok, pak to ale vypadá dobře. Prvni vzestupny co mame cely az do konce'
    '05_WP1_21-01-27_Well2_FOV2_PC-3_untreated_48h_seq30-to-150','PC-3',2,'48h',''
    '06_WP1_21-01-27_Well2_FOV3_PC-3_untreated_48h_seq30-to-150','PC-3',3,'48h',''
    '07_WP1_21-01-27_Well3_FOV1_PC-3_untreated_48h_seq30-to-120','PC-3',1,'48h','odsud dál vyřazujeme posled 2 stressy - končíme 12 Pa'
    '08_WP1_21-01-27_Well3_FOV2_PC-3_untreated_48h_seq30-to-120','PC-3',2,'48h','dost u pravého kraje pozor!'
    '09_WP1_21-01-27_Well3_FOV3_PC-3_untreated_48h_seq30-to-120','PC-3',3,'48h','dost u pravého kraje pozor!'
    '10_WP1_21-01-27_Well3_FOV4_PC-3_untreated_48h_seq30-to-120','PC-3',4,'48h',''
    '11_WP1_21-01-27_Well4_FOV1_22Rv1_untreated_48h_seq30-to-120','22Rv1',1,'48h','u 22Rv1 velmi málo bunek, mereno prakticky po jedne bunce/FOV'
    '12_WP1_21-01-27_Well4_FOV2_22Rv1_untreated_48h_seq30-to-120','22Rv1',2,'48h',''
    '13_WP1_21-01-27_Well4_FOV3_22Rv1_untreated_48h_seq30-to-120','22Rv1',3,'48h',''
    '14_WP1_21-01-27_Well4_FOV4_22Rv1_untreated_48h_seq30-to-120','22Rv1',4,'48h','15:42 blebbing, ale jinak bypada, ze to ustoji, pokracuje dal, blebbing v kazdem dalsim pulzu, 3:46 dojelo na brzdu, i kdyz by mohlo pokracovat dal'
    '15_WP1_21-01-27_Well5_FOV1_22Rv1_untreated_48h_seq30-to-120','22Rv1',1,'48h','16:10  se jedna z bunek urvala  - do te doby bude tezke urcit teziste'
    '16_WP1_21-01-27_Well5_FOV2_22Rv1_untreated_48h_seq30-to-120','22Rv1',2,'48h','bunka ma velkou vakuolu, pred predchozimi shear stresssy ji nemela. otazka jak to ovlivni modulus. prutok celou dobu experimentu klesa velmi pomalu'
    '17_WP1_21-01-27_Well6_FOV1_22Rv1_untreated_48h_seq30-to-120','22Rv1',1,'48h','blizko L kraje'
    '18_WP1_21-01-27_Well6_FOV2_22Rv1_untreated_48h_seq30-to-120','22Rv1',2,'48h','blizko L kraje'
    '19_WP1_21-01-27_Well6_FOV3_22Rv1_untreated_48h_seq30-to-120','22Rv1',3,'48h',''
    };


path = [data_folder '\20-12-10 - Shearstress PC3 calA ruzne dyny\'];
file_names_tmp = {...
    '01_WP1_20-11-23-full-confl_Well1_PC-3_untreated_100-200','PC3',1,'17days',''
    '02_WP1_20-11-23-full-confl_Well1_PC-3_untreated_50-100','PC3',2,'17days',''
    '03_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions_littlebitcool medium','PC3',1,'17days',''
    '04_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions','PC3',2,'17days',''
    '05_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions','PC3',3,'17days',''
    '06_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions','PC3',4,'17days',''
    '07_WP1_20-11-23-full-confl_Well2_PC-3_untreated_5to50_10steps_signal-to-noise','PC3',5,'17days',''
    '08_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50to400_step50_test_trhani','PC3',6,'17days',''
    '09_WP2_20-12-08-lo-confl_Well1_PC-3_untreated_50-100_4repetitions','PC3',1,'17days',''
    '10_WP2_20-12-08-lo-confl_Well1_PC-3_untreated_50-100_4repetitions','PC3',2,'17days',''
    '11_WP2_20-12-08-lo-confl_Well1_PC-3_untreated_50-100_4repetitions','PC3',1,'17days',''
    '12_WP3_20-11-23-lo-confl_Well3_PC-3_untreated_50-100_4repetitions','PC3',2,'17days',''
    '13_WP3_20-11-23-lo-confl_Well3_PC-3_untreated_50-100_4repetitions','PC3',3,'17days',''
    '14_WP3_20-11-23-lo-confl_Well3_PC-3_untreated_50-100_4repetitions_v_predchozim kosstricky_mereni_na_nich','PC3',4,'17days',''
    '15_WP3_20-11-23-lo-confl_Well4_PC-3_5nMCalA_50-100_napreskacku_4repetitions','PC3',1,'17days','treat'
    '16_WP3_20-11-23-lo-confl_Well5_PC-3_5nMCalA_50-100_napreskacku_4repetitions','PC3',1,'17days','treat'
    '17_WP3_20-11-23-lo-confl_Well6_PC-3_5nMCalA_50-100_napreskacku_4repetitions_','PC3',1,'17days','treat'
    '18_WP3_20-11-23-lo-confl_Well6_PC-3_5nMCalA_50-100_napreskacku_4repetitions_','PC3',2,'17days','treat'
    };




path = [data_folder '\20-12-18 PC3 vs 22Rv1_4days_post_seeding\'];
file_names_tmp = {...
    '01_WP1_20-12-18_Well1_FOV1_PC-3_untreated_50-100','PC-3',1,'4days','NA celého exp. rovna NA objektivu = 0.30'
    '02_WP1_20-12-18_Well1_FOV2_PC-3_untreated_50-100','PC-3',2,'4days',''
    '03_WP1_20-12-18_Well1_FOV3_PC-3_untreated_50-100','PC-3',3,'4days',''
    '04_WP1_20-12-18_Well2_FOV1_PC-3_untreated_50-100','PC-3',1,'4days','11:15 cvakla pumpa, ale dojelo skoro cele'
    '05_WP1_20-12-18_Well2_FOV2_PC-3_untreated_50-100','PC-3',2,'4days',''
    '06_WP1_20-12-18_Well4_FOV1_22Rv1_untreated_50-100','22Rv1',1,'4days','blbe jsem pojmenoval, korektura az potom'
    '07_WP1_20-12-18_Well4_FOV2_22Rv1_untreated_50-100','22Rv1',2,'4days',''
    '08_WP1_20-12-18_Well4_FOV3_22Rv1_untreated_50-100','22Rv1',3,'4days','urvaly se 14:15'
    '09_WP1_20-12-18_Well5_FOV1_22Rv1_untreated_50-100','22Rv1',1,'4days',''
    '10_WP1_20-12-18_Well5_FOV2_22Rv1_untreated_50-100','22Rv1',2,'4days',''
    '11_WP1_20-12-18_Well5_FOV3_22Rv1_untreated_50-100','22Rv1',3,'4days',''
    '12_WP1_20-12-18_Well5_FOV3_22Rv1_untreated_100-200','22Rv1',3,'4days','postupne se urvaly vsechny, 200 je moc'
    '13_WP1_20-12-18_Well6_FOV1_22Rv1_untreated_30to300','22Rv1',1,'4days','15:27 tam neco prolitlo a cast urvalo. neni cely zaznam, jen 7 min - chybí posledni (?) puls - navazuje dalsim souborem - chybi cca 10 s: dalsi soubor 13_WP1_20-12-18_Well6_FOV1_22Rv1_untreated_30to300_pt_2'
    '14_WP1_20-12-18_Well3_FOV1_PC-3_untreated_30to300','PC-3',1,'4days','cely divny, divny pulzy s bunama nic moc nedela'
    '15_WP1_20-12-18_Well3_FOV1_PC-3_untreated_30to300','PC-3',1,'4days','stejny zorny pole znova po znovuutazeni strikacky'
    };


path = [data_folder '\20-11-19 - Shearstress PC3 various dyn time\'];
file_names_tmp = {...
    '03_well03_PC3_untreated_48hseed_10spulse050dyn','PC3',1,'48h','48h seed'
    '04_well03_PC3_untreated_48hseed_10spulse100dyn','PC3',1,'48h','48h seed'
    '05_well03_PC3_untreated_48hseed_20spulse100dyn','PC3',1,'48h','48h seed'
    '06_well03_PC3_untreated_48hseed_20spulse150dyn','PC3',1,'48h','48h seed'
    '07_well04_PC3_untreated_48hseed_20spulse_mix050-100dyn','PC3',1,'48h','48h seed'
    '08_well04_PC3_untreated_48hseed_20spulse_mix100-200dyn_fix','PC3',2,'48h','48h seed'
    '09_well05_PC3_untreated_48hseed_20spulse_mix100-200dyn','PC3',1,'48h','48h seed'
    '10_well05_PC3_untreated_48hseed_20spulse_mix100-200dyn','PC3',2,'48h','48h seed'
    '11_well06_PC3_untreated_48hseed_20spulse_mix100-200dyn','PC3',1,'48h','48h seed'
    };




