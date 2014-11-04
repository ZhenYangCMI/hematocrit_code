#!/bin/bash 


subList="/data2/zhen/cobre/subList/subList_148sub.txt" 

# check the total number of volumes
for i in `cat $subList`; do
#echo ${i} >> timepoints_cobre.txt
fslnvols /data2/zhen/cobre/raw_data/${i}/session_1/rest_1/rest.nii.gz >> timepoints_cobre.txt
done

# concate meanFunImg

subList="/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subList_ultraclearn_41sub.txt" 
sublistFile="/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subMeanFunImgpath.txt" 
rm /home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subMeanFunImgpath.txt

for i in `cat $subList`; do
echo "/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/FunImg/normMeanFun_${i}.nii.gz" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dTcat -prefix /home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/meanRegress/normMeanFunNotMeanRegressed41sub/normMeanFunNotMeanRegressed_41sub.nii $a"

echo $cmd
eval $cmd



# concate the meanFun and T1 to check for registration
cmd="3dTcat -prefix /home/data/Projects/Zhen/BIRD/generalizeClassifier/outPut/noGSR/FunImg/normMeanFun_75sub.nii.gz /home/data/Projects/Zhen/BIRD/generalizeClassifier/outPut/noGSR/FunImg/normMeanFun_*.nii.gz"
echo $cmd
eval $cmd

3dTcat -prefix /home/data/Projects/Zhen/BIRD/generalizeClassifier/outPut/noGSR/T1Img/normT1_75sub.nii.gz /home/data/Projects/Zhen/BIRD/generalizeClassifier/outPut/noGSR/T1Img/normT1_*.nii.gz

# create group mask for DC
numSub=45
subList="/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subList_ultraclearn${numSub}sub_poster_final.txt" 
sublistFile="/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subListFunImgMaskpath.txt" 
rm /home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subListFunImgPathForMask.txt

for i in `cat $subList`; do
echo "/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/FunImg/standFunMask_${i}.nii.gz" >> $sublistFile
done
a=$(cat $sublistFile)
cmd="3dMean -prefix /home/data/Projects/Zhen/hematocrit/Rockland_poster/masks/meanStandFunMask_${numSub}sub.nii.gz $a"

echo $cmd
eval $cmd

# threshold the mean func mask at 0.9 and get the overlap with MNI brain mask
3dcalc -a /home/data/Projects/Zhen/hematocrit/Rockland_poster/masks/meanStandFunMask_${numSub}sub.nii.gz -b /usr/share/data/fsl-mni152-templates/MNI152_T1_2mm_brain_mask_dil.nii.gz -expr 'b*step(a-0.89999)' -prefix /home/data/Projects/Zhen/hematocrit/Rockland_poster/masks/meanStandFunMask_${numSub}sub_90prct.nii.gz 

#fslview /home/data/Projects/hematocrit/mask/meanFunMask_${subType}_90percent.nii.gz




