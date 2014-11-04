

measureList={'ReHo','fALFF', 'VMHC', 'DegreeCentrality', 'DualRegression0', 'DualRegression1', 'DualRegression2', 'DualRegression3', 'DualRegression4', 'DualRegression5', 'DualRegression6', 'DualRegression7', 'DualRegression8', 'DualRegression9', 'ALFF', 'normMeanFun'};

globalMeanAll=[];
for i=1:length(measureList)
measure=char(measureList{i})

if strcmp(measure(1:3), 'HCT')
a=load(['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/meanRegress/CWASiFC_', measure, '/', measure, '_MeanSTD.mat'])
else
a=load(['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/meanRegress/', measure, '/', measure, '_MeanSTD.mat'])
end
globalMean=a.Mean_AllSub;
globalMeanAll(:,i)=globalMean;
end
size(globalMeanAll)
save('globalMeanAll.txt', '-ascii', '-tabs', 'globalMeanAll')
