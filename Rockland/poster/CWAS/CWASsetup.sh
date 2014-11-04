
smooth=6

subList="/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subList_ultraclearn45sub_poster_final.txt" 
maskDir="/home/data/Projects/Zhen/hematocrit/Rockland_poster/masks/CWAS"
preprocessDate='6_1_14'
dataDir="/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/FunImg"

## 1. resample the data to 3mm and create the grey matter mask for individual subjects



	
	for sub in `cat $subList`; do
		echo ${sub}
		echo --------------------------
		echo "running subject ${sub}"
		echo --------------------------

		3dresample -master /usr/share/data/fsl-mni152-templates/MNI152_T1_3mm_brain.nii.gz -prefix /home/data/Projects/Zhen/hematocrit/CPAC_results/CPAC_zy6_1_14_reorganized/noGSR/FunImg/normFunImg_${sub}_3mm.nii.gz -inset /home/data/Projects/Zhen/hematocrit/CPAC_results/CPAC_zy6_1_14_reorganized/noGSR/FunImg/normFunImg_${sub}.nii.gz

		# mask the grey matter
		3dcalc -a ${dataDir}/normFunImg_${sub}_3mm.nii.gz -b /home2/data/Projects/Zhen/workingMemory/mask/MNI152_T1_GREY_3mm_25pc_mask.nii.gz -expr 'a*b' -prefix ${dataDir}/normFunImg_${sub}_3mm_masked.nii.gz
				
		# use the std to create the mask	
		cmd1="fslmaths ${dataDir}/normFunImg_${sub}_3mm_masked.nii.gz -Tstd -bin ${maskDir}/stdMask_${sub}"
		echo $cmd1
		eval $cmd1

	done


## 2. create the group mask
subIncludedList='/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subListFunImgPathForCWASMask.txt'
rm $subIncludedList
for sub in `cat $subList`; do
echo "${maskDir}/stdMask_${sub}.nii.gz" >> $subIncludedList
done

a=$(cat $subIncludedList)

cmd1="3dMean -prefix ${maskDir}/stdMask_noGSR_45sub.nii.gz $a"
echo $cmd1
eval $cmd1

3dcalc -a ${maskDir}/stdMask_noGSR_45sub.nii.gz -expr 'step(a-0.99999)' -prefix ${maskDir}/stdMask_noGSR_45sub_100prct.nii.gz

# check the CWAS mask
3dTcat -prefix /home/data/Projects/Zhen/hematocrit/maskPoster/CWAS/stdMask_46sub.nii.gz /home/data/Projects/Zhen/hematocrit/maskPoster/CWAS/stdMask_M*.nii.gz


## 3. smooth data

for sub in `cat $subList`; do
echo ${sub}
		echo --------------------------
		echo "running subject ${sub}"
		echo --------------------------
3dmerge -1blur_fwhm 6.0 -doall -prefix ${dataDir}/normFunImg_${sub}_3mm_masked_fwhm${smooth}_3dmerge.nii.gz ${dataDir}/normFunImg_${sub}_3mm_masked.nii.gz
#3dBlurInMask -input ${dataDir}/normFunImg_${sub}_3mm_masked.nii.gz -FWHM ${smooth} -mask ${maskDir}/stdMask_noGSR_45sub_100prct.nii.gz -prefix ${dataDir}/normFunImg_${sub}_3mm_masked_fwhm${smooth}.nii.gz
done
## 4. create filepath for all subject
for sub in `cat $subList`; do
sublistFile='/home/data/Projects/Zhen/hematocrit/hematocrit_code/Rockland/poster/CWAS/subFilePath.txt'
	echo "${dataDir}/normFunImg_${sub}_3mm_masked_fwhm${smooth}_3dmergy.nii.gz" >> $sublistFile
	done
