%{
Colin27 mcx silulation

Chien-Jung Chiu
Last Update: 2023/04/25
%}

clear all; close all; clc;

%% clear the stop flag
to_save=0;
save('stop_flag.txt','to_save','-ascii','-tabs');

%%
global lambda;
sbj_index_arr = [1];
voxel_size = 1;  %for colin27, if there is no default in EEG.mat, set the voxel size as 0.5

%% param
model_folder='models_test'; % the folder containing the model
subject_name_arr={'colin27'}; % the name of the subjects

src_index = 13; %%set which type of source do you want

if src_index==1
    source_type='cone1';
    output_folder='sim_2E8_literature_sCone1'; % output folder name
elseif src_index==2
    source_type='cone2';
    output_folder='sim_2E8_literature_sCone2'; % output folder name
elseif src_index==3
    source_type='cone3';
    output_folder='sim_2E8_literature_sCone3'; % output folder name
elseif src_index==4
    source_type='cone4';
    output_folder='sim_2E8_literature_sCone4'; % output folder name
elseif src_index==5
    source_type='cone5';
    output_folder='sim_2E8_literature_sCone5'; % output folder name
elseif src_index==6
    source_type='cone6';
    output_folder='sim_2E8_literature_sCone6'; % output folder name
elseif src_index==7
    source_type='cone7';
    output_folder='sim_2E8_literature_sCone7'; % output folder name
elseif src_index==8
    source_type='cone8';
    output_folder='sim_2E8_literature_sCone8'; % output folder name
elseif src_index==9
    source_type='cone9';
    output_folder='sim_2E8_literature_sCone9'; % output folder name
elseif src_index==10
    source_type='cone10';
    output_folder='sim_2E8_literature_sCone10'; % output folder name
elseif src_index==11
    source_type='cone11';
    output_folder='sim_2E8_literature_sCone11'; % output folder name
elseif src_index==12
    source_type='cone12';
    output_folder='sim_2E8_literature_sCone12'; % output folder name
elseif src_index==13
    source_type='disk1';
    output_folder='sim_2E8_literature_sDisk1'; % output folder name
elseif src_index==14
    source_type='disk2';
    output_folder='sim_2E8_literature_sDisk2'; % output folder name
elseif src_index==15
    source_type='disk3';
    output_folder='sim_2E8_literature_sDisk3'; % output folder name
elseif src_index==16
    source_type='disk4';
    output_folder='sim_2E8_literature_sDisk4'; % output folder name
end

%% about the instrument
n=1.4; % the refractive index of tissue
g=0.9; % the anisotropic factor of the tissue
outer_n=1; % the refractive index of out the head

%% about simulation
output_fluence_rate=1; % output the total fluence rate
output_pathlength=0; % output the pathlength of detected photons, also the reflectance
output_jacobian=0;

num_photon=2E8;

literature_OP_arr='OPs_to_sim_12';

test_photon_path=0; % add mua to air and test the photon path in the air

%% init
mkdir(output_folder);
global sim_version;
sim_version=4.51;
fid=fopen(fullfile(output_folder,'sim_version.txt'),'w');
fprintf(fid,'%.2f',sim_version);
fclose(fid);

num_SDS=0; % number of detectors
detector_r=2; %mm
detector_larger_r=4; %mm, use the larger detector to find the detected photon, and calculate the distance of photon to the center of detector
detector_NA=0.12; % the numerical aperture of the fibers
source_NA=0.37; % the numerical aperture of the source

%% main

for sbj=sbj_index_arr
    %% about subject
    subject_name=subject_name_arr{sbj};
    
    %MRI_voxel_file=fullfile(model_folder,['headModel' subject_name '_EEG.mat']); % containing the MRI voxel model, also the EEG point and head surface mesh
    MRI_voxel_file=fullfile(model_folder,['headModel' subject_name '_EEG.mat']); % containing the MRI voxel model, also the EEG point and head surface mesh
    %% initialize
    load(MRI_voxel_file);
    
    if exist('model_version','var')==0
        model_version=1;
        do_sinus=0;
    end
    
    if test_photon_path
        vol(vol==0)=max(vol(:))+1;
    end
    
    %% find the position and direction of probes
 
    p_pos=load(fullfile(model_folder,[subject_name '_cone1_probe_pos.txt']));
    p_dir=load(fullfile(model_folder,[subject_name '_cone1_probe_dir.txt']));
    p_pos(:,[1 2])=p_pos(:,[2 1]); % exchange the x, y pos
    p_dir(:,[1 2])=p_dir(:,[2 1]); % exchange the x, y pos
    SDS_normal_vector=p_dir(2:end,:); % the normal vector of the detectors

    %% set the simulation
