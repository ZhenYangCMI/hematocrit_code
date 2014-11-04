clear
clc

% text subList
subListFile=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/data/subList_ultraclearn45sub_poster_final.txt'];
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})

BrainMaskFile=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/masks/CWAS/stdMask_noGSR_45sub_100prct.nii.gz'];

effectList={'HCT', 'HCTbySex'};
for k=1:length(effectList)
    effect=char(effectList(k));
    mkdir (['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/meanRegress/CWASiFC_', effect])       
              dataOutDir=['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/meanRegress/CWASiFC_', effect '/'];

        %Test if all the subjects exist
        
        FileNameSet=[];
        
        for i=1:length(subList)
            sub=subList(i, 1:9);
            disp(['Working on ', sub])
                       
                FileName = ['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/noGSR/CWASiFC_', effect, '/FC_ROI_', effect, '_', sub, '.nii'];          
                       
            if ~exist(FileName,'file')
                
                disp(sub)
                
            else
                
                FileNameSet{i,1}=FileName;
                
            end
            
        end
        
        FileNameSet;
        
        [AllVolume,vsize,theImgFileList, Header,nVolumn] =rest_to4d(FileNameSet);
        
        
        
        [nDim1 nDim2 nDim3 nDimTimePoints]=size(AllVolume);
        
        
        
        
        
        %Set Mask
        
        if ~isempty(BrainMaskFile)
            
            [MaskData,MaskVox,MaskHead]=rest_readfile(BrainMaskFile);
            
        else
            
            MaskData=ones(nDim1,nDim2,nDim3);
            
        end
        
        
        % Convert into 2D. NOTE: here the first dimension is voxels,
        
        % and the second dimension is subjects. This is different from
        
        % the way used in y_bandpass.
        
        %AllVolume=reshape(AllVolume,[],nDimTimePoints)';
        
        AllVolume=reshape(AllVolume,[],nDimTimePoints);
        
        
        MaskDataOneDim=reshape(MaskData,[],1);
        
        MaskIndex = find(MaskDataOneDim);
        
        nVoxels = length(MaskIndex);
        
        %AllVolume=AllVolume(:,MaskIndex);
        
        AllVolume=AllVolume(MaskIndex,:);
        
        
        
        AllVolumeBAK = AllVolume;
        
        
        % compute the mean and st acorss all voxels for each sub
        Mean_AllSub = mean(AllVolume)';
        
        Std_AllSub = std(AllVolume)';
        
        %Prctile_25_75 = prctile(AllVolume,[25 50 75]);
        
        
        %Median_AllSub = Prctile_25_75(2,:)';
        
        %IQR_AllSub = (Prctile_25_75(3,:) - Prctile_25_75(1,:))';
        
        
        Mat = [];
        
        Mat.Mean_AllSub = Mean_AllSub;
        
        Mat.Std_AllSub = Std_AllSub;
        
        OutputName=[dataOutDir, effect];
        save([OutputName,'_MeanSTD.mat'],'Mean_AllSub','Std_AllSub');
        
        
        Cov = Mat.Mean_AllSub;
        
        
        %Mean centering
        
        Cov = (Cov - mean(Cov))/std(Cov);
        
        
        AllVolumeMean = mean(AllVolume,2);
        
        AllVolume = (AllVolume-repmat(AllVolumeMean,1,size(AllVolume,2)));
        
        
        %AllVolume = (eye(size(Cov,1)) - Cov*inv(Cov'*Cov)*Cov')*AllVolume; %If the time series are columns
        
        AllVolume = AllVolume*(eye(size(Cov,1)) - Cov*inv(Cov'*Cov)*Cov')';  %If the time series are rows
        
        %AllVolume = AllVolume + repmat(AllVolumeMean,1,size(AllVolume,2));
        
        
        AllVolumeSign = sign(AllVolume);
        
        
        % write the data as a 4D volume
        AllVolumeBrain = (zeros(nDim1*nDim2*nDim3, nDimTimePoints));
        
        AllVolumeBrain(MaskIndex,:) = AllVolume;
        
        
        
        AllVolumeBrain=reshape(AllVolumeBrain,[nDim1, nDim2, nDim3, nDimTimePoints]);
        
        Header_Out = Header;
        
        Header_Out.pinfo = [1;0;0];
        
        Header_Out.dt    =[16,0];
        
        %write 4D file as a nift file
        outName=[dataOutDir, effect, '_AllVolume_meanRegress.nii'];
        rest_Write4DNIfTI(AllVolumeBrain,Header_Out,outName)
        
    end

