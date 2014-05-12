# generate subfilePath and mask the data with the CWAS mask

smooth=6

## 1. smooth the functional data 
subType='full';
subList="/home/data/Projects/hematocrit/data/subList_${subType}.txt" 

for sub in `cat $subList`; do

3dmerge -1blur_fwhm ${smooth} -doall -prefix /home/data/Projects/hematocrit/data/reorganized/FunImg/normFunImg_${sub}_fwhm${smooth}.nii /home/data/Projects/hematocrit/data/reorganized/FunImg/normFunImg_${sub}.nii.gz
3dcalc -a /home/data/Projects/hematocrit/data/reorganized/FunImg/normFunImg_${sub}_fwhm${smooth}.nii -b /home2/data/Projects/workingMemory/mask/MNI152_T1_GREY_3mm_25pc_mask.nii.gz -expr 'a*b' -prefix /home/data/Projects/hematocrit/data/reorganized/FunImg/normFunImg_${sub}_fwhm${smooth}_grey.nii

rm /home/data/Projects/hematocrit/data/reorganized/FunImg/normFunImg_${sub}_fwhm${smooth}.nii
done

## 2. create the group mask
for sub in `cat $subList`; do

cmd="fslmaths /home/data/Projects/hematocrit/data/reorganized/FunImg/normFunImg_${sub}_fwhm${smooth}_grey.nii -Tstd -bin /home/data/Projects/hematocrit/mask/CWAS/stdMask_${sub}.nii"
#3dAutomask -overwrite -prefix /home/data/Projects/workingMemory/mask/CPACpreprocessing/CWAS_${covType}/autoMask_${sub}.nii.gz  /home/data/Projects/workingMemory/results/CPAC_analysis_new/reorgnized/${covType}/FunImg_4mm_fwhm${smooth}/normFunImg_${sub}_4mm_fwhm${smooth}_masked.nii 
echo $cmd
eval $cmd

done

## 2. create the subject data path file for CWAS
smooth=6
subType='full87sub'; # ultraclean39sub full87sub
subList="/home/data/Projects/hematocrit/data/subList_${subType}.txt" 

rm "/home/data/Projects/hematocrit/data/subList_${subType}_path.txt" 
sublistFile="/home/data/Projects/hematocrit/data/subList_${subType}_path.txt" 

for sub in `cat $subList`; do
echo "/home/data/Projects/hematocrit/data/reorganized/FunImg/normFunImg_${sub}_fwhm${smooth}_grey.nii" >> $sublistFile
done

## 3. generate the CWAS mask
sublistFileMask="/home/data/Projects/hematocrit/data/subMask_${subType}_path.txt" 
rm `echo ${sublistFileMask}`
for i in `cat $subList`; do
echo "/home/data/Projects/hematocrit/mask/CWAS/stdMask_${i}.nii.gz" >> $sublistFileMask
done
a=$(cat $sublistFileMask)
cmd="3dMean -prefix /home/data/Projects/hematocrit/mask/stdFunMask_${subType}.nii $a"

echo $cmd
eval $cmd
rm `echo ${sublistFileMask}`

3dcalc -a /home/data/Projects/hematocrit/mask/stdFunMask_${subType}.nii -expr 'equals(a,1)' -prefix /home/data/Projects/hematocrit/mask/stdFunMask_${subType}_100percent.nii

#3dcalc -a /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm.nii -expr 'step(a-0.899)' -prefix /home/data/Projects/workingMemory/mask/CPAC_${preprocessDate}/${covType}/stdMask_68sub_3mm_90percent.nii

#rm /home/data/Projects/hematocrit/data/reorganized/FunImg/stdMask_M109*.nii

