#!/bin/bash 


subList="/home/data/Projects/Zhen/hematocrit/data/HCP/sublist95sub.txt" 
sublistFile="/home/data/Projects/Zhen/hematocrit/data/HCP/sub_CWAS_dataPath.txt" 
rm /home/data/Projects/Zhen/hematocrit/data/HCP/sub_CWAS_dataPath.txt

% copy data over
for sub in `cat $subList`; do
Directory=/home/data/Originals/HCP/hcp1/${sub}
	if [ -d "$Directory" ]; then 
		for session in rfMRI_REST1_RL rfMRI_REST2_RL; do
		3dresample -master /home/data/Projects/Zhen/commonCode/MNI152_T1_3mm_brain.nii.gz -prefix /data2/hcp_hematocrit/${session}/FunImg_${sub}.nii -inset ${Directory}/MNINonLinear/Results/${session}/${session}_hp2000_clean.nii.gz
		done
	else
	Directory=/home/data/Originals/HCP/hcp2/${sub}
		for session in rfMRI_REST1_RL rfMRI_REST2_RL; do
		3dresample -master /home/data/Projects/Zhen/commonCode/MNI152_T1_3mm_brain.nii.gz -prefix /data2/hcp_hematocrit/${session}/FunImg_${sub}.nii -inset ${Directory}/MNINonLinear/Results/${session}/${session}_hp2000_clean.nii.gz
		done
	fi
done

#echo "/home/data/Projects/hematocrit/data/reorganized/FunImg/funMask_${i}.nii.gz" >> $sublistFile

#a=$(cat $sublistFile)
#cmd="3dMean -prefix /home/data/Projects/hematocrit/mask/meanFunMask_${subType}.nii.gz $a"

#echo $cmd
#eval $cmd



