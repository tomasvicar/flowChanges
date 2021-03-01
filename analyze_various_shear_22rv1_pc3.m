clear all;close all;clc;
addpath('utils');addpath('utils/plotSpread')



% data_folder = 'Z:\999992-nanobiomed\Holograf\data_shear_stress_2021';
data_folder = 'G:\Sdílené disky\Quantitative GAČR\data\data_shear_stress_2021';



file_names = {};
path = [data_folder '\21-01-27 - Shear stress vzestupny 22Rv1 PC3\'];
file_names_tmp = {...
%     '01_WP1_21-01-27_Well1_FOV1_PC-3_untreated_48h_seq30-to-150','PC-3',1,'48h','velka bublina co nejde odplachnout ani 40 dyny, presto zkusime merit. 11:32 cvaknuti'
%     '02_WP1_21-01-27_Well1_FOV1_PC-3_untreated_48h_seq30-to-150','PC-3',1,'48h','stejne zp znova - cvaknuti pumpy v predeslem runu. 11:46 utrzeni pri zmizeni bubliny - abort'
%     '03_WP1_21-01-27_Well1_FOV2_PC-3_untreated_48h_seq30-to-150','PC-3',2,'48h','11:55 klapnuti - netece pri posl pulzu'
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
file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];

file_names_qpi_image_tmp(:,1) = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image;file_names_qpi_image_tmp];


save_name = 'various_shear_22rv1_pc3';


Gs = [];
etas = [];
slopes = [];
class = {};
signal_for_avg = {};
taus = [];
class_all = {};
times = {};
gammas = [];


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
    params2 = load([file_name '/fit_params2.mat']);
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
        
    
        taus_tmp = abs(params.taus_all{cell_num});
        
%         use_vector = use_vector' & (taus_tmp>3.5) & (taus_tmp<11.5);
        use_vector = use_vector' &  (taus_tmp<12);
        
        
        G_minmax = params2.Gs_minmax_all{cell_num}(use_vector);
        G = params.Gs_all{cell_num}(use_vector);
        eta = params.etas_all{cell_num}(use_vector);
        tau = abs(params.taus_all{cell_num}(use_vector));
        
        gamma_signal = signals.gamma_signals{cell_num};
        time = signals.times{cell_num};
        bg = bg_fit_iterative_polynom(time,gamma_signal);
        use = (time>70) & (time<370);
%         use = (time>115) & (time<320);
        
        gamma_signal = gamma_signal(use);
        time = time(use);
        bg = bg(use);
%         if (max(time) - min(time))<110
%             slope = nan;
%         else
%             f=fit(time,bg*params.hs_all{cell_num},'poly1');
% %             f=fit(time,gamma_signal*params.hs_all{cell_num},'poly1');
%             slope = f.p1;
%         end
        
        
        Gs = [Gs,G];
        etas = [etas,eta];
%         slopes = [slopes,slope];
%         signal_for_avg = [signal_for_avg,gamma_signal-bg];
        signal_for_avg = [signal_for_avg,gamma_signal];
        times = [times,time];
       
        tmp = file_names{file_num,2};
        class = [class,tmp];
        tmp = repmat({tmp},[1,length(G)]);
        class_all = [class_all,tmp];

        taus = [taus,tau];
        gammas = [gammas,tau./G_minmax];
    end
end

colors  = get(gca,'colororder');

uu = unique(class_all);
figure()
hold on 
for k = 1:length(uu)

    u = uu{k};
    use = strcmp(u,class_all);
    taus_tmp = taus(use);
    gammas_tmp = gammas(use);
%     gammas_tmp = Gs(use);
    
    p = plot(taus_tmp,gammas_tmp,'*','Color',colors(k,:));
    set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
    f=fit(taus_tmp',gammas_tmp','poly3','Robust','LAR');
%     f=fit(taus_tmp',gammas_tmp','poly3');
    taus_est = min(taus):0.01:max(taus);
    p = [f.p1,f.p2,f.p3,f.p4];
    gammas_est = polyval(p,taus_est);
    
    plot(taus_est,gammas_est,'Color',colors(k,:))
    
%     [p,S] = polyfit(taus_tmp,gammas_tmp,1);
%     taus_est = min(taus):0.01:max(taus);
%     gammas_est = polyval(p,taus_est);
    

%     [gammas_est,delta] = polyconf(p,taus_est,S,'alpha',0.05);
%     gammas_est_bot = gammas_est - delta;
%     gammas_est_up = gammas_est + delta;
%     
%     plot(taus_est,gammas_est,'Color',colors(k,:))
    
%     p = fill([taus_est';taus_est(end:-1:1)'],[gammas_est_bot,gammas_est_up(end:-1:1)]',colors(k,:),'EdgeColor','none');
%     alpha(p,0.2);
%     set(get(get(p,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
end

legend(uu)
xlabel('shear stress')
ylabel('shear strain')
print_png_fig(['results/' save_name 'stress_strain'])




max_len = max(cellfun(@length, signal_for_avg));
to_avg = nan(length(signal_for_avg),max_len);
for k = 1:length(signal_for_avg)
    if length(signal_for_avg{k})==max_len
        to_avg(k,:) = signal_for_avg{k};
        time = times{k};
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






