

clear all 

ribsDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';
dataPathUnix = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
    ribsDataPath = ribsDataPathUnix;
    rootPath = '/usr/biwinas01/scratch-g/sameig/';
    dataPath = dataPathUnix;
    rfCodePath ='/home/sameig/codes/RF_MexStandalone-v0.02/randomforest-matlab/RF_Class_C';
    addpath(rfCodePath);

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
        addpath(genpath([codePath 'RF_MexStandalone-v0.02-precompiled']));
    end
end


codePathRibs=[codePath 'ribFitting/'];
codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathSkeleton =   [codePath 'skeleton/'];

addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);


displayImages = 1;
runFittingSettings;
settings.nSamplesRibcage = 6;
settings.wFirstPoint = [0 0 0 ];

ribShapeCoefModelsPath = [ribsDataPath 'new_' 'ribShapeCoefModels'];
ribCageLengthModelPath = [ribsDataPath 'new_' 'ribCageLengthModel'];
ribAngleModelCTPath = [ribsDataPath 'new_' 'ribAngleModelCT'];
ribcageModelPath = [ribsDataPath 'new_' 'ribcageModel'];
ribcageWOAngleModelPath = [ribsDataPath 'new_'    'ribcageWOAngleModel'];
ribShapeModelPath= [ribsDataPath 'new_' 'ribShapeModel'];




%% Model paths

ribcageMRIModelPath = [ ribsDataPath 'new_MRIribcageModel' ];

%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;


%% Load Rib VTK Files

for m=mriSubjects
    [ptsI{m}, rib_nos{m}]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);
end

%% Find first points

for m=mriSubjects

    [firstPts{m}, pts{m}] = findFirstPoints(rib_nos{m},ptsI{m},settings,m);

end

%%

% ribcageModel = ribModel;
nCompsRibcage = settings.nCompsRibcage;
nCompsRibCoef = settings.nCompsRibCoef;

nSamplesRibcage = settings.nSamplesRibcage;

meanLen = ribcageModel.meanLen;
nStd = settings.nStd;

nPoints = settings.nPoints;
ribNumber = settings.ribNumber;
%%

for m=mriSubjects
    st{m} = load(savePaths{m});
    st{m}.ang_(7:10,:)
end

for m=mriSubjects([2 4:9])
%     try
figure;
    err_ribs(m,:) = setAngleIndividual(m)
%     catch
%         m
%     end
end



%%
for m=mriSubjects
    
    savePaths{m} = [rootPath 'Ribs/ang_Cost_det' num2str(m)  ];
    
end

for m=mriSubjects
    try
dat{m}=load(savePaths{m});
    catch
    m
    end
end

for m=mriSubjects
mean(dat{m}.err_ribs(:,7:10),2);
end
%%
close all
for m=mriSubjects
%     dat{m}.cost(:,7:10)
try
[~,k]=min(mean(dat{m}.cost(:,7:10),2));
    figure(m);
    plot33(pts{m},'b.',[1 3 2]);
    hold on;    
    for r=7:10
        plot33(dat{m}.newData_{k}{r},'r.',[1 3 2]);
    end
    axis equal
catch
    m
end
end



