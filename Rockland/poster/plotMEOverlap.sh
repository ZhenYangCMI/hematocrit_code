


dataDir=//home/data/Projects/Zhen/hematocrit/Rockland_poster/figs/modelWithRaceDummyCoded_final/threshed
3dcalc \
-a ${dataDir}/thresh_DegreeCentrality_T1_Z_cmb.nii \
-b ${dataDir}/thresh_fALFF_T1_Z_cmb.nii \
-c ${dataDir}/thresh_VMHC_T1_Z_cmb.nii \
-d ${dataDir}/thresh_DualRegression1_T1_Z_cmb.nii \
-e ${dataDir}/thresh_DualRegression2_T1_Z_cmb.nii \
-f ${dataDir}/thresh_DualRegression4_T1_Z_cmb.nii \
-g ${dataDir}/thresh_DualRegression5_T1_Z_cmb.nii \
-h ${dataDir}/thresh_DualRegression6_T1_Z_cmb.nii \
-expr 'astep(a,0)+astep(b,0)+astep(c,0)+astep(d,0)+astep(e,0)+astep(f,0)+astep(g,0)+astep(h,0)' \
-prefix ${dataDir}/thresh_HCT_overlap.nii.gz

-i ${dataDir}/thresh_Hematocrit_demean_3mm.nii \


dataDir=/home/data/Projects/Zhen/hematocrit/Rockland_poster/figs
3dcalc \
-a ${dataDir}/thresh_VMHC_T3_Z_cmb.nii \
-b ${dataDir}/thresh_DualRegression4_T3_Z_cmb.nii \
-c ${dataDir}/thresh_HematocritBySex_3mm.nii \
-expr 'astep(a,0)+astep(b,0)+astep(c,0)' \
-prefix ${dataDir}/thresh_HCTBySex_overlap.nii.gz

