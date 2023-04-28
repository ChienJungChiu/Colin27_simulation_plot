%{
Plot the fig 7 of Benjimin Kao's paper (the GM fluence rate of transverse
plane)

Edited by Chien-Jung Chiu
Last Update: 2023/04/25

%}
clc;clear;close all;
%fig=figure('Units','inches','position',[0 0 7.165 4.4]);

%% initialize settings
%load('fig7_initial.mat');
model_dir = 'models_test';
subject_name_arr='KB'; % the name of the subjects
%subject_name_arr='KB';
fluence_dir_1='sim_2E8_literature_sCone1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
fluence_dir_2='sim_2E8_literature_sDisk1';
fluence_subDir = fullfile('litOP_0','litOP_0_EtoF');
output_folder = 'xy_cross_section';
output_subfolder_1 = '810';
output_subfolder_2 = '1064';

mkdir(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1));
mkdir(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2));
mkdir(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1));
mkdir(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2));
data_Cone1_810 = load(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,'fluence_1.mat'));
data_Cone1_810 = data_Cone1_810.fluence;
data_Cone1_1064 = load(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,'fluence_2.mat'));
data_Cone1_1064 = data_Cone1_1064.fluence;
data_Disk1_810 = load(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,'fluence_1.mat'));
data_Disk1_810 = data_Disk1_810.fluence;
data_Disk1_1064 = load(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,'fluence_2.mat'));
data_Disk1_1064 = data_Disk1_1064.fluence;
vol = load(fullfile(model_dir,['headModel' subject_name_arr '_EEG.mat']));
voxel_size = vol.voxel_size;
model_size = size(vol.vol); 
disp('Read data successfully!!!')

%% color tick settings
num_color_scale = 12;
colorTick = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17];
colorTickLabel = [{'sclap','skull','CSF','GM','WM','5.0E-09','1.0E-08','2.0E-08','5.0E-07','1.0E-06','2.0E-06','5.0E-06','1.0E-05','2.0E-05','5.0E-05','1.0E-04','2.0E-04'}];
colormap_arr = [1,1,1;0.166666666666667,0.166666666666667,0.166666666666667;0.333333333333333,0.333333333333333,0.333333333333333;0.500000000000000,0.500000000000000,0.500000000000000;0.666666666666667,0.666666666666667,0.666666666666667;0.833333333333333,0.833333333333333,0.833333333333333;0,0,1;0,0.250000000000000,1;0,0.500000000000000,1;0,0.750000000000000,1;0,1,1;0.250000000000000,1,0.750000000000000;0.500000000000000,1,0.500000000000000;0.750000000000000,1,0.250000000000000;1,1,0;1,0.750000000000000,0;1,0.500000000000000,0;1,0.250000000000000,0];


%% turn the data into different level of colormap label
plot_Cone1_810 = [];
plot_Cone1_1064 = [];
plot_Disk1_810 = [];
plot_Disk1_1064 = [];
[plot_Cone1_810] = fun_transfer_flux_to_fig7input(data_Cone1_810,model_size,colorTickLabel,vol);
[plot_Cone1_1064] = fun_transfer_flux_to_fig7input(data_Cone1_1064,model_size,colorTickLabel,vol);
[plot_Disk1_810] = fun_transfer_flux_to_fig7input(data_Disk1_810,model_size,colorTickLabel,vol);
[plot_Disk1_1064] = fun_transfer_flux_to_fig7input(data_Disk1_1064,model_size,colorTickLabel,vol);


%% start plotting
for k = 1:model_size(3)
    plot_Cone1_810_cs = reshape(plot_Cone1_810(:,:,k),model_size(1),model_size(2));
    imagesc(plot_Cone1_810_cs);
    
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'810 Cone1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
    axis square;
    %xticks = [0:10:model_size(2)];
    %xticklabels(xticks*voxel_size);
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');%,'xticklabels', xticklabels(xticks*voxel_size));
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_1,subject_name_arr,fluence_subDir,output_folder,output_subfolder_1,[ 'z' num2str(k) '_Cone1_810_cross section']),'jpeg');
end

for b = 1:model_size(3)
    plot_Cone1_1064_cs = reshape(plot_Cone1_1064(:,:,b),model_size(1),model_size(2));
    imagesc(plot_Cone1_1064_cs);
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'1064 Cone1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
    axis square;
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_1,subject_name_arr,fluence_subDir,output_folder,output_subfolder_2,[ 'z' num2str(b) '_Cone1_1064_cross section']),'jpeg');
end

for a = 1:model_size(3)
    plot_Disk1_810_cs = reshape(plot_Disk1_810(:,:,a),model_size(1),model_size(2));
    imagesc(plot_Disk1_810_cs);
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'810 Disk1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
    axis square;
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_2,subject_name_arr,fluence_subDir,output_folder,output_subfolder_1,[ 'z' num2str(a) '_Disk1_810_cross section']),'jpeg');
end

for c = 1:model_size(3)
    plot_Disk1_1064_cs = reshape(plot_Disk1_1064(:,:,c),model_size(1),model_size(2));
    imagesc(plot_Disk1_1064_cs);
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'1064 Disk1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
    axis square;
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_2,subject_name_arr,fluence_subDir,output_folder,output_subfolder_2,[ 'z' num2str(c) '_Disk1_1064_cross section']),'jpeg');
end


