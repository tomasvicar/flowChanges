clc;clear all;close all;
addpath('utils');addpath('utils/plotSpread')

file_names = {};


file_names_tmp = {...
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/1','PC3','exp1','fov1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/2','PC3','exp1','fov2'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/3','PC3','exp1','fov3'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/4','PC3','exp1','fov1'
    'qq\20-12-18 PC3 vs 22Rv1_4days_post_seeding/results_01_05_21__18_34/5','PC3','exp1','fov2'
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
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\16','PC3','exp2','fov1'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\17','PC3','exp2','fov1'
    'qq\20-12-10 - Shearstress PC3 calA ruzne dyny\results_01_06_21__18_40\18','PC3','exp2','fov2'
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
        
        resutls(ind).nis = data2.ni_all{cell_num}(use_vector);
        resutls(ind).hs = data2.heights_all{cell_num}(use_vector);
        
        tmp=diff(data2.shears_all{cell_num});
        resutls(ind).shears = abs(tmp(use_vector));
        resutls(ind).Es = data2.E_all{cell_num}(use_vector);
        resutls(ind).up_or_down = sign(tmp(use_vector))+0.1*randn(1,length(tmp(use_vector)));
        resutls(ind).pulse_ind = pulse_ind(use_vector)+0.1*randn(1,length(tmp(use_vector)));
        
        
        
        resutls(ind).dx = resutls(ind).shears ./ resutls(ind).Es .* resutls(ind).hs;
        
        
        resutls(ind).file_num = num2str(file_num);
        resutls(ind).cell_num = num2str(cell_num);
        resutls(ind).num_cells_in_cluster = num2str(num_cells_in_cluster(cell_num));
        
        resutls(ind).cell_type = cell_type;
        resutls(ind).experiment = experiment;
        resutls(ind).fov = fov;
        
    end
    
    
end

 
cluster_var = 'cell_type';
value_var = 'shears';
dep = 'Gs';




y_label = dep;
save_name = 'tmp';
ylims = '';
xlims = '';
x_label = '';

% 
% save_name = 'PC3_ni_pro_ruzne_dyny';
% y_label = 'Shear modulus (Pa)';
% x_label = 'Shear stress (Pa)';
% ylims = [0,500];
% xlims = [0 3000];


% save_name = '22Rv1_vs_PC3_ni';
% y_label = 'Viscosity (Pa s)';
% ylims = [0,3000];
% xlims = [0.6 2.4];


pas = [];
Gss = [];
dxs = [];
for ind = 1:length(resutls)
    
    
    Gs = resutls(ind).Gs;
    shears = resutls(ind).shears;
    dx = resutls(ind).dx;
    
    for pa = [5 10 20]
        
        use = abs(shears-pa)<2;
        if any(use)
            pas = [pas,pa];
            Gss = [Gss,median(Gs(use))];
            dxs = [dxs,median(dx(use))];
        end
    
    end

end




figureSize = [50,100,1700,800];
figure('Position',figureSize);
hold on;


factor = 170;
y = [];
g = {};
for k = [5 10 20]
    use = pas==k;
    y = [y,Gss(use),dxs(use)*factor];
    g = [g,repmat({['G' num2str(k)]},[1,sum(use)]),repmat({['dx' num2str(k)]},[1,sum(use)])];
    
end


u=unique(g);

colors=repmat({	[0.8500, 0.3250, 0.0980],[0, 0.4470, 0.7410]},[1,3]);
colors = colors(end:-1:1);

pos=[0.85,1.15,1.85,2.15,2.85,3.15];


colors_dot = repmat({[0,0,0]},[1,length(u)]);;

colorss=colors(end:-1:1);
h=boxplot(y,g,'positions', pos,'colors','k','symbol',''); 
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   patch(get(h(j),'XData'),get(h(j),'YData'),colorss{j});
end 
c = get(gca, 'Children');
for i=1:length(c)
    try
        set(c(i), 'FaceAlpha', 0.4);
    end
end
h=boxplot(y,g,'positions', pos,'colors','k','symbol',''); 
set(h,'LineWidth',2)
% xtickangle(-30)
% ylabel(y_lab)
mkdir('res')


plotSpread(y,'distributionIdx',g,'distributionColors',colors_dot,'xValues',pos);
c = get(gca, 'Children');
for i=1:length(c)
    try
        set(c(i), 'MarkerSize',8,'MarkerEdgeColor',colors_dot,'Marker','.');
    end
end








ylabel('Shear modulus (Pa)')
xlabel('Shear stress (Pa)')

ylim([0,500])
a = gca;
ys = a.YLim;
yyaxis right

ylim(ys/factor)

ylabel('Center of mass shift (\mu m)')



set(gca,'FontSize',12)
set(gca,'FontWeight','bold')
set(gca,'linewidth',2)

xticks([1,2,3])
xticklabels({'5','10','20'})


ax = gca;
ax.YAxis(1).Color = [0, 0.4470, 0.7410];
ax.YAxis(2).Color = [0.8500, 0.3250, 0.0980];

    
if ~isempty(xlims)
    xlim(xlims)
end
if ~isempty(ylims)
    ylim(ylims)
end

drawnow;

save_name = 'PC3_Gs_dxs_pro_ruzne_dyny';

if save_name
    print_png_eps_svg_fig(['../' save_name])
end






