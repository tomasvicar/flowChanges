clc;clear all;close all;
addpath('utils');addpath('utils/plotSpread')

file_names = {};


file_names_tmp = {...
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/1','PC3','exp1','fov1','e1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/2','PC3','exp1','fov2','e1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/3','PC3','exp1','fov3','e1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/4','PC3','exp1','fov1','e2'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/5','PC3','exp1','fov2','e2'
%     'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/6','22Rv1','exp1','fov1'
%     'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/7','22Rv1','exp1','fov2'
%     'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/8','22Rv1','exp1','fov3'
%     'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/9','22Rv1','exp1','fov1'
%     'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/10','22Rv1','exp1','fov2'
%     'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/11','22Rv1','exp1','fov3'
};
file_names = [file_names;file_names_tmp];




%%%caliculin 16 17 18
file_names_tmp = {...
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\1','PC3','exp2','fov1','e3'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\2','PC3','exp2','fov2','e3'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\3','PC3','exp2','fov1','e4'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\4','PC3','exp2','fov2','e4'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\5','PC3','exp2','fov3','e4'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\6','PC3','exp2','fov4','e4'
%     'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\9','PC3','exp2','fov2','e1'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\11','PC3','exp2','fov1','e5'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\12','PC3','exp2','fov2','e5'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\13','PC3','exp2','fov3','e5'
%     'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\16','PC3','exp2','fov1'
%     'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\17','PC3','exp2','fov1'
%     'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\18','PC3','exp2','fov2'
};
file_names = [file_names;file_names_tmp];




file_names_tmp = {...
%     'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\3','PC3','exp3','fov1'
%     'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\4','PC3','exp3','fov2'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\5','PC3','exp3','fov3','e6'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\6','PC3','exp3','fov4','e6'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\7','PC3','exp3','fov1','e7'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\8','PC3','exp3','fov2','e7'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\9','PC3','exp3','fov1','e8'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\10','PC3','exp3','fov2','e8'
%     'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\11','PC3','exp3','fov1','e5'
};
file_names = [file_names;file_names_tmp];


file_names = cellfun(@(x) replace(x,'qq','G:\Sdílené disky\Quantitative GAČR\data'),file_names,'UniformOutput',false ) ;


resutls = struct([]);
ind = 0;
for file_num = 1:size(file_names,1)
    
    file_name = file_names{file_num,1};
    cell_type = file_names{file_num,2};
    experiment= file_names{file_num,3};
    fov= file_names{file_num,4};
    ex= file_names{file_num,5};
    
    tmp = subdir([file_name '/*results.mat']);
    data1 = load(tmp(1).name);
    
    data2 = load([file_name '/results_G.mat']);
    
   
    use_table = readtable([file_name '/table_what_use.xlsx']);
    num_cells_in_cluster = use_table{end,2:end};
    use_table = use_table{1:end-1,2:end};
    
    for cell_num = 1:size(use_table,2)
        
        use_vector = use_table(:,cell_num);
        use_vector = (use_vector>0)&~isnan(use_vector);
        
        if sum(use_vector) ==0
            continue;
        end
        
        ind = ind + 1;
        
        
        pulse_ind  = 1:length(use_vector);
        
        resutls(ind).Gs = data2.G_all{cell_num}(use_vector);
        
        resutls(ind).nis = data2.ni_all{cell_num}(use_vector);
        resutls(ind).hs = data2.heights_all{cell_num}(use_vector);
        
        tmp=diff(data2.shears_all{cell_num});
        resutls(ind).shears = abs(tmp(use_vector));
        resutls(ind).Es = data2.E_all{cell_num}(use_vector);
        resutls(ind).up_or_down = sign(tmp(use_vector))+0.1*randn(1,length(tmp(use_vector)));
        resutls(ind).pulse_ind = pulse_ind(use_vector)+0.1*randn(1,length(tmp(use_vector)));
        
        
        
%         resutls(ind).Es = resutls(ind).shears ./ data2.E_all{cell_num}(use_vector) .* resutls(ind).hs;
        
        
        resutls(ind).file_num = num2str(file_num);
        resutls(ind).cell_num = num2str(cell_num);
        resutls(ind).num_cells_in_cluster = num2str(num_cells_in_cluster(cell_num));
        
        resutls(ind).cell_type = cell_type;
        resutls(ind).experiment = experiment;
        resutls(ind).fov = fov;
        resutls(ind).ex = ex;
        
    end
    
    
end

between_peaks =[];
for ind = 1:length(resutls)
    between_peaks =[between_peaks,std(resutls(ind).Gs)];
end
between_peaks = mean(between_peaks);
between_peaks


% 
% between_cells1 = [];
% values = [];
% file_nums = {};
% for ind = 1:length(resutls)
%     tmp =resutls(ind).Gs;
%     values = [values,tmp];
%     file_nums = [file_nums,repmat({resutls(ind).file_num},[1,length(tmp)])];
% end
% u = unique(file_nums);
% 
% for k = 1:length(u)
%    use = strcmp(u{k},file_nums);
%    between_cells1 = [between_cells1,std(values(use))];
% end
% between_cells1 = mean(between_cells1);
% between_cells1


