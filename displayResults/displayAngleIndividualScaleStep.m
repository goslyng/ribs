

function [ errs1,errs2, costs,ribError1,ribError2,lenError,outOfPlaneError]  = displayAngleIndividualScaleStep(m,nBest,resultPath,displayImages_,inh)

if ~exist('inh','var')
    inh=0;
end

settings=exportSettings();
settings.inh=inh;

paths = pathSettings(settings);

scale=1;

settings.nSamplesRibcage = 6;
if inh
    settings.nSamplesRibcage = 6;
end
settings.wFirstPoint = [0 0 0 ];

ribcageModelPath = [paths.ribsDataPath 'new_' 'ribcageModel'];
ribShapeModelPath= [paths.ribsDataPath 'new_' 'ribShapeModel'];
subjectDataPaths{m}=[ paths.dataPath num2str(m) '/ribs/'];

if inh
    ribFittedPath = [subjectDataPaths{m} 'RibFittedInhRight'];
else
    ribFittedPath = [subjectDataPaths{m} 'RibFittedRight'];
end

%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel = ribcageModel;
allmodels.ribShapeModel = ribShapeModel;


%% Load Rib VTK Files

% for m=mriSubjects
    [ptsI, ~]=loadRibVTKFiles(paths.dataPath,m,settings.ap,settings.is,settings.lr,inh);
    [ptsExh, rib_nos]=loadRibVTKFiles(paths.dataPath,m,settings.ap,settings.is,settings.lr,0);
% end

%% Find first points

% for m=mriSubjects

    [firstPts, ~] = findFirstPoints(rib_nos,ptsExh,settings,m);

% end


%%

testRibs = 7:10;

if (m==59 || m==60 || m==550)
    testRibs=8:10;
end


load(resultPath,'ang','cost','scale2','offset_indx');

paramset=zeros(1,1);
settings.nSamplesRibcage=1;

while size(paramset,1)<size(cost,1)
    
    settings.nSamplesRibcage = settings.nSamplesRibcage+1;
    paramset = generateUniformSamples(allmodels.ribcageModel,settings);
    % paramset=zeros(1,settings.nCompsRibcage);
end


[compParams ,angproj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
parameter_size =  size(angproj,1);%hyps.nHyps;

hyps = buildRibsFromParamsRibcage(allmodels,  compParams, angproj...
        , lenProjected,  1:parameter_size, firstPts, settings);



settings.startP = 10 ; 
scale =1;


apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

firstPts = firstPts/scale;

for i=testRibs
    ptsI{i}=ptsI{i}/scale;
    tmp = ptsI{i};
    ptsI{i} = tmp(:,:);
end

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
        tmp = displayAngles(settings,hypotheses,ang{h}(r,:),firstPts,ptsI,r,ang{h}(r,5),offsets,displayImages_);
%         tmp = displayAngles(settings,hypotheses,ang{h}(r,:),firstPts,ptsI,r,1,offsets,displayImages_);

        newData_{h}{r} = tmp{r};
        [err_ribs1(h,r),~,tmp1,lenError(r),outOfPlaneErrorTMP]= computeErorr(newData_{h},ptsI,r,settings,settings.step,ang{h}(r,5),1);
        outOfPlaneError = [outOfPlaneError outOfPlaneErrorTMP];
        [err_ribs2(h,r),~,tmp2]= computeErorr(newData_{h},ptsI,r,settings,settings.step,ang{h}(r,5),2);
        ribError1_{h,r}=tmp1;
        ribError2_{h,r}=tmp2;
        plot33(ptsExh{r},'r.',[1 3 2])

        ribFileName = [ribFittedPath num2str(r)];
        pts_ = transCoord(newData_{h}{r},apMRI,isMRI,lrMRI);
        writeVTKPolyDataPoints(ribFileName, pts_);
        ptsAll=[ptsAll pts_];

        %         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);
%         ang{h}(r,:);
    end
    
    ribFileName = [ribFittedPath 'All'];
    writeVTKPolyDataPoints(ribFileName, ptsAll);
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





