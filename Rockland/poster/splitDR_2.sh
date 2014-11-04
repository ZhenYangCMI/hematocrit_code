


# full/path/to/site/subject_list
subject_list=/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subList_ultraclearn45sub_poster_final.txt

### split the dual regression and reorgnize the files 
for covType in noGSR; do

dataDir=/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/DualRegression

	for sub in `cat $subject_list`; do

		echo --------------------------
		echo running subject ${sub}
		echo ---------------------
		cd ${dataDir}
		#fslsplit DualRegression_${sub}.nii DualRegression_${sub}_

		for comp in 0 1 2 3 4 5 6 7 8 9; do
			mkdir -p /home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/DualRegression${comp}
			3dcalc -a DualRegression_${sub}_000${comp}.nii.gz -expr 'a' -prefix /home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/DualRegression${comp}/DualRegression${comp}_${sub}.nii.gz
		done
	done
done

# smooth the DegreeCentrality
dataDir=/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/DegreeCentrality_unsmoothed
dataOutput=/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/DegreeCentrality
smooth=6
maskDir=/home/data/Projects/Zhen/hematocrit/Rockland_poster/masks


	for sub in `cat $subject_list`; do

		echo --------------------------
		echo running subject ${sub}
		echo ---------------------
		
3dBlurInMask -input ${dataDir}/DegreeCentrality_${sub}.nii.gz -FWHM ${smooth} -mask ${maskDir}/meanStandFunMask_45sub_90prct.nii.gz -prefix ${dataOutput}/DegreeCentrality_${sub}.nii
done
