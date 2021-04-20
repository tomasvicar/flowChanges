clear all;close all;clc;
addpath('utils');addpath('utils/plotSpread')

threshold = 0.2;

% data_folder = 'Z:\999992-nanobiomed\Holograf\data_shear_stress_2021';
data_folder = 'E:\Sdílené disky\Quantitative GAČR\data\21-03-12 - Shearstress\cell_types';

file_names_qpi_image ={};

file_names = {};

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
%     '12_WP1_21-02-04_Well6_FOV1_PC-3-50_Zn_48h_50-100_glass+bubble','PC-3-50',1,'48h','schvalne pridana cca 0.5 ml bublina/9ml medium - test dekonvoluce'
%     '13_WP1_21-02-04_Well6_FOV2_PC-3-50_Zn_48h_50-100_glass+bubble','PC-3-50',2,'48h',''
%     '14_WP1_21-02-04_Well6_FOV3_PC-3-50_Zn_48h_50-100_glass+bubble','PC-3-50',3,'48h','13:08 bublina, urvala 2 bunky a pozdeji vsechny ostatni'
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];
file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];




path = [data_folder '\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\'];
file_names_tmp = {...
%     '01_WP1_21-01-29_Well2_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'48h','po druhem odpojeni odtrzeny vsechny bunky, prvni jamka testovaci proto; hnusny pomaly nastup signalu'
%     '02_WP1_21-01-29_Well2_FOV2_PC-3_untreated_48h_50-100','PC-3',1,'48h','hnusny signal'
    '03_WP1_21-01-29_Well3_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'48h','prvni dobra nahravka dneska. po vymene vsech hadic'
    '04_WP1_21-01-29_Well3_FOV2_PC-3_untreated_48h_50-100','PC-3',2,'48h',''
    '05_WP1_21-01-29_Well3_FOV3_PC-3_untreated_48h_50-100','PC-3',3,'48h',''
    '06_WP1_21-01-29_Well3_FOV4_PC-3_untreated_48h_50-100','PC-3',4,'48h',''
    '07_WP1_21-01-29_Well3_FOV5_PC-3_untreated_48h_50-100','PC-3',5,'48h',''
%     '08_WP1_21-01-29_Well6_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'48h','well 4 nebyly skoro  zadne, 5 preskakuji'
%     '09_WP1_21-01-29_Well6_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'48h',''
%     '10_WP1_21-01-29_Well6_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'48h',''
%     '11_WP1_21-01-29_Well6_FOV4_PC-3_CytD_3h_10uM_48h_50','PC-3',4,'48h','divne - vubec se nehybou oproti prvniho prutoku.....'
%     '12_WP1_21-01-29_Well5_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'48h',''
%     '13_WP1_21-01-29_Well5_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'48h',''
%     '14_WP1_21-01-29_Well5_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'48h',''
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];
file_names_tmp(:,1) = cellfun(@(x) [path 'results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];



save_name = 'pc3_pc350_22rv1';


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
    
%     file_name_qpi_image = file_names_qpi_image{file_num};
%     img = imread(file_name_qpi_image);
%     binar = img>threshold;
%     confluence = sum(binar(:))/numel(binar);
    

    params = load([file_name '/fit_params.mat']);
    signals = load([file_name '/signals.mat']);
    
    use_table = readtable([file_name '/table_what_use.xlsx']);
    num_cells_in_cluster = use_table{end,2:end};
    use_table = use_table{1:end-1,2:end};
    
    for cell_num = 1:size(use_table,2)
        
        
        use_vector = use_table(:,cell_num);
        
        if sum(use_vector) ==0
            continue;
        end
        
        
        G = params.Gs(cell_num);
        eta =  params.etas(cell_num);
        
        
        gamma_signal = signals.gamma_signals{cell_num};
        time = signals.times{cell_num};
%         bg = bg_fit_iterative_polynom(time,gamma_signal);

        bg_signal = signals.polynoms{cell_num};
        
        
        tt_h = 0:params.optShear.T_period :50;
        tt_h = tt_h(:);

        ttt = time(floor(length(tt_h)/2)+1:end-floor(length(tt_h)/2));


        if (max(time) - min(time))<110
            slope = nan;
        else
%             f=fit(time,bg*params.hs_all{cell_num},'poly1');
            f=fit(ttt,bg_signal*params.hs(cell_num),'poly1');
            slope = f.p1;
        end
        
        
        Gs = [Gs,G];
        etas = [etas,eta];
        slopes = [slopes,slope];
        
%         signal_for_avg = [signal_for_avg,gamma_signal-bg];

        signal_for_avg = [signal_for_avg,gamma_signal];
        
        class = [class,file_names{file_num,2}];
%         class = [class,[file_name_folder file_names{file_num,2}]];
        
%         confluences  = [confluences,confluence];
    end
end

mkdir('results')

figure()
boxplot_special(class,Gs)
xtickangle(-45)
ylabel('G (Pa)')
print_png_fig(['results/' save_name '_G'])

% 
% figure()
% boxplot_special(class,confluences)
% xtickangle(-45)
% ylabel('confluence')
% print_png_fig(['results/' save_name '_confluence'])



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


