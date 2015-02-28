function [p_best res errors ptsI]= printResults(m,nHyps,HypName,nBest)
% clear all

%% Path Settings

ribsDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';
dataPathUnix = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
    ribsDataPath = ribsDataPathUnix;
    rootPath = '/usr/biwinas01/scratch-g/sameig/';
    dataPath = dataPathUnix;
    rfCodePath ='/home/sameig/codes/RF_MexStandalone-v0.02/randomforest-matlab/RF_Class_C';
    cd(rfCodePath);
%     compile_linux;
else
     [~, s]=system('hostname');
    if strfind(s,'Vina')
        rootPath = 'Z:/N/';
        dataPath = 'Z:/N/Data/dataset';
        codePath = 'H:\codes\';
        ribsDataPath = 'O:\Bjorn_CT\';
    else
        codePath = 'H:\codes\';
        rootPath = 'N:/';
        ribsDataPath = 'O:\Bjorn_CT\';
        dataPath = 'N:/Data/dataset';
%         addpath(genpath([codePath 'RF_MexStandalone-v0.02-precompiled']));
    end
end


codePathRibs=[codePath 'ribFitting/'];

codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathSkeleton =   [codePath 'skeleton/'];

% ribModelPath = [ribsDataPath  'ribModel_rotatedEuler'];

mriAnglePath =[rootPath 'Ribs/mriAngleModel'];

   
% postFix = ['ribModel_rotatedEuler'];


% for m=mriSubjects
  if ~exist('HypName','var')
  HypName = 'ribCage_';
  end
   savePaths = [rootPath 'Ribs/' HypName num2str(m) ];

% savePaths= [rootPath 'Ribs/ribCage_' num2str(m) ];


addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);

%%

load([savePaths '_nHyps' num2str(nHyps)],'result');
% results{m}=result;
% settings=result.settings;
settings=result.settings;
if ~isfield(result.settings ,'ribModelName');
    result.settings.ribModelName='ribModel_rotatedEuler';
end
ribModelPath = [ribsDataPath  result.settings.ribModelName];

%% Load Rib Model

load(ribModelPath,'ribModel')
load(mriAnglePath,'MRangleModel')
% load(mriSubjectsPath, 'mriSubject');

%% Load Rib VTK Files


[ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);

%% Find first points

[firstPts, pts] = findFirstPoints(rib_nos,ptsI,settings,m);


%% Find the best cases


ribModelTest=ribModel;

ribModelTest.angleModel = MRangleModel;

   
[~, b]=sort(result.candidate_cost);
d_vector = result.candidate_params(b,:)';

if ~exist('nBest','var')
    nBest=length(d_vector);
end
nFirstPts = size(firstPts,3);
d_vector_params = floor((d_vector(1:nBest)-1)/nFirstPts)+1;
perturb = d_vector(1:nBest) - ( (d_vector_params-1)*nFirstPts )   ;
paramset = result.paramset(d_vector_params,:);

% paramset = result.paramset(d_vector(1:nBest),:);
% hypotheses = generateHypothesisRotateEulerListRibcageImportanceGeneral(ribModelTest,settings);
% hypotheses = generateHypothesisRibcageImportanceDisplay(ribModelTest,settings,paramset);

hypotheses = generateHypothesisRibcageImportanceDisplay(ribModelTest,settings,paramset,firstPts,settings.startP,perturb);


hyp = hypotheses.transformation;
numKnots=settings.nPoints;

for r = settings.ribNumber

    p_best{r} = hyp{r}(:,settings.startP:numKnots,1) + repmat(firstPts(:,r) -hyp{r}(:,settings.startP,1) ,1,numKnots-settings.startP+1);
    

end       



for d=1
    

        for r = settings.ribNumber

            p{r} = hyp{r}(:,settings.startP:numKnots,d) + repmat(firstPts(:,r) -hyp{r}(:,settings.startP,d) ,1,numKnots-settings.startP+1);

        end
        [cost, ~,errors]=computeErorr(p,ptsI);

        res = [cost  result.candidate_cost(b(d))/4  result.resultsTrue.candidate_cost/4];


end






