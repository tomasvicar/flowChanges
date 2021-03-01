clear all;close all;clc;
addpath('utils');addpath('utils/plotSpread')


threshold = 0.2;

% data_folder = 'Z:\999992-nanobiomed\Holograf\data_shear_stress_2021';
data_folder = 'G:\Sdílené disky\Quantitative GAČR\data\data_shear_stress_2021';

file_names_qpi_image ={};

file_names = {};

path = [data_folder '\21-01-28 - Shear stress 14h vs 1week PC3 untreated\'];
file_names_tmp = {...
    '01_WP1_21-01-28_Well1_FOV1_PC-3_untreated_14h_50-100','PC-3',1,'h14','pumpa se chova divne - ale bnejake vychylovani videt je. v komore jsou bubliny i po prepojeni proto pak do druhe jamy'
    '02_WP1_21-01-28_Well2_FOV1_PC-3_untreated_14h_50-100','PC-3',1,'h14',''
    '03_WP1_21-01-28_Well2_FOV2_PC-3_untreated_14h_50-100','PC-3',2,'h14',''
    '04_WP1_21-01-28_Well2_FOV3_PC-3_untreated_14h_50-100','PC-3',3,'h14','cca 300 um od horniho okraje. 11:07 cvakanec, po manualni korekci se urvaly vsechny bb'
    '05_WP1_21-01-28_Well3_FOV1_PC-3_untreated_14h_50-100','PC-3',1,'h14','divny prutok  - bublina?'
    '06_WP1_21-01-28_Well3_FOV2_PC-3_untreated_14h_50-100','PC-3',2,'h14',''
    '07_WP1_21-01-28_Well3_FOV3_PC-3_untreated_14h_50-100','PC-3',3,'h14',''
    '08_WP1_21-01-28_Well3_FOV4_PC-3_untreated_14h_50-100','PC-3',4,'h14','12:36 pukanec'
    '09_WP2_21-01-28_Well1_FOV1_PC-3_untreated_1w_50-100','PC-3',1,'d07','vyssi confluence'
    '10_WP2_21-01-28_Well1_FOV2_PC-3_untreated_1w_50-100','PC-3',2,'d07',''
    '11_WP2_21-01-28_Well1_FOV3_PC-3_untreated_1w_50-100','PC-3',3,'d07',''
    '12_WP2_21-01-28_Well2_FOV1_PC-3_untreated_1w_50-100','PC-3',1,'d07','13:29 konec - cvakla pumpa'
    '13_WP2_21-01-28_Well2_FOV2_PC-3_untreated_1w_50-100','PC-3',2,'d07',''
    '14_WP2_21-01-28_Well2_FOV3_PC-3_untreated_1w_50-100','PC-3',3,'d07',''
%     '15_WP2_21-01-28_Well3_FOV1_PC-3_untreated_1w_30-to-120_ascending','PC-3',1,'d07',''
%     '16_WP2_21-01-28_Well3_FOV2_PC-3_untreated_1w_30-to-120_ascending','PC-3',2,'d07',''
%     '17_WP2_21-01-28_Well3_FOV3_PC-3_untreated_1w_30-to-120_ascending','PC-3',3,'d07',''
%     '18_WP2_21-01-28_Well3_FOV1_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',1,'d07',''
%     '19_WP2_21-01-28_Well3_FOV2_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',2,'d07',''
%     '20_WP2_21-01-28_Well3_FOV3_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',3,'d07','3:41 poklesla kvalita signalu, jinak ale bunky ok'
%     '21_WP2_21-01-28_Well4_FOV1_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',1,'d07',''
%     '22_WP2_21-01-28_Well4_FOV2_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',2,'d07',''
%     '23_WP2_21-01-28_Well4_FOV3_20mlBraunSyringe_diam19_PC-3_untreated_1w_50-100','PC-3',3,'d07',''
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];


file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];


