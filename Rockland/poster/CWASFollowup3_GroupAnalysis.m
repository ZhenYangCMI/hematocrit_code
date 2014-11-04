% This script perform the group analysis for full model
% check whether the standardized or non-standardized data were used

clear all;
clc


preprocessDate='6_1_14';
% Initiate the settings.
% 1. define Dir

subListFile='/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subList_ultraclearn45sub_poster_final.txt';
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})
numSub=length(subList)


measureList={'HCT', 'HCTbySex'};
numMeasure=length(measureList)

mask=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/masks/CWAS/stdMask_noGSR_45sub_100prct.nii.gz'];

GroupAnalysis=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/groupAnalysis/'];

% 2. set path
addpath /home/data/HeadMotion_YCG/YAN_Program/mdmp
addpath /home/data/HeadMotion_YCG/YAN_Program
addpath /home/data/HeadMotion_YCG/YAN_Program/TRT
addpath /home/data/HeadMotion_YCG/YAN_Program/DPARSF_V2.2_130309
addpath /home/data/HeadMotion_YCG/YAN_Program/spm8
[ProgramPath, fileN, extn] = fileparts(which('DPARSFA_run.m'));
Error=[];
addpath([ProgramPath,filesep,'Subfunctions']);
[SPMversion,c]=spm('Ver');
SPMversion=str2double(SPMversion(end));

% 3. Regression Model construction
% load phenotypical data
[NUM,TXT,RAW]=xlsread(['/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/forRegression_45sub.xlsx']);
% Model creation
labels=TXT(1,8:13);
labels{1, 7}='constant';
cov=NUM(:,7:12);
model=[cov ones(numSub, 1)];
disp(labels)


% 5. group analysis
for j=1:numMeasure
    measure=char(measureList{j})
    
    FileName = {['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy', preprocessDate, '_reorganized/meanRegress/CWASiFC_', measure, '/', measure, '_AllVolume_meanRegress.nii']};
    % perform group analysis
    mkdir([GroupAnalysis,measure]);
    outDir=[GroupAnalysis,measure];
    
    OutputName=[outDir,filesep, measure]
    y_GroupAnalysis_Image(FileName,model,OutputName,mask);
    
    % 6. convert t to Z
    effectList={'T1', 'T2', 'T3'};
    Df1=numSub-size(model,2) % N-k-1: N:number of subjects; k=num of covariates (constant excluded). size(model,2) included the constant
    
    for k=1:length(effectList)
        effect=char(effectList{k})
        
        ImgFile=[outDir, filesep, measure, '_', effect, '.nii'];
        OutputName=[outDir, filesep,  measure, '_', effect, '_Z.nii'];
        Flag='T';
        [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
    end
end
