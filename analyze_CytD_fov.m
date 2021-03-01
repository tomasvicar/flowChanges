clear all;close all;clc;
addpath('utils');addpath('utils/plotSpread')

threshold = 0.2;

% data_folder = 'Z:\999992-nanobiomed\Holograf\data_shear_stress_2021';
data_folder = 'G:\Sdílené disky\Quantitative GAČR\data\data_shear_stress_2021';


file_names_qpi_image ={};


file_names = {};


path = [data_folder '\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed\'];
file_names_tmp = {...
%     '01_WP1_21-01-29_Well2_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'48h','unt','po druhem odpojeni odtrzeny vsechny bunky, prvni jamka testovaci proto; hnusny pomaly nastup signalu'
%     '02_WP1_21-01-29_Well2_FOV2_PC-3_untreated_48h_50-100','PC-3',1,'48h','unt','hnusny signal'
%     '03_WP1_21-01-29_Well3_FOV1_PC-3_untreated_48h_50-100','PC-3',1,'48h','unt','prvni dobra nahravka dneska. po vymene vsech hadic'
%     '04_WP1_21-01-29_Well3_FOV2_PC-3_untreated_48h_50-100','PC-3',2,'48h','unt',''
%     '05_WP1_21-01-29_Well3_FOV3_PC-3_untreated_48h_50-100','PC-3',3,'48h','unt',''
%     '06_WP1_21-01-29_Well3_FOV4_PC-3_untreated_48h_50-100','PC-3',4,'48h','unt',''
%     '07_WP1_21-01-29_Well3_FOV5_PC-3_untreated_48h_50-100','PC-3',5,'48h','unt',''
    '08_WP1_21-01-29_Well6_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'48h','CytD','well 4 nebyly skoro  zadne, 5 preskakuji'
    '09_WP1_21-01-29_Well6_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'48h','CytD',''
    '10_WP1_21-01-29_Well6_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'48h','CytD',''
    '11_WP1_21-01-29_Well6_FOV4_PC-3_CytD_3h_10uM_48h_50','PC-3',4,'48h','CytD','divne - vubec se nehybou oproti prvniho prutoku.....'
    '12_WP1_21-01-29_Well5_FOV1_PC-3_CytD_3h_10uM_48h_50','PC-3',1,'48h','CytD',''
    '13_WP1_21-01-29_Well5_FOV2_PC-3_CytD_3h_10uM_48h_50','PC-3',2,'48h','CytD',''
    '14_WP1_21-01-29_Well5_FOV3_PC-3_CytD_3h_10uM_48h_50','PC-3',3,'48h','CytD',''
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];
file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];



path = [data_folder '\21-02-05 - Shearstress PC3 docetax 200nM 24h cytD 1uM\'];
file_names_tmp = {...
    '10_WP1_21-02-05_Well6_FOV1_PC-3_ CytD_1uM_845_added_48h_50-100','PC-3',1,'48h','CytD','prvnich10s docetaxelem se neuložilo;rozdrbalo se nastaveni restaqrt a ztracime cas;neuložilo se'
    '11_WP1_21-02-05_Well6_FOV2_PC-3_ CytD_1uM_845_added_48h_50-100','PC-3',2,'48h','CytD',''
    '12_WP1_21-02-05_Well1_FOV1_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',1,'48h','doc',''
    '13_WP1_21-02-05_Well1_FOV2_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',2,'48h','doc',''
    '14_WP1_21-02-05_Well1_FOV3_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',3,'48h','doc',''
    '15_WP1_21-02-05_Well1_FOV4_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',4,'48h','doc',''
    '16_WP1_21-02-05_Well2_FOV1_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',1,'48h','doc',''
    '17_WP1_21-02-05_Well2_FOV2_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',2,'48h','doc',''
    '18_WP1_21-02-05_Well2_FOV3_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',3,'48h','doc',''
    '19_WP1_21-02-05_Well2_FOV4_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',4,'48h','doc',''
    '20_WP1_21-02-05_Well3_FOV1_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',1,'48h','doc',''
    '21_WP1_21-02-05_Well3_FOV2_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',2,'48h','doc',''
    '22_WP1_21-02-05_Well3_FOV3_PC-3_Docetax_200nM_24h_48h_50-100','PC-3',3,'48h','doc',''
    };
file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];
file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];


save_name = 'CytD_FOV';


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
        
        class = [class,num2str(file_names{file_num,3})];
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



