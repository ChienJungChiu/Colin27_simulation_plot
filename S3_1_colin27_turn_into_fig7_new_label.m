%{
Step1 for plotting the fig 7 of Benjimin Kao's paper (the GM fluence rate of transverse
plane)
input:fluence rate(W/cm)
output:the .mat file that turn into the new label which depends on fluence rate

Edited by Chien-Jung Chiu
Last Update: 2023/06/05
%}

clc;clear;close all;
%fig=figure('Units','inches','position',[0 0 7.165 4.4]);

%% initialize settings
%load('fig7_initial.mat');
model_dir = 'models_test';
%subject_name_arr='colin27'; % the name of the subjects
subject_name_arr='colin27';
fluence_dir_1='sim_2E8_literature_sCone1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
fluence_dir_2='sim_2E8_literature_sDisk1';
%fluence_subDir = fullfile('litOP_0','litOP_0_EtoF');
fluence_subDir = fullfile('litOP_0','EtoF');
%fluence_subDir = fullfile('litOP_0');
output_folder = 'xy_cross_section';
output_subfolder_1 = '810';
output_subfolder_2 = '1064';

mkdir(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1));
mkdir(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2));
mkdir(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1));
mkdir(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2));
data_Cone1_810 = load(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,'fluence_1.mat'));
data_Cone1_810 = 1000*data_Cone1_810.fluence;   %turn W into mW
data_Cone1_1064 = load(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,'fluence_2.mat'));
data_Cone1_1064 = 1000*data_Cone1_1064.fluence;    %turn W into mW
data_Disk1_810 = load(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,'fluence_1.mat'));
data_Disk1_810 = 1000*data_Disk1_810.fluence;      %turn W into mW
data_Disk1_1064 = load(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,'fluence_2.mat'));
data_Disk1_1064 = 1000*data_Disk1_1064.fluence;     %turn W into mW
vol = load(fullfile(model_dir,['headModel' subject_name_arr '_EEG.mat']));
voxel_size = vol.voxel_size;
model_size = size(vol.vol); 
disp('Read data successfully!!!')

%% color tick settings
num_color_scale = 12;
colorTick = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17];
%colorTickLabel = [{'sclap','skull','CSF','GM','WM','5.0E-09','1.0E-08','2.0E-08','5.0E-07','1.0E-06','2.0E-06','5.0E-06','1.0E-05','2.0E-05','5.0E-05','1.0E-04','2.0E-04'}];
colorTickLabel = [{'sclap','skull','CSF','GM','WM','1.0E-5','2.0E-5','5.0E-5','1.0E-4','2.0E-4','5.0E-4','1.0E-3','2.0E-3','5.0E-3','1.0E-2','2.0E-2','5.0E-2'}];
%colorTickLabel = [{'sclap','skull','CSF','GM','WM','1.0E-4','2.0E-4','5.0E-4','1.0E-3','2.0E-3','5.0E-3','1.0E-2','2.0E-2','5.0E-2','1.0E-1','2.0E-1','5.0E-1'}];
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

%% save the label .mat file for fig.7 to plot, in case we needs to modified the plot again and again
save 'colorTickLabel.mat' colorTickLabel
save 'colorTick.mat' colorTick
save 'colormap_arr.mat' colormap_arr
save(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1,'plot_Cone1_810.mat'),'plot_Cone1_810');
save(fullfile(fluence_dir_1,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2,'plot_Cone1_1064.mat'),'plot_Cone1_1064');
save(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_1,'plot_Disk1_810.mat'),'plot_Disk1_810');
save(fullfile(fluence_dir_2,subject_name_arr, fluence_subDir,output_folder,output_subfolder_2,'plot_Disk1_1064.mat'),'plot_Disk1_1064');

