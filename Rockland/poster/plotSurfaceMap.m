clear
clc
close all

%addpath /home/data/Projects/Zhen/commonCode/BrainNetViewer1.43
addpath /home/data/Projects/Zhen/microstate/DPARSF_preprocessed/code/REST_V1.8_121225
addpath /home/data/Projects/Zhen/commonCode/DPARSF_V2.2_130309
addpath /home/data/Projects/Zhen/BIRD/BIRD_code/dynamicAnalysis/BrainNetViewer



imgInputDir = ['/home/data/Projects/Zhen/hematocrit/Rockland_poster/results/CPAC_zy6_1_14_reorganized/groupAnalysisWithRaceInModel_final/normMeanFunNotMeanRegressed/easythresh'];
cd (imgInputDir)

NMin=-2.33; PMin = 2.33;
%NMin=-1.64; PMin = 1.64; % for CWAS
%NMin=-0.001; PMin = 0.001; % for unthreshed
%NMax=-2; PMax=2; % for CWAS set for 3, for others set for 6; set for 5 to plot the overlapping
NMax=-4; PMax=4;
Prefix='';
DirImg = dir([imgInputDir,filesep,Prefix,'*cmb.nii']);

% AFNI colorMap
% ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0;1,0,0;0,0,1;0,0.2667,1;0,0.4118,1;0,0.6,1;0,0.8,1;0,1,1;];

%
% ColorMap=[1,1,0;1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0; 64, 224, 208; 106, 90, 205; 30, 144, 255; 255, 255, 0; 220, 20, 60];
%
% ColorMap=[1,0.8,0;1,0.6,0;1,0.4118,0;1,0.2667,0; 64, 224, 208; 106, 90, 205; 30, 144, 255; 255, 255, 0];


% the colorMap used to plot the threshed map
ColorMap=[1,1,0;1,0.85,0;1,0.7,0;1,0.55,0;1,0.4,0;1,0.25,0;0,0.25,1;0,0.4,1;0,0.55,1;0,0.7,1;0,0.85,1;0,1,1];
ColorMap=flipdim(ColorMap, 1);
cmap1 = colorRamp(ColorMap(1:6,:), 32);
cmap2= colorRamp(ColorMap(7:end,:), 32);
ColorMap=vertcat(cmap1,cmap2);

% the colormap used to plot the ME of overlap
%ColorMap=[255, 128, 128; 255, 0, 0; 255 255 255; 0 128 255; 255 227 0];
%  ColorMap=[255, 128, 128; 255, 0, 0; 255 255 255; 106 90 205; 255 0 0];
%  ColorMap=ColorMap/255;


surfaceMapOutputDir = imgInputDir;
numImg=length(DirImg)


PicturePrefix='';

ClusterSize=0;

SurfaceMapSuffix='_SurfaceMap.jpg';


ConnectivityCriterion=18;

[BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));

SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152_smoothed.nv'];

viewtype='MediumView';



for i=1:numImg
    InputName = [imgInputDir,filesep,DirImg(i).name];
    
    OutputName = [surfaceMapOutputDir,filesep, DirImg(i).name(1:end-4),SurfaceMapSuffix];
    
    H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
    
    eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
end


