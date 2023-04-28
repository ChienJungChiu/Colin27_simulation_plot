%{
colin27 plot figure 3 in Li-da Huang's paper
Disk1 source type & GM absorption energy fraction
input: total fluence rate in layers 

Chien-Jung Chiu
Last update: 2022/12/8
%}

clear;clc;close all;

subject_name_arr='colin27'; % the name of the subjects
fluence_dir='2023_sim_2E8_literature_energy_sDisk1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
data = load(fullfile(fluence_dir,subject_name_arr,'data.mat'));
wl_subject_flux = data.data;

fig=figure('Units','inches','position',[0 0 7.165 4.47]);

% arrange the data
to_plot_cell={};
for j=1:2
    to_plot_cell{j}=wl_subject_flux(:,j);
end

legend_arr={};
for i=1:1
    legend_arr{i}=num2str(i);
end


ylim([0 0.05])
ylabel('GM absorption energy fraction');

grid on;
set(gca,'fontsize',12, 'FontName', 'Times New Roman');

for i=1:1
    text(3*i-2,-0.0015,'810','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',8, 'FontName', 'Times New Roman');
    text(3*i-1,-0.0015,'1064','HorizontalAlignment','center','VerticalAlignment','middle','fontsize',8, 'FontName', 'Times New Roman');
end

set(gca,'Unit','normalized','Position',[0.15 0.15 0.8 0.81]);
boxplotGroup(to_plot_cell,'PrimaryLabels',{'', ''});
hold on;

saveas(gcf,fullfile(fluence_dir,subject_name_arr,['fig3']),'jpeg');
disp('Done!');