%{
find mean OP

Amanda Chiu
Last update: 2022/11/27
%}

%clc; clear all; close all;

literature_OP_arr='OPs_to_sim_12';
OP_arr_810 = zeros(64,10);
OP_arr_1064 = zeros(64,10);

for sim_index=1:64
    tissue_param=load(fullfile(literature_OP_arr,['toSim_OP_' num2str(sim_index) '.txt']));
    for t = 1:10
        OP_arr_810(sim_index,t) = tissue_param(1,t);
        OP_arr_1064(sim_index,t) = tissue_param(1,t);
    end
end

mean_OP_arr_810 = (max(OP_arr_810) + min(OP_arr_810))./2;
mean_OP_arr_1064 = (max(OP_arr_1064) + min(OP_arr_1064))./2;
toSim_OP_0 = [mean_OP_arr_810; mean_OP_arr_1064];

save(fullfile(literature_OP_arr,'toSim_OP_0.txt'),'toSim_OP_0','-ascii','-tabs');

disp('DONE!');