path =  [data_folder '\21-01-26 - Shearstress 24h-4h PC3\'];
file_names_tmp = {...
    '01_WP1_21-01-26_Well1_FOV1_PC-3_untreated_24h_50-100','PC-3',1,'h24','NA kompenzace pozadi jiz na 0.3. Novy QPHASE software. nejdriv tekla privodni hadice, vyreseno, ale pak malo bunek. uz i z PC3 to vymackava bleby.  pocinaje dneskem 3x50 a 3x100'
    '02_WP1_21-01-26_Well1_FOV2_PC-3_untreated_24h_50-100','PC-3',2,'h24','vicejaderna bunka, nebyvale hodne sedi. brat s opatrnosti, ale ok'
    '03_WP1_21-01-26_Well1_FOV3_PC-3_untreated_24h_50-100','PC-3',3,'h24',''
    '04_WP1_21-01-26_Well2_FOV1_PC-3_untreated_24h_50-100','PC-3',1,'h24',''
    '05_WP1_21-01-26_Well2_FOV2_PC-3_untreated_24h_50-100','PC-3',2,'h24',''
    '06_WP1_21-01-26_Well2_FOV3_PC-3_untreated_24h_50-100','PC-3',3,'h24',''
%     '07_WP1_21-01-26_Well3_FOV1_PC-3_untreated_24h_50-100','PC-3',1,'h24','abort-bublina'
%     '08_WP1_21-01-26_Well3_FOV2_PC-3_untreated_24h_50-100','PC-3',2,'h24','po predchozi bubline vypadaji potrhane, nebrat, pak  se stejne utrhly.'
%     '09_WP2_21-01-26_Well1_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'h04','bublina nebrat'
    '10_WP2_21-01-26_Well2_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'h04',''
    '11_WP2_21-01-26_Well2_FOV2_PC-3_untreated_4h_50-100','PC-3',2,'h04',''
    '12_WP2_21-01-26_Well2_FOV3_PC-3_untreated_4h_50-100','PC-3',3,'h04',''
    '13_WP2_21-01-26_Well3_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'h04',''
    '14_WP2_21-01-26_Well3_FOV3_PC-3_untreated_4h_50-100','PC-3',2,'h04',''
    '15_WP2_21-01-26_Well3_FOV3_PC-3_untreated_4h_50-100','PC-3',3,'h04',''
    '16_WP2_21-01-26_Well5_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'h04','4 zor pole bublina, nejsou ani data, proto rovnou na 5. bunky se ale urvaly v pulce mereni'
    '17_WP2_21-01-26_Well6_FOV1_PC-3_untreated_4h_50-100','PC-3',1,'h04','14:43 neco prolitlo a utrhlo cast bunek - nebo to byl zacatek pulzu?'
    '18_WP2_21-01-26_Well6_FOV2_PC-3_untreated_4h_50-100','PC-3',2,'h04',''
%     '19_WP2_21-01-26_Well6_FOV3_PC-3_untreated_4h_50-100','PC-3',3,'h04','15:00 pukanec - průůtok pak divný'
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];

file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];




path = [data_folder '\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\'];
file_names_tmp = {...
%     '01_WP1_21-01-29_Well2_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'h48','po druhem odpojeni odtrzeny vsechny bunky, prvni jamka testovaci proto; hnusny pomaly nastup signalu'
%     '02_WP1_21-01-29_Well2_FOV2_PC-3_untreated_48h_50-100','PC-3',1,'h48','hnusny signal'
    '03_WP1_21-01-29_Well3_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'h48','prvni dobra nahravka dneska. po vymene vsech hadic'
    '04_WP1_21-01-29_Well3_FOV2_PC-3_untreated_48h_50-100','PC-3',2,'h48',''
    '05_WP1_21-01-29_Well3_FOV3_PC-3_untreated_48h_50-100','PC-3',3,'h48',''
    '06_WP1_21-01-29_Well3_FOV4_PC-3_untreated_48h_50-100','PC-3',4,'h48',''
    '07_WP1_21-01-29_Well3_FOV5_PC-3_untreated_48h_50-100','PC-3',5,'h48',''
%     '08_WP1_21-01-29_Well6_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'h48','well 4 nebyly skoro  zadne, 5 preskakuji'
%     '09_WP1_21-01-29_Well6_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'h48',''
%     '10_WP1_21-01-29_Well6_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'h48',''
%     '11_WP1_21-01-29_Well6_FOV4_PC-3_CytD_3h_10uM_48h_50','PC-3',4,'h48','divne - vubec se nehybou oproti prvniho prutoku.....'
%     '12_WP1_21-01-29_Well5_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'h48',''
%     '13_WP1_21-01-29_Well5_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'h48',''
%     '14_WP1_21-01-29_Well5_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'h48',''
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];

file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];