between_cells = [];
values = [];
file_nums = {};
w = [];
for ind = 1:length(resutls)
    tmp =resutls(ind).Gs;
    values = [values,mean(tmp)];
    w = [w,numel(tmp)];
    file_nums = [file_nums,resutls(ind).file_num];
end
u = unique(file_nums);

for k = 1:length(u)
   use = strcmp(u{k},file_nums);
   between_cells = [between_cells,sqrt(var(values(use),w(use)))];
end
between_cells = mean(between_cells);
between_cells



between_fovs = [];
values = [];
exs = {};
fovs = {};
w = [];
for ind = 1:length(resutls)
    tmp =resutls(ind).Gs;
    values = [values,mean(tmp)];
    fovs = [fovs,resutls(ind).fov];
    exs = [exs,resutls(ind).ex];
    w = [w,numel(tmp)];
end

u = unique(exs);
for k = 1:length(u)
   use = strcmp(u{k},exs);
   tmp_values = values(use);
   tmp_fovs = fovs(use);
   tmp_w = w(use);
   
   uu = unique(tmp_fovs);
   if length(uu)==1
       continue
   end
   tmp3 = [];
   ww = [];
   for kk = 1:length(uu)
       use = strcmp(uu{kk},tmp_fovs);
       tmp3 = [tmp3,mean(tmp_values(use))];
       ww = [ww,sum(tmp_w(use))];
   end
   between_fovs = [between_fovs,sqrt(var(tmp3,ww))];
end
between_fovs = mean(between_fovs);
between_fovs 




between_wells = [];
values = [];
exs = {};
experiments = {};
w = [];
for ind = 1:length(resutls)
    tmp =resutls(ind).Gs;
    values = [values,mean(tmp)];
    experiments = [experiments,resutls(ind).experiment];
    exs = [exs,resutls(ind).ex];
    w = [w,numel(tmp)];
end


u = unique(experiments);
for k = 1:length(u)
   use = strcmp(u{k},experiments);
   tmp_values = values(use);
   tmp_exs = exs(use);
   tmp_w = w(use);
   
   uu = unique(tmp_exs);
   tmp3 = [];
   ww= [];
   for kk = 1:length(uu)
       use = strcmp(uu{kk},tmp_exs);
       tmp3 = [tmp3,mean(tmp_values(use))];
       ww = [ww,sum(tmp_w(use))];
   end
   between_wells = [between_wells,sqrt(var(tmp3,ww))];
end
between_wells = mean(between_wells);
between_wells 


moc = 2;
% std([resutls(:).Gs])
y = [between_peaks,between_cells,between_fovs,between_wells;0,0,0,0];
% sum(y(:))

bar(y.^moc,'stacked')

legend({['between peaks' num2str(between_peaks.^moc)],['between cells' num2str(between_cells.^moc)],['between fovs' num2str(between_fovs.^moc)],['between wells' num2str(between_wells.^moc)]})
ylabel('Proportion of variability')
print_png_eps_svg_fig(['../variability'])



figure;
moc = 1;
% std([resutls(:).Gs])
y = [between_peaks,between_cells,between_fovs,between_wells;0,0,0,0];
% sum(y(:))

bar(y.^moc,'stacked')

legend({['between peaks' num2str(between_peaks.^moc)],['between cells' num2str(between_cells.^moc)],['between fovs' num2str(between_fovs.^moc)],['between wells' num2str(between_wells.^moc)]})
ylabel('Proportion of std')
print_png_eps_svg_fig(['../stanadrdeviation'])





moc = 2;
% std([resutls(:).Gs])
y = [between_peaks,between_cells,between_fovs,between_wells;0,0,0,0];
% sum(y(:))


tmp = y.^moc;
xxx=sum(tmp(:));
bar(tmp/xxx,'stacked')

legend({['between peaks' num2str(between_peaks.^moc/xxx)],['between cells' num2str(between_cells.^moc/xxx)],['between fovs' num2str(between_fovs.^moc/xxx)],['between wells' num2str(between_wells.^moc/xxx)]})
ylabel('Proportion of variability')
print_png_eps_svg_fig(['../variability_norm'])





moc = 1;
% std([resutls(:).Gs])
y = [between_peaks,between_cells,between_fovs,between_wells;0,0,0,0];
% sum(y(:))


tmp = y.^moc;
xxx=sum(tmp(:));
bar(tmp/xxx,'stacked')

legend({['between peaks' num2str(between_peaks.^moc/xxx)],['between cells' num2str(between_cells.^moc/xxx)],['between fovs' num2str(between_fovs.^moc/xxx)],['between wells' num2str(between_wells.^moc/xxx)]})
ylabel('Proportion of std')
print_png_eps_svg_fig(['../stanadrdeviation_norm'])

