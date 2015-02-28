

function [ang_tmp, cost]  = setAngelComputeErrorScale(m)


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

scale2=2;
scale=5;

codePathRibs=[codePath 'ribFitting/'];
codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];
codePathSkeleton =   [codePath 'skeleton/'];

savePaths = [rootPath 'Ribs/ang_scale' num2str(scale) '_' num2str(m)  ];


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

loadAllHeatMaps;


%%

paramset = generateUniformSamples(allmodels.ribcageModel,settings);
% paramset=zeros(1,settings.nCompsRibcage);
[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
parameter_size =  size(ang_proj,1);
hyps = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts, settings);



testRibs = 7:10;
if( m==60 || m== 59)
    testRibs=8:10;
end


for j=1:parameter_size
       
     ang_rec(:,testRibs,j)=reshape(ang_proj(j,:),length(testRibs),[])';

end

%%

% 
options{1} = -20:5:20;
options{2} = -25:5:10;
options{3} = -25:5:10;
options{4} =  0.8:0.1:1.2;
options{5} =  -7:4;


ang0=zeros(1,5);
ang0(5) = settings.startP;

makeScaleChanges;


% for i=testRibs
%     ptsI{i}=ptsI{i}/scale;
%     tmp = ptsI{i};
%     ptsI{i} = tmp(:,testPoints);
% end

% ptsRibcage=[];
% for r= testRibs
%     ptsRibcage = [ptsRibcage ptsI{r}];
% end

% z_dif =  max([ptsRibcage(3,:) firstPts(3,testRibs)])-min([ptsRibcage(3,:) firstPts(3,testRibs)]);
% x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));

offsets_inital = zeros(3,testRibs(end));

k=0;
for bit1 =[-1 0 1 ]
    for bit2 =[-1 0 1 ]
        for bit3 =[-1 0 1 ]
            k=k+1;
            offsets(:,k)=[bit1 ;bit2 ;bit3];
        end
    end
end

offsets=[0;0;0];

%%
z_dif=[];
x_dif=[];
for h=1:parameter_size
    
    for r= testRibs
        hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
    end
    
    [ang_tmp, cost(h,testRibs), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,testRibs,hypotheses,offsets_inital,x_dif,z_dif,ang_rec(:,:,h),firstPts,ptsI,options,ang0,heatMaps,offsets,1);

    ang{h}(testRibs,:) = ang_tmp;

%     figure(h); 
%     hold off;
% %     err_ribs(h)= computeErorr(newData_{h},ptsI,testRibs,settings);
% 
%     for r = testRibs
% 
%         tmp = displayAngles(settings,hypotheses,ang{h}(r,:),firstPts,ptsI,r,ang_rec(:,:,h),ang{h}(r,5 ),true);
%         newData_{h}{r} = tmp{r};
%         err_ribs(h,r)= computeErorr(newData_{h},ptsI,r,settings, settings.step,ang{h}(r,5 ));
%         
% %         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);
%  
%     end
%     axis equal
%     cost(h,:)
end


save(savePaths,'ang','newData','cost','offset_indx')