path = [data_folder '\20-12-18 PC3 vs 22Rv1_4days_post_seeding\'];
file_names_tmp = {...
    '01_WP1_20-12-18_Well1_FOV1_PC-3_untreated_50-100','PC-3',1,'d04','NA celého exp. rovna NA objektivu = 0.30'
    '02_WP1_20-12-18_Well1_FOV2_PC-3_untreated_50-100','PC-3',2,'d04',''
    '03_WP1_20-12-18_Well1_FOV3_PC-3_untreated_50-100','PC-3',3,'d04',''
    '04_WP1_20-12-18_Well2_FOV1_PC-3_untreated_50-100','PC-3',1,'d04','11:15 cvakla pumpa, ale dojelo skoro cele'
    '05_WP1_20-12-18_Well2_FOV2_PC-3_untreated_50-100','PC-3',2,'d04',''
%     '06_WP1_20-12-18_Well4_FOV1_22Rv1_untreated_50-100','22Rv1',1,'d04','blbe jsem pojmenoval, korektura az potom'
%     '07_WP1_20-12-18_Well4_FOV2_22Rv1_untreated_50-100','22Rv1',2,'d04',''
%     '08_WP1_20-12-18_Well4_FOV3_22Rv1_untreated_50-100','22Rv1',3,'d04','urvaly se 14:15'
%     '09_WP1_20-12-18_Well5_FOV1_22Rv1_untreated_50-100','22Rv1',1,'d04',''
%     '10_WP1_20-12-18_Well5_FOV2_22Rv1_untreated_50-100','22Rv1',2,'d04',''
%     '11_WP1_20-12-18_Well5_FOV3_22Rv1_untreated_50-100','22Rv1',3,'d04',''
%     '12_WP1_20-12-18_Well5_FOV3_22Rv1_untreated_100-200','22Rv1',3,'d04','postupne se urvaly vsechny, 200 je moc'
%     '13_WP1_20-12-18_Well6_FOV1_22Rv1_untreated_30to300','22Rv1',1,'d04','15:27 tam neco prolitlo a cast urvalo. neni cely zaznam, jen 7 min - chybí posledni (?) puls - navazuje dalsim souborem - chybi cca 10 s: dalsi soubor 13_WP1_20-12-18_Well6_FOV1_22Rv1_untreated_30to300_pt_2'
%     '14_WP1_20-12-18_Well3_FOV1_PC-3_untreated_30to300','PC-3',1,'d04','cely divny, divny pulzy s bunama nic moc nedela'
%     '15_WP1_20-12-18_Well3_FOV1_PC-3_untreated_30to300','PC-3',1,'d04','stejny zorny pole znova po znovuutazeni strikacky'
    };

file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];

file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];



path = [data_folder '\20-12-10 - Shearstress PC3 calA ruzne dyny\'];
file_names_tmp = {...
%     '01_WP1_20-11-23-full-confl_Well1_PC-3_untreated_100-200','PC3',1,'d17',''
    '02_WP1_20-11-23-full-confl_Well1_PC-3_untreated_50-100','PC3',2,'d17',''
    '03_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions_littlebitcool medium','PC3',1,'d17',''
    '04_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions','PC3',2,'d17',''
    '05_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions','PC3',3,'d17',''
    '06_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50-100_4repetitions','PC3',4,'d17',''
%     '07_WP1_20-11-23-full-confl_Well2_PC-3_untreated_5to50_10steps_signal-to-noise','PC3',5,'d17',''
%     '08_WP1_20-11-23-full-confl_Well2_PC-3_untreated_50to400_step50_test_trhani','PC3',6,'d17',''
    '09_WP2_20-12-08-lo-confl_Well1_PC-3_untreated_50-100_4repetitions','PC3',1,'d17',''
    '10_WP2_20-12-08-lo-confl_Well1_PC-3_untreated_50-100_4repetitions','PC3',2,'d17',''
    '11_WP2_20-12-08-lo-confl_Well1_PC-3_untreated_50-100_4repetitions','PC3',1,'d17',''
    '12_WP3_20-11-23-lo-confl_Well3_PC-3_untreated_50-100_4repetitions','PC3',2,'d17',''
    '13_WP3_20-11-23-lo-confl_Well3_PC-3_untreated_50-100_4repetitions','PC3',3,'d17',''
%     '14_WP3_20-11-23-lo-confl_Well3_PC-3_untreated_50-100_4repetitions_v_predchozim kosstricky_mereni_na_nich','PC3',4,'d17',''
%     '15_WP3_20-11-23-lo-confl_Well4_PC-3_5nMCalA_50-100_napreskacku_4repetitions','PC3',1,'d17','treat'
%     '16_WP3_20-11-23-lo-confl_Well5_PC-3_5nMCalA_50-100_napreskacku_4repetitions','PC3',1,'d17','treat'
%     '17_WP3_20-11-23-lo-confl_Well6_PC-3_5nMCalA_50-100_napreskacku_4repetitions_','PC3',1,'d17','treat'
%     '18_WP3_20-11-23-lo-confl_Well6_PC-3_5nMCalA_50-100_napreskacku_4repetitions_','PC3',2,'d17','treat'
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];


file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];








save_name = 'seed_time';


Gs = [];
etas = [];
slopes = [];
class = {};
signal_for_avg = {};
confluences  = [];

