%{
Step2 for plotting the fig 7 of Benjimin Kao's paper (the GM fluence rate of transverse
plane)
input:.mat file that turn into the new label which depends on fluence rate
output:save 4 different sources cross section picture

Edited by Chien-Jung Chiu
Last Update: 2023/05/30
%}

%%
clc;clear;close all;

%% settings

subject_name_arr='colin27'; % the name of the subjects
fluence_dir_1='sim_2E8_literature_sCone1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
fluence_dir_2='sim_2E8_literature_sDisk1';
%fluence_subDir = fullfile('litOP_0','litOP_0_EtoF');
fluence_subDir = fullfile('litOP_0','EtoF');
%fluence_subDir = fullfile('litOP_0');
output_folder = 'xy_cross_section';
output_subfolder_1 = '810';
output_subfolder_2 = '1064';
model_dir = 'models_test';

%% Load file
vol = load(fullfile(model_dir,['headModel' subject_name_arr '_EEG.mat']));
voxel_size = vol.voxel_size;
model_size = size(vol.vol); 

plot_Cone1_810 = load(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1,'plot_Cone1_810.mat')).plot_Cone1_810 ;
plot_Cone1_1064 = load(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2,'plot_Cone1_1064.mat')).plot_Cone1_1064 ;
plot_Disk1_810 = load(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1,'plot_Disk1_810.mat')).plot_Disk1_810 ;
plot_Disk1_1064 = load(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2,'plot_Disk1_1064.mat')).plot_Disk1_1064 ;

num_color_scale = 12;
colormap_arr = load('colormap_arr.mat').colormap_arr;
colorTick = load('colorTick.mat').colorTick;
colorTickLabel = load('colorTickLabel.mat').colorTickLabel;
%% Cone1 810
for k = 1:model_size(3)
    plot_Cone1_810_cs = reshape(plot_Cone1_810(:,:,k),model_size(1),model_size(2));
    imagesc(plot_Cone1_810_cs);
    
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'810 Cone1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
%     axis square;
    axis image;
    xticks([0 20 40 60 80 100 120 140 160 180]);
    %xticklabels(xticks*voxel_size);
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');%,'xticklabels', xticklabels(xticks*voxel_size));
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_1,subject_name_arr,fluence_subDir,output_folder,output_subfolder_1,[ 'z' num2str(k) '_Cone1_810_cross section']),'jpeg');
end

%% Cone1 1064
for b = 1:model_size(3)
    plot_Cone1_1064_cs = reshape(plot_Cone1_1064(:,:,b),model_size(1),model_size(2));
    imagesc(plot_Cone1_1064_cs);
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'1064 Cone1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
    %axis square;
    axis image;
    xticks([0 20 40 60 80 100 120 140 160 180]);
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_1,subject_name_arr,fluence_subDir,output_folder,output_subfolder_2,[ 'z' num2str(b) '_Cone1_1064_cross section']),'jpeg');
end


%% Disk1 810
for a = 1:model_size(3)
    plot_Disk1_810_cs = reshape(plot_Disk1_810(:,:,a),model_size(1),model_size(2));
    imagesc(plot_Disk1_810_cs);
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'810 Disk1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
    %axis square;
    axis image;
    xticks([0 20 40 60 80 100 120 140 160 180]);
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_2,subject_name_arr,fluence_subDir,output_folder,output_subfolder_1,[ 'z' num2str(a) '_Disk1_810_cross section']),'jpeg');
end


%% Disk1 1064
for c = 1:model_size(3)
    plot_Disk1_1064_cs = reshape(plot_Disk1_1064(:,:,c),model_size(1),model_size(2));
    imagesc(plot_Disk1_1064_cs);
    colormap(colormap_arr);
    caxis([0 num_color_scale+6]);
    hcb=colorbar('Ticks',colorTick,'TickLabels',colorTickLabel);
    text(model_size(2)/2,model_size(1)-10,'1064 Disk1 fluence rate','HorizontalAlignment','center','VerticalAlignment','middle', 'FontName', 'Times New Roman')
    %axis off;
    %axis square;
    axis image;
    xticks([0 20 40 60 80 100 120 140 160 180]);
    set(gca,'fontsize',8, 'FontName', 'Times New Roman');
    set(gca,'YDir','normal')
    saveas(gcf,fullfile(fluence_dir_2,subject_name_arr,fluence_subDir,output_folder,output_subfolder_2,[ 'z' num2str(c) '_Disk1_1064_cross section']),'jpeg');
end


