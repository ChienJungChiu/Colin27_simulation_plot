%{
colin27 plot figure 6 in Li-da Huang's paper
Disk1 source type
input: total energy in layers (Do S1_1_colin27_layer_energy first)
6(a):Volume-integrated fluence rate of GM - 650 ~ 1064 nm
6(b):Volume-integrated fluence rate in GM - 1064-nm/810-nm

Chien-Jung Chiu
Last update: 2022/12/8
%}

clear;clc;close all;
%%
subject_name_arr='colin27'; % the name of the subjects
fluence_dir='2023_sim_2E8_literature_energy_sDisk1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
subEnergy_dir = fullfile('litOP_100','litOP_100_EtoF');
data_6a = load(fullfile(fluence_dir,subject_name_arr,subEnergy_dir,'data.mat'));
sbj_layer_flu_arr = data_6a.data;  %unit: W/cm^2, if you want to show Volume-integrated, please remember to multiply voxel size
%sbj_layer_flu_arr = sbj_layer_flu_arr*0.93*0.93*0.93;
sim_wl = load(fullfile(fluence_dir,'sim_wl_mean.txt'));
OP = load(fullfile('OPs_to_sim_12','toSim_OP_100.txt'));  %toSim_OP_100.txt is the average OP in 650 ~ 1064 nm from paper
GM_mean_mua = OP(:,7)';
colormap_arr=jet(9);

fig=figure('Units','inches','position',[0 0 7.165 4]);
subplot(1,2,1);
hold on;

plot(sim_wl,sbj_layer_flu_arr,'LineWidth',1,'Color',colormap_arr(1,:));
xlabel('wavelength (nm)');
ylabel('Volume-integrated fluence rate of GM (cm)');
xlim([650 1070])
title('(a)', 'Units', 'normalized', 'Position', [0.5, -0.15, 0], 'FontName', 'Times New Roman', 'FontSize', 8);
grid on;
set(gca,'fontsize',8, 'FontName', 'Times New Roman');
set(gca,'Position',[0.1 0.15 0.4 0.8])


%%
subject_name_arr='colin27'; % the name of the subjects
fluence_dir='2023_sim_2E8_literature_energy_sDisk1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
OP_dir = 'OPs_to_sim_12';
data_6b = load(fullfile(fluence_dir,subject_name_arr,'data.mat'));
wl_subject_eng = data_6b.data;

for OP_set = 1:64
    for wl = 1:2
        OP = load(fullfile(OP_dir,['toSim_OP_' num2str(OP_set) '.txt']));
        GM_mua(OP_set,wl) = OP(wl,7);
    end
end
wl_subject_eng = reshape(wl_subject_eng,64,2);

wl_subject_fluence = wl_subject_eng./GM_mua;
do_turn_into_flu = 1;
subject_fluence_ratio = wl_subject_fluence(:,2)./wl_subject_fluence(:,1); 


subplot(1,2,2);
boxplot(subject_fluence_ratio(:,:));
if do_turn_into_flu
    ylabel('Volume-integrated fluence rate in GM - 1064-nm/810-nm');
else
    ylabel('absorbed energy ratio');
end
title('(b)', 'Units', 'normalized', 'Position', [0.5, -0.15, 0], 'FontName', 'Times New Roman', 'FontSize', 8);
xlabel('Colin27');
set(gca,'fontsize',8, 'FontName', 'Times New Roman');
set(gca,'Position',[0.5625 0.15 0.40 0.8])

saveas(gcf,fullfile(fluence_dir,subject_name_arr,subEnergy_dir,['fig6']),'jpeg');
%print('fig6.png','-dpng','-r600');
close all;