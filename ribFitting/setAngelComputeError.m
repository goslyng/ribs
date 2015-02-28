

function [ang_tmp, cost, err_ribs]  = setAngelComputeError(m)


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
codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathSkeleton =   [codePath 'skeleton/'];

savePaths = [rootPath 'Ribs/ang_' num2str(m)  ];


addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);


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

% for m=mriSubjects
    [ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);
% end

%% Find first points

% for m=mriSubjects

    [firstPts, pts] = findFirstPoints(rib_nos,ptsI,settings,m);

% end
%% Load heatmaps
scale=1;
loadAllHeatMaps;



%%

paramset = generateUniformSamples(allmodels.ribcageModel,settings);
% paramset=zeros(1,settings.nCompsRibcage);
[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
parameter_size =  size(ang_proj,1);%hyps.nHyps;

hyps = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts, settings);

parameter_size =  size(ang_proj,1);%hyps.nHyps;


testRibs = 7:10;



% close all

for j=1:parameter_size

%     for k=1:length(testRibs)
        
     ang_rec(:,testRibs,j)=reshape(ang_proj(j,:),length(testRibs),[])';
%      ang_rec(1,j,testRibs(k))=ang_proj(d,id_rib(k));
%      ang_rec(2,j,testRibs(k))=ang_proj(d,id_rib(k)+4);
%      ang_rec(3,j,testRibs(k))=ang_proj(d,id_rib(k)+8);
     
%     end
end
%%


%%


options{1} = -20:5:20;
options{2} = -25:5:10;
options{3} = -25:5:10;
options{4} = 0.8:0.05:1.1;
options{5} =  -5:2;
% 
% options{1} = -10:10;
% options{2} = -25:10;
% options{3} = -25:10;
% options{4} = 0.1:1.2;



settings.startP = 10 ; 


% err_ribs = 9999*ones(mriSubjects(end),testRibs(end));
% for m=mriSubjects
%     m

ang0=zeros(1,5);
ang0(5) = settings.startP;

for h=1:parameter_size
    
    for r= testRibs
        hypotheses{r} = hyps{r}(:,:,h);
    end
    
    
    [ang_tmp, cost(h,testRibs)] =  optimzeAngleScalePos(settings,testRibs,hypotheses,ang_rec(:,:,h),firstPts,ptsI,options,ang0,heatMaps,2);

    ang_{h}(testRibs,:) = ang_tmp;

    figure(h); 
    hold off;
%     err_ribs(h)= computeErorr(newData_{h},ptsI,testRibs,settings);

    for r = testRibs

        tmp = displayAngles(settings,hypotheses,ang_{h}(r,:),firstPts,ptsI,r,ang_rec(:,:,h),ang_{h}(r,5 ),true);
        newData_{h}{r} = tmp{r};
        err_ribs(h,r)= computeErorr(newData_{h},ptsI,r,settings, settings.step,ang_{h}(r,5 ));
        
%         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);
 
    end
    axis equal
    cost(h,:)
end


save(savePaths,'ang_','newData_','err_ribs','cost')





