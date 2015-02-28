

function [ang_tmp, cost, err_ribs]  = setAngleIndividual(m)



runFittingSettings;

pathSettings;

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
codePathLS = [codePath 'mvonSiebenthal/leastSquaresFitting/'];
% codePathSkeleton =   [codePath 'skeleton/'];

savePaths = [rootPath 'Ribs/ang_Cost' num2str(m)  ];


addpath(codePath);
addpath(codePathLS);
addpath(genpath(codePathRibs));
% addpath(codePathSkeleton);


displayImages = 1;
settings.nSamplesRibcage = 5;
settings.wFirstPoint = [0 0 0 ];

ribcageModelPath = [ribsDataPath 'new_' 'ribcageModel'];
ribShapeModelPath= [ribsDataPath 'new_' 'ribShapeModel'];



%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;


%% Load Rib VTK Files

[ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);

%% Find first points


[firstPts, pts] = findFirstPoints(rib_nos,ptsI,settings,m);

%% Load heatmaps

loadAllHeatMaps;


%%

paramset = generateUniformSamples(allmodels.ribcageModel,settings);
% paramset=zeros(1,settings.nCompsRibcage);
[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
parameter_size =  size(ang_proj,1);

hyps = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts, settings);
parameter_size =  size(ang_proj,1);

testRibs = 7:10;

for j=1:parameter_size
        
     ang_rec(:,testRibs,j)=reshape(ang_proj(j,:),length(testRibs),[])';

end

%%


options{1} = -20:3:20;
options{2} = -25:3:10;
options{3} = -25:3:10;
options{4} = 1:0.5:1.2;

ang0=zeros(1,4);

for h=1:parameter_size
    
    for r= testRibs
        hypotheses{r} = hyps{r}(:,:,h);
    end
    
    [ang_tmp, cost(h,testRibs)] =  optimzeAngleScalePos(settings,testRibs,hypotheses,ang_rec(:,:,h),firstPts,ptsI,options,ang0,heatMaps,1);

    ang_{h}(testRibs,:) = ang_tmp;

%     figure(h); 
%     hold off;
    
    for r = testRibs

        tmp = displayAngles(settings,hypotheses,ang_{h}(r,:),firstPts,ptsI,r,ang_rec(:,:,h),false);
        newData_{h}{r} = tmp{r};
        err_ribs(h,r)= computeErorr(newData_{h},ptsI,r,settings);
        
%         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);
 
    end
%     axis equal
    cost(h,:)
end


save(savePaths,'ang_','newData_','err_ribs','cost')





