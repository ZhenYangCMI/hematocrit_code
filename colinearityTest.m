% multicolinearity test
clear
clc

subType= ['full85sub']  %full85sub
numSub=85

model=load(['/home/data/Projects/hematocrit/data/regressModel_', subType, '.txt']);

% if ultraclean35sub
% labels={'sex', 'HCT_demean', 'sexByHCTdemean', 'age_demean', 'PowermeanFD_demean', 'constant'}
% modelData=[model(:, 1) model(:, 2) model(:, 5) model(:, 3) model(:, 4) ones(numSub, 1)];

% if full87sub
% labels={'diseaseStatus', 'HCT_demean', 'diseaseByHCTdemean', 'age_demean', 'sex','PowermeanFD_demean', 'constant'}
%         modelData=[model(:, 1) model(:, 3) model(:, 4) model(:, 5) model(:, 6) model(:, 7) ones(numSub, 1)];


labels={'sex', 'diseaseRecode1' 'HCT_demean', 'sexByHCTdemean', 'diseaseByHCTdemean','diseaseBySexByHCTdemean', 'age_demean', 'PowermeanFD_demean', 'constant'}
modelData=[model(:, 9) model(:, 1) model(:, 3) model(:, 10) model(:, 4) model(:, 12) model(:, 5) model(:, 7) ones(numSub, 1)];
% You can also add an interecept term, which reproduces Belsley et al.'s
% example
colldiag(modelData,labels)


figure(1)
imagesc(modelData)

%infoFT=colldiag(modelFT,labelsFT,0.5,true);
%
% % That can be passed along for visualization
%colldiag_tableplot(infoFT);
%
%
% infoBT=colldiag(modelBT,labels,0.5,true);
% colldiag_tableplot(infoBT);
