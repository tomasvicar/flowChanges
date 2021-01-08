clc;clear all;close all;
addpath('utils');addpath('utils/plotSpread')

file_names = {};


file_names_tmp = {...
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/1','PC3','exp1','fov1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/2','PC3','exp1','fov2'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/3','PC3','exp1','fov3'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/4','PC3','exp1','fov1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/5','PC3','exp1','fov2'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/6','22Rv1','exp1','fov1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/7','22Rv1','exp1','fov2'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/8','22Rv1','exp1','fov3'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/9','22Rv1','exp1','fov1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/10','22Rv1','exp1','fov2'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/11','22Rv1','exp1','fov3'
};
file_names = [file_names;file_names_tmp];




%%%caliculin 16 17 18
file_names_tmp = {...
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\1','PC3','exp2','fov1'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\2','PC3','exp2','fov2'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\3','PC3','exp2','fov1'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\4','PC3','exp2','fov2'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\5','PC3','exp2','fov3'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\6','PC3','exp2','fov4'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\9','PC3','exp2','fov2'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\11','PC3','exp2','fov1'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\12','PC3','exp2','fov2'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\13','PC3','exp2','fov3'
%     'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\16','PC3','exp2','fov1'
%     'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\17','PC3','exp2','fov1'
%     'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\18','PC3','exp2','fov2'
};
file_names = [file_names;file_names_tmp];




file_names_tmp = {...
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\3','PC3','exp3','fov1'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\4','PC3','exp3','fov2'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\5','PC3','exp3','fov3'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\6','PC3','exp3','fov4'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\7','PC3','exp3','fov1'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\8','PC3','exp3','fov2'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\9','PC3','exp3','fov1'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\10','PC3','exp3','fov2'
    'qq\nova_krabice_pc3_beztreatmentu_hezka_data19_11_2020\results_01_06_21__18_21\11','PC3','exp3','fov1'
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
        resutls(ind).Es = data2.E_all{cell_num}(use_vector);
        resutls(ind).nis = data2.ni_all{cell_num}(use_vector);
        resutls(ind).hs = data2.heights_all{cell_num}(use_vector);
        
        tmp=diff(data2.shears_all{cell_num});
        resutls(ind).shears = abs(tmp(use_vector));
        resutls(ind).up_or_down = sign(tmp(use_vector))+0.1*randn(1,length(tmp(use_vector)));
        resutls(ind).pulse_ind = pulse_ind(use_vector)+0.1*randn(1,length(tmp(use_vector)));
        
        
        
        resutls(ind).file_num = num2str(file_num);
        resutls(ind).cell_num = num2str(cell_num);
        resutls(ind).num_cells_in_cluster = num2str(num_cells_in_cluster(cell_num));
        
        resutls(ind).cell_type = cell_type;
        resutls(ind).experiment = experiment;
        resutls(ind).fov = fov;
        
    end
    
    
end

 
cluster_var = 'file_num';
value_var = '';
dep = 'Gs';




y_label = dep;
save_name = 'tmp';
ylims = '';
xlims = '';
x_label = '';

% 
% save_name = '22Rv1_vs_PC3_G';
% y_label = 'Shear modulus (Pa)';
% ylims = [0,250];
% xlims = [0 3000];


% save_name = '22Rv1_vs_PC3_ni';
% y_label = 'Viscosity (Pa s)';
% xlims = [0.6 2.4];


cluster_vals = {};
value_vals = [];
dep_vals = [];
for ind = 1:length(resutls)
    
    use = ones(size(resutls(ind).shears))>0;
    
    
    use = abs(resutls(ind).shears-10)<5;
    
    if ~strcmp(resutls(ind).fov,'fov1')
        continue
    end
    if ~strcmp(resutls(ind).cell_type,'PC3')
        continue
    end
%     if ~strcmp(resutls(ind).experiment,'exp1')
%         continue
%     end
    
    
    tmp1 = resutls(ind).(dep);
    tmp1 = tmp1(use);
    if value_var
        tmp2 = resutls(ind).(value_var);
        tmp2 = tmp2(use);
    end
    
     
    if value_var
        dep_vals = [dep_vals,tmp1];
        value_vals = [value_vals,tmp2];
        
    else
        dep_vals = [dep_vals,median(tmp1)];
        
    end
    
    if cluster_var
        tmp= resutls(ind).(cluster_var);
    else
        tmp = 'xxx';
          
    end
    if value_var
        tmp = repmat({tmp},[1,length(resutls(ind).(dep))]);
        
    end
    
    
    cluster_vals = [cluster_vals,tmp];
    

end

figureSize = [50,100,1700,800];
figure('Position',figureSize);
hold on;

if value_var
    uu = unique(cluster_vals);
    
    for u = uu
        if iscell(u)
            u = u{1};
        end
        if isstring(u)||ischar(u)
            cluster_bin = cellfun(@(x) strcmp(x,u),cluster_vals);
        else
            cluster_bin = cellfun(@(x) x==u,cluster_vals);
        end
        plot(value_vals(cluster_bin),dep_vals(cluster_bin),'.')
%         boxplot_special(value_vals(cluster_bin),dep_vals(cluster_bin))
    end
    legend(uu,'Location','best')
    xlabel(value_var)
    ylabel(y_label)
else

    
    boxplot_special(cluster_vals,dep_vals)
    ylabel(y_label)
    

end


if x_label
    xlabel(x_label)
end

set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'linewidth',2)

    
if xlims
    xlim(xlims)
end
if ylims
    ylim(ylims)
end

drawnow;

if save_name
    print_png_eps_svg(['../' save_name])
end






