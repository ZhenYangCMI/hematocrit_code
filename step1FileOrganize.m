clear
clc

subType='ultraclean43sub'; %'ultraclean36sub
subListFile=['/home/data/Projects/hematocrit/data/subList_', subType, '.txt'];
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})
numSub=length(subList)
DCmask='meanFunMask_full_90percent';

% organize the CPAC processed data.

destinationDir=['/home/data/Projects/hematocrit/data/reorganized/'];
pipeline='_compcor_ncomponents_5_selector_pc10.linear1.wm0.global0.motion1.quadratic0.gm0.compcor1.csf0';


% mkdir ([destinationDir, 'T1Img'])
% mkdir ([destinationDir, 'FunImg'])
% mkdir ([destinationDir, 'ReHo'])
% mkdir ([destinationDir, 'VMHC'])
% mkdir ([destinationDir, 'fALFF'])
% mkdir ([destinationDir, 'ALFF'])
% mkdir ([destinationDir, 'DegreeCentrality'])
% mkdir ([destinationDir, 'DualRegression'])

for i=1:numSub
    sub=subList(i,1:9);
    disp(['Working on ', sub])
    
    subDir=['/data/Projects/nki_rs/output/pipeline_1400/', sub];
    
    %anat=[subDir, '/mni_normalized_anatomical/ants_deformed.nii.gz'];
    %anat2MNIAffine=[subDir, '/ants_affine_xfm/ants_Affine.txt']; % anat to mni
    %anat2MNIWarp=[subDir, '/anatomical_to_mni_nonlinear_xfm/ants_Warp.nii.gz'];
    
    %fun2anatAffine=['/home/data/Projects/workingMemory/results/CPAC_', processDate, '/working/resting_preproc_', sub, '/_scan_FunImg_rest/fsl_reg_2_itk_0/affine.txt'];
    funMask=[subDir, '/functional_brain_mask_to_standard/_scan_rest_rest_1400/REST_1400_3dc_RPI_3dv_automask_wimt.nii.gz'];
    %funNative=[subDir, '/functional_freq_filtered/_scan_FunImg_rest/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/bandpassed_demeaned_filtered.nii.gz'];
    %fun=[subDir, '/functional_mni/_scan_rest_rest_1400/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/bandpassed_demeaned_filtered_wtsimt.nii.gz']  % functional already in MNI space, only need to smooth and resample before run CWAS
    %meanFun=[subDir, '/mean_functional_in_mni/_scan_rest_rest_1400/REST_1400_3dc_RPI_3dv_3dc_3dT_wimt.nii.gz'] % mean funImg in MNI
    ReHo=[subDir, '/reho_Z_to_standard_smooth/_scan_rest_rest_1400/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/_fwhm_5/ReHo_maths_wimt_maths.nii.gz'];
    VMHC=[subDir, '/vmhc_z_score/_scan_rest_rest_1400/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/_fwhm_5/bandpassed_demeaned_filtered_maths_wtsimt_3dTcor_3dc.nii.gz'];
    fALFF=[subDir, '/falff_Z_to_standard_smooth/_scan_rest_rest_1400/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_hp_0.01/_lp_0.1/_fwhm_5/REST_1400_3dc_RPI_3dv_automask_3dc_maths_wimt_maths.nii.gz'];
    %DegreeCentrality=[subDir, '/centrality_outputs_zscore/_scan_rest_rest_1400/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_bandpass_freqs_0.01.0.1/_mask_', DCmask, '/degree_centrality_binarize_maths.nii.gz'];
    ALFF=[subDir, '/alff_Z_to_standard_smooth/_scan_rest_rest_1400/_csf_threshold_0.96/_gm_threshold_0.7/_wm_threshold_0.96/', pipeline, '/_hp_0.01/_lp_0.1/_fwhm_5/residual_filtered_3dT_maths_wimt_maths.nii.gz'];
    %copyfile(anat, [destinationDir, 'T1Img/normT1_', sub, '.nii.gz'])
    %copyfile(anat2MNIAffine, [destinationDir, 'T1Img/anat2MNIAffine_', sub, '.txt'])
    %copyfile(anat2MNIWarp, [destinationDir, 'T1Img/anat2MNIWarp_', sub, '.nii.gz'])
    %copysfile(fun2anatAffine, [destinationDir, 'T1Img/fun2anatAffine_', sub, '.txt'])
    
    %copyfile(funNative, [destinationDir, 'FunImg/FunImg_', sub, '.nii.gz'])
    %copyfile(fun, [destinationDir, 'FunImg/normFunImg_', sub, '.nii.gz'])
    copyfile(funMask, [destinationDir, 'FunImg/funMask_', sub, '.nii.gz'])
    %     copyfile(meanFun, [destinationDir, 'FunImg/normMeanFun_', sub, '.nii.gz'])
    copyfile(ReHo, [destinationDir, 'ReHo/zsReHo_', sub, '.nii.gz'])
    copyfile(VMHC, [destinationDir, 'VMHC/zsVMHC_', sub, '.nii.gz'])
    copyfile(fALFF, [destinationDir, 'fALFF/zsfALFF_', sub, '.nii.gz'])
    %copyfile(DegreeCentrality, [destinationDir, 'DegreeCentrality/zDegreeCentrality_', sub, '.nii.gz'])
    copyfile(ALFF, [destinationDir, 'ALFF/zsALFF_', sub, '.nii.gz'])
    
end

