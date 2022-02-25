clear all;close all;clc;
addpath('utils');addpath('utils/plotSpread')

threshold = 0.2;

data_folder = 'Z:\999992-nanobiomed\Holograf\21-03-12 - Shearstress\';

file_names_qpi_image ={};

file_names = {};


path = [data_folder '\pozice\'];
file_names_tmp ={...
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
    };

frame_poss = [415.6, 367.12,446.7,245.2,360.4,313.4,433,467.1,399.7,...
    123.9,88.2,305.1,410.4];

file_names_qpi_image_tmp = cellfun(@(x) [path  x '/Compensated phase - [0000, 0000].tiff'], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names_qpi_image = [file_names_qpi_image,file_names_qpi_image_tmp];
file_names_tmp(:,1) = cellfun(@(x) [path '/results_222/' x], {file_names_tmp{:,1}}, 'UniformOutput', false);
file_names = [file_names;file_names_tmp];

delta_n_old = 0.0200;
delta_n_pc3 = 0.0239;
delta_n_22rv1 = 0.0239;

q_pc3 = delta_n_pc3/delta_n_old;
q_22rv1 = delta_n_22rv1/delta_n_old;

save_name = 'params';


Gs = [];
etas = [];
slopes = [];
class = {};
signal_for_avg = {};
confluences  = [];
paramss = [];


for file_num = 1:size(file_names,1)
    
    
    file_name = file_names{file_num,1};
    file_name_folder = file_name;
    file_name_folder = split(file_name_folder,'/');
    file_name_folder = file_name_folder{end};
    
    frame_pos = frame_poss(file_num);
    
    file_name_qpi_image = file_names_qpi_image{file_num};
%     img = imread(file_name_qpi_image);
%     binar = img>threshold;
%     confluence = sum(binar(:))/numel(binar);
    confluence = 0;

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
%         if num_cells_in_cluster(cell_num)~=1
%             continue;
%         end
            
            
        stats = signals.stats_frame1_all{cell_num};
%         param = stats.Eccentricity;
%         param_type = 'Eccentricity';
        
%         param = stats.Solidity;
%         param_type = 'Solidity';

%         param =  (4*pi*stats.Area)./(stats.Perimeter.^2 );
%         param(param>1) = 1-0.02*rand();
%         param_type = 'Circularity';
        
%         param = ( stats.Area .* stats.MeanIntensity ) ./ (600/376)^2;
%         param_type = 'Mass';



        dist_from_left = stats.global_BB_colums + frame_pos + 10;
        dist_from_right = 1000-dist_from_left;

        param = min([dist_from_left,dist_from_right]);
        param_type = 'border_dist';

%         param =  stats.MeanIntensity / (600/376)^2;
%         param_type = 'Density';

%         param =  stats.Area;% / (600/376)^2;
%         param_type = 'Area';
        
        
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
        paramss = [paramss,param];
        
%         signal_for_avg = [signal_for_avg,gamma_signal-bg];

        signal_for_avg = [signal_for_avg,gamma_signal];
        
        class = [class,file_names{file_num,2}];
%         class = [class,[file_name_folder file_names{file_num,2}]];
        
        confluences  = [confluences,confluence];
    end
end

mkdir('results_positions')

% save_name = param_type;

paramss2 = paramss;

remove = Gs > 250;

paramss = paramss(~remove);
Gs = Gs(~remove);

[R,P] = corrcoef(Gs,paramss );

figure()
plot(paramss,Gs,'.');
hold on 
lsline
ylabel('G (Pa)')
xlabel('Distance from channel border (\mum)');
title(['korelace ' num2str(R(1,2)) ' s p hodnotou' num2str(P(1,2))])
print_png_fig(['results_positions/corelation_plot_G']);


[R,P] = corrcoef(etas,paramss2 );


figure()
plot(paramss2,etas,'.');
hold on 
lsline
ylabel('\eta (Pa s)')
xlabel('Distance from channel border (\mum)');
title(['korelace ' num2str(R(1,2)) ' s p hodnotou' num2str(P(1,2))])
print_png_fig(['results_positions/corelation_plot_eta']);


% figure()
% boxplot_special(class,Gs)
% xtickangle(-45)
% ylabel('G (Pa)')
% print_png_fig(['results_params_treat/' save_name '_G'])
