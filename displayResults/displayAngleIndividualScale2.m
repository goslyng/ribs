

function [ errs1,errs2, costs,ribError1,ribError2,lenError,outOfPlaneError]  = displayAngleIndividualScale(m,nBest,res,displayImages_,inh)

if ~exist('inh','var')
    inh=0;
end

runFittingSettings;

pathSettings;

ribsDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';
dataPathUnix = '/usr/biwinas03/scratch-c/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
    ribsDataPath = ribsDataPathUnix;
    rootPath = '/usr/biwinas03/scratch-c/sameig/';
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
scale=1;
% savePaths = [rootPath 'Ribs/ang' num2str(m)  ];
% savePaths = [rootPath 'Ribs/ang_scale' num2str(scale) '_' num2str(m)  ];
% resultPath1 = [rootPath 'Ribs/ang_scale' num2str(scale) '_sigma' num2str(settings.hw_sigma1) '_' num2str(m)];


   for i=1:3
    resultPath{i} = [rootPath 'Ribs/res_firstP_'  '_step' num2str(i) '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)];
end
% resultPath1 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step1_sigma'  num2str(10*settings.hw_sigma0,'%02d')  '_' num2str(m)];
% resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step2_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
% resultPath3 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step3_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
% resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_verteb2_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];


% 
% resultPath1 = [rootPath 'Ribs/ang_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
% % resultPath2 = [rootPath 'Ribs/ang_scale' num2str(scale) '_step2_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
% resultPath2 = [rootPath 'Ribs/ang_scale' num2str(scale) '_step3_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
% resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_verteb2_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

% resultPath2 = [rootPath 'Ribs/ang_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

if inh
    resultPath1 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m) ];
    resultPath2 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m) ];
end
  



addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);


displayImages = 1;
settings.nSamplesRibcage = 6;
if inh
    settings.nSamplesRibcage = 6;
end
settings.wFirstPoint = [0 0 0 ];

ribcageModelPath = [ribsDataPath 'new_' 'ribcageModel'];
ribShapeModelPath= [ribsDataPath 'new_' 'ribShapeModel'];
subjectDataPaths{m}=[ dataPath num2str(m) '/ribs/'];

if inh
    ribFittedPath = [subjectDataPaths{m} 'RibFittedInhRight'];
else
    ribFittedPath = [subjectDataPaths{m} 'RibFittedRight'];
end

%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;


%% Load Rib VTK Files

% for m=mriSubjects
    [ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,inh);
    [ptsExh, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,0);
% end

%% Find first points

% for m=mriSubjects

    [firstPts, pts] = findFirstPoints(rib_nos,ptsExh,settings,m);

% end
%% Load heatmaps

% loadAllHeatMaps;



%%

paramset = generateUniformSamples(allmodels.ribcageModel,settings);
% paramset=zeros(1,settings.nCompsRibcage);
[compParams ,angproj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
parameter_size =  size(angproj,1);%hyps.nHyps;

hyps = buildRibsFromParamsRibcage(allmodels,  compParams, angproj...
        , lenProjected,  1:parameter_size, firstPts, settings);

testRibs = 7:10;

if (m==59 || m==60 || m==550)
    testRibs=8:10;
end


% if res==1
    load(resultPath{res},'ang','cost','scale2','offset_indx')
%     scale2=2;

% elseif res==2
%     load(resultPath2,'ang','cost','scale2','offset_indx')
% elseif res==3
%         load(resultPath3,'ang','cost','scale2','offset_indx')


% end

settings.startP = 10 ; 
scale =1;


apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

% testPoints  = 1:scale2:settings.nPoints;
firstPts = firstPts/scale;

for i=testRibs
    ptsI{i}=ptsI{i}/scale;
    tmp = ptsI{i};
    ptsI{i} = tmp(:,:);
end

% settings.nPoints= floor((settings.nPoints -1)/scale2) +1;
% settings.anglePoint = floor((settings.anglePoint-1)/scale2)+1;
% settings.middlePoint = settings.anglePoint + 1;

settings.tol=settings.tol/scale;
settings.tolX=settings.tolX/scale;

[~,b]=sort(mean(cost(:,testRibs),2));

%%
for h = b(1:nBest)'
    
    offsets = reshape(offset_indx(h,:,:),3,[]);
if displayImages_
    figure; 
end
%     hold off;
    ptsAll=[];
outOfPlaneError=[];
    for r = testRibs
        
        hypotheses{r} = hyps{r}(:,:,h)/scale;
%         ang{h}(r,5) = ((ang{h}(r,5) -1) * scale2)+1;
        
        tmp = displayAngles(settings,hypotheses,ang{h}(r,:),firstPts,ptsI,r,ang{h}(r,5),offsets,displayImages_);
        newData_{h}{r} = tmp{r};
        [err_ribs1(h,r),~,tmp1,lenError(r),outOfPlaneErrorTMP]= computeErorr(newData_{h},ptsI,r,settings,settings.step,ang{h}(r,5),1);
        outOfPlaneError = [outOfPlaneError outOfPlaneErrorTMP];
        [err_ribs2(h,r),~,tmp2]= computeErorr(newData_{h},ptsI,r,settings,settings.step,ang{h}(r,5),2);
        ribError1_{h,r}=tmp1{r};
        ribError2_{h,r}=tmp2{r};
        plot33(ptsExh{r},'r.',[1 3 2])

        ribFileName = [ribFittedPath num2str(r)];
        pts_ = transCoord(newData_{h}{r},apMRI,isMRI,lrMRI);
%         writeVTKPolyDataPoints(ribFileName, pts_);
        ptsAll=[ptsAll pts_];

        %         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);
        ang{h}(r,:);
    end
    ribFileName = [ribFittedPath 'All'];

%     writeVTKPolyDataPoints(ribFileName, ptsAll);

    
    axis equal
 
end
    for r = testRibs

ribError1{r} = ribError1_{b(1),r};
ribError2{r} = ribError2_{b(1),r};
    end
errs1 = err_ribs1(b(1),testRibs)
errs2 = err_ribs2(b(1),testRibs)
% outOfPlaneError
costs = cost(b(1),testRibs)
lenError(testRibs)
% save(savePaths,'ang','newData_','err_ribs','cost')