for file_num = 1:size(file_names,1)
    
    
    file_name = file_names{file_num,1};
    file_name_folder = file_name;
    file_name_folder = split(file_name_folder,'/');
    file_name_folder = file_name_folder{end};
    
    file_name_qpi_image = file_names_qpi_image{file_num};
    img = imread(file_name_qpi_image);
    binar = img>threshold;
    confluence = sum(binar(:))/numel(binar);
    

    params = load([file_name '/fit_params.mat']);
    signals = load([file_name '/signals.mat']);
    
    use_table = readtable([file_name '/table_what_use.xlsx']);
    num_cells_in_cluster = use_table{end,2:end};
    use_table = use_table{1:end-1,2:end};
    
    for cell_num = 1:size(use_table,2)
        
        
        use_vector = use_table(:,cell_num);
        use_vector = (use_vector>0)&~isnan(use_vector);
        tmp = params.Gs_all{cell_num};
        use_vector = use_vector(1:length(tmp));
        
        if sum(use_vector) ==0
            continue;
        end
        
    
        taus = abs(params.taus_all{cell_num});
        
        use_vector = use_vector' & (taus-5)<2.5;
        
        G = median(params.Gs_all{cell_num}(use_vector));
        eta = median(params.etas_all{cell_num}(use_vector));
        
        
        gamma_signal = signals.gamma_signals{cell_num};
        time = signals.times{cell_num};
        bg = bg_fit_iterative_polynom(time,gamma_signal);
        use = (time>70) & (time<195);
        
        gamma_signal = gamma_signal(use);
        time = time(use);
        bg = bg(use);
        if (max(time) - min(time))<110
            slope = nan;
        else
            f=fit(time,bg*params.hs_all{cell_num},'poly1');
%             f=fit(time,gamma_signal*params.hs_all{cell_num},'poly1');
            slope = f.p1;
        end
        
        
        Gs = [Gs,G];
        etas = [etas,eta];
        slopes = [slopes,slope];
%         signal_for_avg = [signal_for_avg,gamma_signal-bg];
        signal_for_avg = [signal_for_avg,gamma_signal];
        
        class = [class,file_names{file_num,4}];
%         class = [class,[file_name_folder file_names{file_num,2}]];

        confluences  = [confluences,confluence];
        
    end
end


figure()
boxplot_special(class,Gs)
xtickangle(-45)
ylabel('G (Pa)')
print_png_fig(['results/' save_name '_G'])


figure()
boxplot_special(class,confluences)
xtickangle(-45)
ylabel('confluence')
print_png_fig(['results/' save_name '_confluence'])



figure()
boxplot_special(class,etas)
xtickangle(-45)
ylabel('\eta (Pa s)')
print_png_fig(['results/' save_name '_eta'])


figure()
boxplot_special(class,slopes)
xtickangle(-45)
ylabel('Movement (\mu m / s)')
print_png_fig(['results/' save_name 'slopes'])






max_len = max(cellfun(@length, signal_for_avg));
to_avg = nan(length(signal_for_avg),max_len);
for k = 1:length(signal_for_avg)
    if length(signal_for_avg{k})==max_len
        to_avg(k,:) = signal_for_avg{k};
    end
end

colors  = get(gca,'colororder');

uu = unique(class);
figure()
hold on 
for k = 1:length(uu)

    u = uu{k};
    use = strcmp(u,class);
    to_avg_tmp = to_avg(use,:);
    
%     for kk = 1:size(to_avg_tmp,1)
%         pqq = plot(time,to_avg(kk,:),'Color',colors(k,:),'LineWidth',0.1);
%         alpha(pqq,.3) 
%         set(get(get(pqq,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
%     end
    
    
    med_size =27;
    
    avg_gamma_signal = nanmedian(to_avg_tmp,1);
    avg_gamma_signal = medfilt1(avg_gamma_signal,med_size,'truncate');
    mi = min(avg_gamma_signal);
    avg_gamma_signal = avg_gamma_signal-mi;
   
    pq = plot(time,avg_gamma_signal,'Color',colors(k,:),'LineWidth',2);
    
    
    y_bot = quantile(to_avg_tmp,0.25,1);
    y_bot = medfilt1(y_bot,med_size,'truncate');
    y_bot = y_bot-mi;
    
    y_up = quantile(to_avg_tmp,0.75,1);
    y_up = medfilt1(y_up,med_size,'truncate');
    y_up = y_up-mi;
    
    
    x = time;
    p = fill([x;x(end:-1:1)],[y_bot,y_up(end:-1:1)]',pq.Color,'EdgeColor','none');
    alpha(p,.2) 
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    drawnow;
end

legend(uu)


print_png_fig(['results/' save_name 'avg_signals'])




colors  = get(gca,'colororder');
uu = unique(class);
figure()
hold on 
for k = 1:length(uu)

    u = uu{k};
    use = strcmp(u,class);
    
    
    plot(Gs(use),etas(use),'*','Color',colors(k,:));
    
    
    
end
legend(uu)
ylabel('\eta (Pa s)')
xlabel('G (Pa)')
xlim([0 300])
ylim([0 1000])
print_png_fig(['results/' save_name '_G_vs_eta'])


