%% General Settings

% mriSubjects = [18 19 23:28 31 33:34 50:54 56:59];
mriSubjects =[50:54 550 56:59 60 61 63 64 65 66];%[56:59];


ctSubjects=1:20;
ctRibNumbers = 1:24;
rightRibs = 1:2:24;
testRibs = 7:10;
testRibs2 = rightRibs(testRibs);

ct_ap = [-1   0  0];
ct_is = [ 0   0 -1];
ct_lr = [ 0  -1  0];

% displayImages=1;

numKnots=100;
%Angle Point Reparameterization
numKnots1=20;
numKnots2=80;

numKnotsVertebra = 100;

nCompsAngle = 5;
nCompsShape = 6;

nCompsRibCage = 2;
nCompsLength = 2;

nn=1;
anglePointRange=1:40;


%%
settings.nPoints= 100; % Number of points on each rib on the shape model
settings.doTestManualRibs = 1;
settings.displayImages = 0;
settings.debug = 0;
settings.verbose=1;
settings.ribNumber = 7:10;

settings.ap = [-1  0  0];
settings.is = [ 0  1  0];
settings.lr = [ 0  0 -1];

%% Appearance Model Settings

settings.nccPatch_size =[7, 7, 0];

% Patch sizes
settings.x_hw = 15;
settings.y_hw = 15;
settings.z_hw = 0;
settings.patch_size = [settings.x_hw, settings.y_hw, settings.z_hw];

% The windows around the rib points to be tested by the classifier
settings.doConv=1;
% settings.hw_s0=[ 5 5 1];
% settings.hw_s=[ 2 2 2];

% settings.hw_sigma1 = 0.7;

% settings.hw_s = [0 0 0]; 
settings.hw_sigma0 = 3;
settings.hw_sigma(1) = 3;
settings.hw_sigma(2) = 0.9;
settings.hw_sigma(3) = 0.3;



settings.rules ={'angle','last','middle','postSagittal'};
% treeName = 'tree_bothSides_12datasets_cntr2_' ;
treeName = 'tree_cntr2_' ;

settings.numTrees = 500;
settings.side='Right';

%% Shape Model Settings


settings.nCompsShape = 2; %2 covers 95% variation
settings.nCompsRibCoef = 2;%2 covers 95% variation
settings.nCompsRibcage = 6;

% settings.nSamplesRibcage = 10;
settings.nStd = 2;

% settings.nCompsAngle = 5; % 5 covers  0.9717 variation
% settings.nSamplesShape = 3;%6;%6;
% settings.nSamplesLength = 5;%10;%20;
% settings.nSamplesAngle = 30;%10;%25;%[10 10 5 1 1];%[15 15 10 10 10];
% settings.nCompsLength = 2; %2 covers 99% variation

%% Cost Calculation Settings
newHeatMaps = true;

settings.sumMethod = 'Gaussian';%'average'
settings.costMethod ='prob';%'log';%

settings.tol = 5;
settings.tolX = 5;

settings.startP=10;
settings.startPEval=10;

settings.wFirst=1;
settings.wMiddle=1;
        

settings.anglePoint = 20;
settings.middlePoint = 21;
settings.maxMem = 10000; 

settings.fminIteration = 7;
settings.fminStep=1;
settings.wFirstPoint = [0 0 0];%[5 5 5];%
settings.outOfRangeCost = 0;
settings.step=1;

settings.sliceThickness = 10;


%% Name Settings

settings.ribModelName = 'ribModel';%'ribModel_rotatedEuler';%
settings.ribShapeModelName = 'new_ribShapeModel';
settings.ribcageModelName = 'new_MRIribcageModel';% 'new_ribcageModel';%'ribcageMRIModel_new';

% settings.ribShapeCoefModelsName = 'ribShapeCoefModels';
% settings.ribCageLengthModeName = 'ribCageLengthModel';
% settings.ribAngleModelCTName = 'ribAngleModelCT';
% settings.ribcageModelName = 'ribcageModel';
% settings.ribcageWOAngleModelName = 'ribcageWOAngleModel';
% settings.HypName ='Hypo';% 'ribCage_';%







