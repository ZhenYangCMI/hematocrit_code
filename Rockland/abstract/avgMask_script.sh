#!/bin/bash 

subType='ultraclean43sub';  # ultraclean39sub full87sub
subList="/home/data/Projects/hematocrit/data/subList_${subType}.txt" 
sublistFile="/home/data/Projects/hematocrit/data/subList_${subType}_path.txt" 
rm /home/data/Projects/hematocrit/data/subList_${subType}_path.txt
for i in `cat $subList`; do
echo "/home/data/Projects/hematocrit/data/reorganized/FunImg/funMask_${i}.nii.gz" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home/data/Projects/hematocrit/mask/meanFunMask_${subType}.nii.gz $a"

echo $cmd
eval $cmd


# threshold the mean func mask at 0.9 and get the overlap with MNI brain mask
3dcalc -a /home/data/Projects/hematocrit/mask/meanFunMask_${subType}.nii.gz -b /home2/data/Projects/workingMemory/mask/MNI152_T1_3mm_brain_mask_dil.nii.gz -expr 'b*step(a-0.89999)' -prefix /home/data/Projects/hematocrit/mask/meanFunMask_${subType}_90percent.nii

#fslview /home/data/Projects/hematocrit/mask/meanFunMask_${subType}_90percent.nii.gz

#smooth=6
#for sub in `cat $subList`; do
#3dmerge -1blur_fwhm ${smooth} -doall -prefix /home/data/Projects/hematocrit/data/reorganized/DegreeCentrality/#zsDegreeCentrality_${sub}.nii.gz /home/data/Projects/hematocrit/data/reorganized/DegreeCentrality/#zDegreeCentrality_${sub}.nii.gz
# standardized before smoothing, the name zs is to be consistent with other derivatives
#done
