
% runFittingSettings;

% pathSettings;

displayImages = 1;
settings.wFirstPoint = [0 0 0];


%% Load Rib Model


load(paths.ribcageModelPath,'ribcageModel');
load(paths.ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;


%% Load Rib VTK Files

% for m=mriSubjects
    [ptsI, rib_nos]=loadRibVTKFiles(paths.dataPath,m,settings.ap,settings.is,settings.lr);
% end

%% Find first points

% for m=mriSubjects

    [firstPts, pts] = findFirstPoints(rib_nos,ptsI,settings,m);

% end

%%

paramset = generateUniformSamples(allmodels.ribcageModel,settings);
% paramset=zeros(1,settings.nCompsRibcage);
[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
parameter_size =  size(ang_proj,1);
hyps = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts, settings);

    
numVerteb(50)=9;
numVerteb(60)=10;
numVerteb(61)=10;
numVerteb(63)=10;
numVerteb(64)=10;
numVerteb(65)=10;    %start from second one
numVerteb(66)=10;      

numVerteb(51)=10;  
numVerteb(53)=10;
numVerteb(54)=10;      
numVerteb(550)=10;      
numVerteb(56)=10;      
numVerteb(57)=10;      
numVerteb(59)=10;      
for subj = settings.mriSubjects
offVert(subj)=0;
end


offVert(65)=1;