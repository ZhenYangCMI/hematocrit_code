% This script perform the group analysis for full model
% check whether the standardized or non-standardized data were used

clear all;
% group analysis for DS project

% Initiate the settings.
% 1. define Dir
subType='ultraclean43sub' % ultraclean35sub

subListFile=['/home/data/Projects/hematocrit/data/subList_', subType, '.txt'];
subList1=fopen(subListFile);
subList=textscan(subList1, '%s', 'delimiter', '\n')
subList=cell2mat(subList{1})

numSub=length(subList);

measureList={'ReHo','ALFF', 'fALFF', 'VMHC'};
%measureList={'ALFF'};
numMeasure=length(measureList)

GroupAnalysis=['/home/data/Projects/hematocrit/results'];

mask=['/home/data/Projects/hematocrit/mask/meanFunMask_ultraclean43sub_90percent.nii'];
%mask=['/home/data/Projects/hematocrit/mask/meanFunMask_', subType, '_90percent.nii'];


for j=1:numMeasure
    measure=char(measureList{j});
    
    
    % 2. set path
    addpath /home/data/HeadMotion_YCG/YAN_Program/mdmp
    addpath /home/data/HeadMotion_YCG/YAN_Program
    addpath /home/data/HeadMotion_YCG/YAN_Program/TRT
    addpath /home/data/HeadMotion_YCG/YAN_Program/DPARSF_V2.2_130309
    addpath /home/data/HeadMotion_YCG/YAN_Program/spm8
    [ProgramPath, fileN, extn] = fileparts(which('DPARSFA_run.m'));
    Error=[];
    addpath([ProgramPath,filesep,'Subfunctions']);
    [SPMversion,c]=spm('Ver');
    SPMversion=str2double(SPMversion(end));
    
    % 3. group analysis
    
    % define FileNameSet
    FileNameSet=[];
    
    for i=1:length(subList)
        
        sub=subList(i,1:9);
        
        FileName = sprintf('/home/data/Projects/hematocrit/data/reorganized/%s/zs%s_%s.nii.gz', measure,measure,sub);
        
        
        if ~exist(FileName,'file')
            
            disp(sub)
            
        else
            FileNameSet{i,1}=FileName;
            
        end
        
    end
    
    % define AllCov
    
    model=load(['/home/data/Projects/hematocrit/data/regressModel_', subType, '.txt'])
    
    mkdir([GroupAnalysis,filesep,measure, filesep, subType]);
    outDir=[GroupAnalysis,filesep,measure, filesep, subType];
    
    % model
    if strcmp(subType, 'ultraclean43sub')
        labels={'sex', 'HCT_demean', 'sexByHCTdemean', 'age_demean', 'PowermeanFD_demean', 'constant'}
        modelData=[model(:, 7) model(:, 8) model(:, 11) model(:, 9) model(:, 10) ones(numSub, 1)];
    else
        % focus on disease and its interaction with HCT
        %labels={'diseaseRecode1', 'HCT_demean', 'diseaseByHCTdemean', 'age_demean', 'sex','PowermeanFD_demean', 'constant'}
        %modelData=[model(:, 1) model(:, 3) model(:, 4) model(:, 5) model(:, 6) model(:, 7) ones(numSub, 1)];
        % focus on sex and its interaction with HCT
%         labels={'sex', 'HCT_demean', 'sexByHCTdemean', 'age_demean', 'diseaseRecode2','PowermeanFD_demean', 'constant'}
%         modelData=[model(:, 9) model(:, 3) model(:, 10) model(:, 5) model(:, 11) model(:, 7) ones(numSub, 1)];
        % full model
        labels={'sex', 'diseaseRecode1' 'HCT_demean', 'sexByHCTdemean', 'diseaseByHCTdemean','diseaseBySexByHCTdemean', 'age_demean', 'PowermeanFD_demean', 'constant'}
        modelData=[model(:, 7) model(:, 1) model(:, 3) model(:, 10) model(:, 4) model(:, 12) model(:, 5) model(:, 7) ones(numSub, 1)];
    end
    
    OutputName=[outDir,filesep,measure, '_', subType]
    y_GroupAnalysis_Image(FileNameSet,modelData,OutputName,mask);
    
    
    % convert T to Z scores
    
    if strcmp(subType, 'ultraclean43sub')
        effectList={'T1', 'T2', 'T3', 'T4', 'T5'};
        Df1=36;
        % ultraclean35sub(df1=35-6-1=28); full87sub (df1=85-7-1=77); ultraclean43sub(df1=43-6-1=36);
    else
        %for disease or sex focused model
%         effectList={'T1', 'T2', 'T3', 'T4', 'T5', 'T6'};
%         Df1=77;
% for full  model
effectList={'T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8'};
        Df1=75;
    end
    
    for k=1:length(effectList)
        effect=char(effectList{k})
        
        resultDir=['/home/data/Projects/hematocrit/results/', measure, '/', subType, '/'];
        ImgFile=[resultDir, measure, '_', subType, '_', effect, '.nii'];
        OutputName=[resultDir, measure, '_', subType, '_', effect, '_Z.nii'];
        Flag='T';
        [Z P] = y_TFRtoZ(ImgFile,OutputName,Flag,Df1);
    end
    
end




