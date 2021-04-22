clear all;close all;clc;
addpath('utils');addpath('utils/plotSpread')

threshold = 0.2;

data_folder = 'G:\Sdílené disky\Quantitative GAČR\data\21-03-12 - Shearstress';

file_names_qpi_image ={};

file_names = {};


path = [data_folder '\21-03-12 - Shearstress PC3 PC3doc PC3CytD\'];
file_names_tmp ={...
%     '01_WP1_21-03-12_Well1_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.409722222222222,0.418750000000000,'PC3 cislo pasaze 23 (vsechny bunky dneska)'
%     '02_WP1_21-03-12_Well1_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.409722222222222,0.429166666666667,''
%     '03_WP1_21-03-12_Well1_FOV3_PC-3_ unt_48h_50only_30s','PC-3',3,0.409722222222222,0.434027777777778,''
%     '04_WP1_21-03-12_Well1_FOV4_PC-3_ unt_48h_50only_30s','PC-3',4,0.409722222222222,0.438888888888889,''
%     '05_WP1_21-03-12_Well2_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.443750000000000,0.447222222222222,''
%     '06_WP1_21-03-12_Well2_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.443750000000000,0.450694444444444,'10:51 urvaly se bunky'
%     '07_WP1_21-03-12_Well3_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.454861111111111,0.459027777777778,'11:02 urvalo se hodne bunek'
%     '08_WP1_21-03-12_Well4_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.464583333333333,0.470138888888889,''
%     '09_WP1_21-03-12_Well4_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.464583333333333,0.474305555555556,'buňky trošku hnusný oproti předch zp'
%     '10_WP1_21-03-12_Well4_FOV3_PC-3_ unt_48h_50only_30s','PC-3',3,0.464583333333333,0.477777777777778,''
%     '11_WP1_21-03-12_Well4_FOV4_PC-3_ unt_48h_50only_30s','PC-3',4,0.464583333333333,0.482638888888889,''
%     '12_WP1_21-03-12_Well5_FOV1_PC-3_ unt_48h_50only_30s','PC-3',1,0.489583333333333,0.492361111111111,''
%     '13_WP1_21-03-12_Well5_FOV2_PC-3_ unt_48h_50only_30s','PC-3',2,0.489583333333333,0.497916666666667,'praskyly nebrat'
%     '14_WP2_21-03-12_Well1_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,0.550694444444445,0.555555555555556,''
%     '15_WP2_21-03-12_Well1_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,0.550694444444445,0.559722222222222,''
%     '16_WP2_21-03-12_Well1_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,0.550694444444445,0.568055555555556,'podivně strmé pulsy (jakože hezké)'
%     '17_WP2_21-03-12_Well1_FOV4_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',4,0.550694444444445,0.572222222222222,''
%     '18_WP2_21-03-12_Well2_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,0.578472222222222,0.581944444444445,''
%     '19_WP2_21-03-12_Well2_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,0.578472222222222,0.586111111111111,''
%     '20_WP2_21-03-12_Well2_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,0.578472222222222,0.589583333333333,''
%     '21_WP2_21-03-12_Well2_FOV4_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',4,0.578472222222222,0.593750000000000,''
%     '22_WP2_21-03-12_Well3_FOV1_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',1,0.601388888888889,0.605555555555556,''
%     '23_WP2_21-03-12_Well3_FOV2_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',2,0.601388888888889,0.611111111111111,''
%     '24_WP2_21-03-12_Well3_FOV3_PC-3_ 200nM_docet_24h_48h_50only_30s','PC-3+200nMdocetax_24h',3,0.601388888888889,0.615277777777778,''
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

file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];
file_names_tmp(:,1) = cellfun(@(x) [path '/results_2/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];

delta_n_old = 0.0200;
delta_n_pc3 = 0.0239;
delta_n_22rv1 = 0.0251;

q_pc3 = delta_n_pc3/delta_n_old;
q_22rv1 = delta_n_22rv1/delta_n_old;

save_name = 'cytochalasin_time_in_experiment';


Gs = [];
etas = [];
slopes = [];
class = [];
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
    
    cell_type = file_names{file_num,2};

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
        
        
        if contains(cell_type,'PC-3')
            q = q_pc3;
            
        elseif contains(cell_type,'22Rv1')
            q = q_22rv1;
            
        else
            error('incorect cell type')
        end
        
        G = G/q;
        eta = eta/q;
        gamma_signal = gamma_signal*q;
        bg_signal = bg_signal*q;
        
        
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
        
        class = [class,(file_names{file_num,5}-file_names{file_num,4})*24*60];
%         class = [class,[file_name_folder file_names{file_num,2}]];
        
        confluences  = [confluences,confluence];
    end
end

mkdir('results')






q = 4:6:22;
% q = 4:4:24;
% q = 4:5:24;
class_cell = {};
class_num = [];
for k = 1:length(class)
    
    
   tmp = class(k); 
    
    [~,tmp2] = min(abs(q-tmp));
    
    tmp = q(tmp2);

    class_cell{k} = num2str(tmp,'%02.f');
    class_num(k) = tmp;
end  





class = class_cell;




figure()
boxplot_special(class,Gs)
xtickangle(-45)
ylabel('G (Pa)')
xlabel('recovery time (min)')
print_png_fig(['results/' save_name '_G'])


figure()
boxplot_special(class,confluences)
xtickangle(-45)
ylabel('confluence')
xlabel('recovery time (min)')
print_png_fig(['results/' save_name '_confluence'])



figure()
boxplot_special(class,etas)
xtickangle(-45)
ylabel('\eta (Pa s)')
xlabel('recovery time (min)')
print_png_fig(['results/' save_name '_eta'])


figure()
boxplot_special(class,slopes)
xtickangle(-45)
ylabel('Movement (\mu m / s)')
xlabel('recovery time (min)')
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










% figure()
% plot(class,Gs,'*')
% xtickangle(-45)
% ylabel('G (Pa)')
% 
% hold on
% % f=fit(class',Gs','poly1','Robust','LAR');
% f=fit(class',Gs','poly1');
% class_est = min(class):0.01:max(class);
% % p = [f.p1,f.p2,f.p3,f.p4];
% p = [f.p1,f.p2];
% gammas_est = polyval(p,class_est);
% plot(class_est,gammas_est)
% 
% print_png_fig(['results/' save_name '_G'])
% 
% 
% 
% figure()
% plot(class,confluences,'*')
% xtickangle(-45)
% ylabel('confluence')
% 
% hold on
% % f=fit(class',confluences','poly1','Robust','LAR');
% f=fit(class',confluences','poly1');
% class_est = min(class):0.01:max(class);
% % p = [f.p1,f.p2,f.p3,f.p4];
% p = [f.p1,f.p2];
% gammas_est = polyval(p,class_est);
% plot(class_est,gammas_est)
% 
% print_png_fig(['results/' save_name '_confluence'])
% 
% 
% 
% figure()
% plot(class,etas,'*')
% xtickangle(-45)
% ylabel('\eta (Pa s)')
% 
% hold on
% % f=fit(class',etas','poly1','Robust','LAR');
% f=fit(class',etas','poly1');
% class_est = min(class):0.01:max(class);
% % p = [f.p1,f.p2,f.p3,f.p4];
% p = [f.p1,f.p2];
% gammas_est = polyval(p,class_est);
% plot(class_est,gammas_est)
% 
% print_png_fig(['results/' save_name '_eta'])
% 
% 
% figure()
% plot(class,slopes,'*')
% xtickangle(-45)
% ylabel('Movement (\mu m / s)')
% 
% hold on
% % f=fit(class',slopes','poly1','Robust','LAR');
% f=fit(class',slopes','poly1');
% class_est = min(class):0.01:max(class);
% % p = [f.p1,f.p2,f.p3,f.p4];
% p = [f.p1,f.p2];
% gammas_est = polyval(p,class_est);
% plot(class_est,gammas_est)
% 
% print_png_fig(['results/' save_name 'slopes'])




