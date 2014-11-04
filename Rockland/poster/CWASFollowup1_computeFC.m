% This script will compute the ROI based SCA

clear
clc

rmpath /home/milham/matlab/REST_V1.7
rmpath /home/milham/matlab/REST_V1.7/Template
rmpath /home/milham/matlab/REST_V1.7/man
rmpath /home/milham/matlab/REST_V1.7/mask
rmpath /home/milham/matlab/REST_V1.7/rest_spm5_files

restoredefaultpath

addpath(genpath('/home/data/Projects/Zhen/commonCode/spm8'))
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.3_130615/Subfunctions/
addpath /home/data/Projects/Zhen/commonCode/REST_V1.8_130615

dataDir=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/FunImg/'];

% text subList
subListFile=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subList_ultraclearn45sub_poster_final.txt'];
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})

% numerical subList

numSub=length(subList)
effect='HCTbySex' % HCT or HCTbySex
MaskData=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/masks/CWAS/stdMask_noGSR_45sub_100prct.nii.gz'];
mkdir (['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/CWASiFC_', effect])
outputDir=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/CWASiFC_', effect, '/'];
for i=1:numSub
       
    sub=subList(i, 1:9);
    AllVolume=[dataDir, 'normFunImg_', sub, '_3mm_masked_fwhm6_3dmerge.nii.gz'];
    
    %ROIDef={['/home/data/Projects/Zhen/Colibazzi/figs/finalAnalysis/cluster_mask_Group_text_Yeo_net5rmd.nii']}

if strcmp(effect, 'HCT')
    ROIDef={['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/CWAS_6_4_14/mdmr3mmFWHM6/cluster_mask_Hematocrit_demean.nii']}
else
ROIDef={['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/CWAS_6_4_14/mdmr3mmFWHM6/cluster_mask_HematocritBySex.nii']}
end
    OutputName=[outputDir, 'FC_ROI_', effect, '_', sub];
    IsMultipleLabel=1;
    [FCBrain, Header] = y_SCA(AllVolume, ROIDef, OutputName, MaskData, IsMultipleLabel);
end


