%{
Chien-Jung Chiu
Last Update: 2023/3/9
%}

clc;clear;close all;

%% param
subject_name_arr={'KB'}; % the name of the subjects
model_dir='models_test'; % the folder containing the voxel model of the subjects
fluence_dir='2023_sim_2E8_literature_energy_sDisk1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
%fluence_subDir={'litOP_1_energy','litOP_2_energy','litOP_3_energy','litOP_4_energy','litOP_5_energy','litOP_6_energy','litOP_7_energy','litOP_8_energy','litOP_9_energy','litOP_10_energy','litOP_11_energy','litOP_12_energy','litOP_13_energy','litOP_14_energy','litOP_15_energy','litOP_16_energy','litOP_17_energy','litOP_18_energy','litOP_19_energy','litOP_20_energy','litOP_21_energy','litOP_22_energy','litOP_23_energy','litOP_24_energy','litOP_25_energy','litOP_26_energy','litOP_27_energy','litOP_28_energy','litOP_29_energy','litOP_30_energy','litOP_31_energy','litOP_32_energy','litOP_33_energy','litOP_34_energy','litOP_35_energy','litOP_36_energy','litOP_37_energy','litOP_38_energy','litOP_39_energy','litOP_40_energy','litOP_41_energy','litOP_42_energy','litOP_43_energy','litOP_44_energy','litOP_45_energy','litOP_46_energy','litOP_47_energy','litOP_48_energy','litOP_49_energy','litOP_50_energy','litOP_51_energy','litOP_52_energy','litOP_53_energy','litOP_54_energy','litOP_55_energy','litOP_56_energy','litOP_57_energy','litOP_58_energy','litOP_59_energy','litOP_60_energy','litOP_61_energy','litOP_62_energy','litOP_63_energy','litOP_64_energy'};
fluence_subDir={'litOP_100'};
fluence_subsubDir = 'litOP_100_EtoF';
num_OP = 1; % equal to the number of fluence_subDir
num_wl=42; % the number of wavelength in a folder
num_layers=5; % the number of layer, not include type 0


%% main
data = zeros(num_OP,num_wl);
%% load the voxel model
model=load(fullfile(model_dir,['headModel' subject_name_arr{1} '_EEG.mat']));
orig_vol_size=size(model.vol); % the size of the original voxel model
layer_datas = [];
for OP = 1 : num_OP
    fprintf('\tlitOP_ %d\n',OP);
    for wl=1:num_wl
        fprintf('\tWavelength %d\n',wl);
        %% load the fluence rate simulation result
        %sim_flu=load(fullfile(fluence_dir,subject_name_arr{1},fluence_subDir{OP},['average_fluence_' num2str(wl) '.mat']));
        sim_flu=load(fullfile(fluence_dir,subject_name_arr{1},fluence_subDir{OP},fluence_subsubDir,['fluence_' num2str(wl) '.mat']));
        %assert(sum(size(model.vol)~=size(sim_flu.average_fluence_rate))==0,'Error! The size of the model and the fluence rate are different!');
        assert(sum(size(model.vol)~=size(sim_flu.fluence))==0,'Error! The size of the model and the fluence rate are different!');

        %% calculate all energy in these layers
        layer_total_flu=zeros(1,num_layers);
        for L=1:num_layers
            %layer_total_flu(L)=sum(sim_flu.average_fluence_rate(model.vol==L));
            layer_total_flu(L)=sum(sim_flu.fluence(model.vol==L));
        end
        data(OP,wl) = layer_total_flu(4);
        layer_datas = [layer_datas;layer_total_flu];
    end
end
%% save
%     save(fullfile(fluence_dir,subject_name_arr{1},fluence_subDir{OP},'data.mat'),'data');
%     save(fullfile(fluence_dir,subject_name_arr{1},fluence_subDir{OP},'layer_datas.mat'),'layer_datas');
    save(fullfile(fluence_dir,subject_name_arr{1},fluence_subDir{OP},fluence_subsubDir,'data.mat'),'data');
    save(fullfile(fluence_dir,subject_name_arr{1},fluence_subDir{OP},fluence_subsubDir,'layer_datas.mat'),'layer_datas');

disp('Done!');