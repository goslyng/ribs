
runFittingSettings;
pathSettings;

displayImages = 1;
settings.wFirstPoint = [0 0 0];


%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
load(mrAnglePath,'MRangleModel');
load(ribcageWOAngleModelPath,  'ribcageWOAngleModel');

allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;

allmodels.mrAngleModel = MRangleModel;
allmodels.ribcageWOAngleModel = ribcageWOAngleModel;
%% Find first points


[ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);

[firstPts, pts] = findFirstPoints(rib_nos,ptsI,settings,m);

