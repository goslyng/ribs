

function [ang_tmp, cost, err_ribs]  = setAngelComputeErrorScale2(m)


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

scale2=1;


codePathRibs=[codePath 'ribFitting/'];
codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathSkeleton =   [codePath 'skeleton/'];

scaleLoad=5;
loadPaths = [rootPath 'Ribs/ang_scale' num2str(scaleLoad) '_' num2str(m)  ];

scale=1;
savePaths = [rootPath 'Ribs/ang_scale' num2str(scale) '_' num2str(m)  ];


addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);


displayImages = 1;
settings.nSamplesRibcage = 6;
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

% 



% options{1} = -10:5:10;
% options{2} = -10:5:10;
% options{3} = -10:5:10;
% options{4} = 0.8:0.1:1.1;
% options{5} =  -2:2;


% 
% options{1} = -10:10;
% options{2} = -25:10;
% options{3} = -25:10;
% options{4} = 0.1:1.2;


k=0;
for bit1 =[-1 0 1 ]
    for bit2 =[-1 0 1 ]
        for bit3 =[-1 0 1 ]
            k=k+1;
            offsets(:,k)=[bit1 ;bit2 ;bit3];
        end
    end
end

scale=1;

offsets=[0;0;0];

settings.startP = 10 ; 
settings.startPEval = 10;
testPoints = 1:scale2:settings.nPoints;
% ang0=zeros(1,5);
% ang0(5) = floor((settings.startP-1)/scale2)+1;
firstPts = firstPts/scale;
for i=testRibs
    ptsI{i}=ptsI{i}/scale;
    tmp = ptsI{i};
    ptsI{i} = tmp(:,testPoints);
end
% 
% settings.nPoints= floor((settings.nPoints -1)/scale2) +1;
% settings.anglePoint = floor((settings.anglePoint-1)/scale2)+1;
% settings.middlePoint = settings.anglePoint + 1;
% 
% settings.tol=settings.tol/scale;
% settings.tolX=settings.tolX/scale;
% 
% settings.startPEval = floor((settings.startPEval  -1.5 )/scale2+1.5);

ptsRibcage=[];
for r= testRibs
    ptsRibcage = [ptsRibcage ptsI{r}];
end


z_dif =  max([ptsRibcage(3,:) firstPts(3,testRibs)])-min([ptsRibcage(3,:) firstPts(3,testRibs)]);
x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));
offsets_inital = zeros(3,testRibs(end));
if( m==60 || m== 59)
    testRibs=8:10
end

load(loadPaths,'ang_','cost');%,'newData_','err_ribs'
[~,b]=sort(mean(cost(:,7:10),2));
scale2=2;

nBest=3;

options{1} = -10:10;
options{2} = -10:10;
options{3} = -10:10;
options{4} = 0;
options{5} =  -2:2;

clear cost;

%%
for h=b(1:nBest)'
    
	ang_{h}(testRibs,5) = ((ang_{h}(testRibs,5) - 1 ) *  scale2 )+1 ;

    for r= testRibs
        
        hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
      [ang_tmp(r,:), cost(h,r), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,r,hypotheses,offsets_inital,x_dif,z_dif,ang_rec(:,:,h),firstPts,ptsI,options,ang_{h}(r,:),heatMaps,offsets,1);
    end
    ang{h}(testRibs,:) = ang_tmp(testRibs,:);
    figure(h); 
    hold off;
%     err_ribs(h)= computeErorr(newData_{h},ptsI,testRibs,settings);

    for r = testRibs

        tmp = displayAngles(settings,hypotheses,ang{h}(r,:),firstPts,ptsI,r,ang_rec(:,:,h),ang{h}(r,5 ),true);
        newData_{h}{r} = tmp{r};
        err_ribs(h,r)= computeErorr(newData_{h},ptsI,r,settings, settings.step,ang{h}(r,5 ));
        
%         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);
 
    end
    axis equal
    cost(h,:)
end


save(savePaths,'ang','newData_','err_ribs','cost','offset_indx')





