%{
turn energy into fluence rate
Chien-Jung Chiu
Last update: 2023/4/25
%}
clc; clear all; close all;

%% initial settings
subject_name_arr='KB'; % the name of the subjects
model_dir = 'models_test';
label_model = load(fullfile(model_dir,['headModel' subject_name_arr '_EEG.mat']));
label_model = label_model.vol;
model_size = size(label_model); 
energy_dir='sim_2E8_literature_sDisk1'; % the simulation result should be in fluence_dir / subject_name / fluence_subDir
subEnergy_dir = 'litOP_0';
sim_wl = load(fullfile(energy_dir,'sim_wl.txt'));
OP = load(fullfile('OPs_to_sim_12','toSim_OP_0.txt'));  %toSim_OP_100.txt is the average OP in 650 ~ 1064 nm from paper, unit: 1/cm
output_folder = 'litOP_0_EtoF';
mkdir(fullfile(energy_dir,subject_name_arr, subEnergy_dir,output_folder));

%% transfer energy into fluence
for i = 1 : length(sim_wl)
    energy = load(fullfile(energy_dir,subject_name_arr,subEnergy_dir,['average_fluence_' num2str(i) '.mat']));
    energy = energy.average_fluence_rate;
    for x = 1:model_size(1)
        for y = 1:model_size(2)
            for z = 1:model_size(3)
                if label_model(x,y,z) == 1
                    fluence(x,y,z) = energy(x,y,z)./OP(i,1);
                elseif label_model(x,y,z) == 2
                    fluence(x,y,z) = energy(x,y,z)./OP(i,3);
                elseif label_model(x,y,z) == 3
                    fluence(x,y,z) = energy(x,y,z)./OP(i,5);
                elseif label_model(x,y,z) == 4
                    fluence(x,y,z) = energy(x,y,z)./OP(i,7);
                elseif label_model(x,y,z) == 5
                    fluence(x,y,z) = energy(x,y,z)./OP(i,9);
                else
                    fluence(x,y,z) = energy(x,y,z);
                end
            end
        end
    end
    save(fullfile(energy_dir,subject_name_arr,subEnergy_dir,output_folder,['fluence_' num2str(i) '.mat']),'fluence');
end
disp('DONE!');