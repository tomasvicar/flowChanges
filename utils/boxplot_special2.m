function boxplot_special2(g,y)

u=unique(g);

% [g,tmp]=sort(g);
% y = y(tmp);

colors=repmat({	[0.8500, 0.3250, 0.0980]},[1,length(u)]);
colors_dot=repmat({[0,0,0]},[1,length(u)]);
pos=1:length(unique(g));


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


plotSpread(y,'distributionIdx',g,'distributionColors',colors_dot);
c = get(gca, 'Children');
for i=1:length(c)
    try
        set(c(i), 'MarkerSize',13,'MarkerEdgeColor',[0 0.4470 0.7410],'Marker','.');
    end
end


% plotSpread(y,'distributionIdx',g,'distributionColors',colors_dot);



end