%     lambda=load(fullfile(literature_OP_arr,'sim_wl.txt'));
%     save(fullfile(output_folder,'sim_wl.txt'),'lambda','-ascii','-tabs');
     lambda=load(fullfile(literature_OP_arr,'sim_wl_mean.txt'));   %sim_wl_mean.txt from 650 ~ 1064 nm
     save(fullfile(output_folder,'sim_wl_mean.txt'),'lambda','-ascii','-tabs');
    
    %% load the literature OPs
    %for sim_index=sim_index_arr
    for sim_index=100  
        fprintf('toSim_OP_%d \n',sim_index);
        subject_folder=fullfile(output_folder,subject_name,['litOP_' num2str(sim_index)]);
        if exist(fullfile(subject_folder,['sim_summary_' num2str(length(lambda)) '.json']),'file')
            continue;
        end
        mkdir(subject_folder);
        
        tissue_param=load(fullfile(literature_OP_arr,['toSim_OP_' num2str(sim_index) '.txt']));
        %toSim_OP_100.txt is the average OP in 650 ~ 1064 nm from paper
        
        if do_sinus==1
            tissue_param=[tissue_param zeros(size(tissue_param,1),1) ones(size(tissue_param,1),1)*0.000001];
        end
        
        if test_photon_path
            tissue_param=[tissue_param ones(size(tissue_param,1),1)*0.001 ones(size(tissue_param,1),1)*0.000001];
            tissue_param=tissue_param(1,:);
            lambda=lambda(1);
        end
        
        to_save=[lambda tissue_param];
        save(fullfile(subject_folder,'tissue_param.txt'),'to_save','-ascii','-tabs');
        
        sim_set.num_SDS=num_SDS;
        sim_set.detector_r=ones(sim_set.num_SDS,1)*detector_r;
        sim_set.detector_larger_r=ones(sim_set.num_SDS,1)*detector_larger_r;
        sim_set.detector_NA=ones(sim_set.num_SDS,1)*detector_NA;
        sim_set.num_photon=num_photon;
        sim_set.to_output_layer=1:5;
        if do_sinus==1
            sim_set.num_layer=6;
            sim_set.n=[n n n n n 1];
            sim_set.g=[g g g g g 1];
        else
            sim_set.num_layer=5;
            sim_set.n=ones(1,sim_set.num_layer)*n;
            sim_set.g=ones(1,sim_set.num_layer)*g;
        end
        
        if test_photon_path
            sim_set.num_layer=sim_set.num_layer+1;
            sim_set.n(end+1)=1;
            sim_set.g(end+1)=1;
        end
        
        sim_set.fiber_n=outer_n;
        sim_set.photon_per_simulation=250000000;
        sim_set.mcx_max_detpt=4000000;
        
        setting_angle=50; % degree
        equivalent_r=22.5; % mm
        
        if strcmp(source_type,'pencil')==1
            sim_set.source_NA=0;
            sim_set.source_r=0;
            sim_set.source_type='pencil';
        elseif strcmp(source_type,'fiber')==1
            sim_set.source_NA=source_NA;
            sim_set.source_r=0;
            sim_set.source_type='cone';
        elseif strcmp(source_type,'disk')==1
            sim_set.source_r=equivalent_r; % mm
            sim_set.source_NA=0;
            sim_set.source_type='disk';
        elseif strcmp(source_type,'cone')==1
            sim_set.source_NA=sin(setting_angle/180*pi)*outer_n; % the numerical aperture of the source
            sim_set.source_r=0;
            sim_set.source_type='zgaussian';
            sim_set.srcparam1=[0.36338 0 0 0]; % the variance of gaussian distribution
            sim_set.srcparam2=[0 0 0 0];
        elseif strcmp(source_type,'disk1')==1
            sim_set.source_r=22.5; % mm
            sim_set.source_NA=0;
            sim_set.source_type='disk';
        elseif strcmp(source_type,'disk2')==1
            sim_set.source_r=20; % mm
            sim_set.source_NA=0;
            sim_set.source_type='disk';
        elseif strcmp(source_type,'disk3')==1
            sim_set.source_r=15; % mm
            sim_set.source_NA=0;
            sim_set.source_type='disk';
        elseif strcmp(source_type,'disk4')==1
            sim_set.source_r=10; % mm
            sim_set.source_NA=0;
            sim_set.source_type='disk';
        elseif strcmp(source_type,'cone1')==1 | strcmp(source_type,'cone4')==1 | strcmp(source_type,'cone7')==1 | strcmp(source_type,'cone10')==1
            sim_set.source_NA=0;
            sim_set.source_r=0;
            sim_set.source_type='anglepattern';
            sim_set.srcpattern=load('LED_20D_power_profile_CDF_IS.txt');
            sim_set.srcparam1=[10000 0 0 0]; % the number of CDF interval
            sim_set.srcparam2=[0 0 0 0];
        elseif strcmp(source_type,'cone2')==1 | strcmp(source_type,'cone5')==1 | strcmp(source_type,'cone8')==1 | strcmp(source_type,'cone11')==1
            sim_set.source_NA=0;
            sim_set.source_r=0;
            sim_set.source_type='anglepattern';
            sim_set.srcpattern=load('LED_30D_power_profile_CDF_IS.txt');
            sim_set.srcparam1=[10000 0 0 0]; % the number of CDF interval
            sim_set.srcparam2=[0 0 0 0];
        elseif strcmp(source_type,'cone3')==1 | strcmp(source_type,'cone6')==1 | strcmp(source_type,'cone9')==1 | strcmp(source_type,'cone12')==1
            sim_set.source_NA=0;
            sim_set.source_r=0;
            sim_set.source_type='anglepattern';
            sim_set.srcpattern=load('LED_40D_power_profile_CDF_IS.txt');
            sim_set.srcparam1=[10000 0 0 0]; % the number of CDF interval
            sim_set.srcparam2=[0 0 0 0];
        end
        
        save(fullfile(subject_folder,'sim_set.mat'),'sim_set');
        
        %% do simulation
        fun_MCX_sim_dist2axis(tissue_param,vol,voxel_size,p_pos,p_dir,sim_set,subject_folder,output_fluence_rate,output_pathlength,output_jacobian,1,0,0);
    end
end
disp('Done!');