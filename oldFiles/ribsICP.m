
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

% savePaths{m} = [rootPath 'Ribs/' settings.HypName num2str(m) ];


addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);


displayImages = 1;
runFittingSettings;
settings.nSamplesRibcage = 5;
settings.wFirstPoint = [0 0 0 ];

ribShapeCoefModelsPath = [ribsDataPath 'new_' 'ribShapeCoefModels'];
ribCageLengthModelPath = [ribsDataPath 'new_' 'ribCageLengthModel'];
ribAngleModelCTPath = [ribsDataPath 'new_' 'ribAngleModelCT'];
ribcageModelPath = [ribsDataPath 'new_' 'ribcageModel'];
ribcageWOAngleModelPath = [ribsDataPath 'new_'    'ribcageWOAngleModel'];
ribShapeModelPath= [ribsDataPath 'new_' 'ribShapeModel'];
% save(ribShapeCoefModelsPath,  'ribShapeCoefModels');
% save(ribCageLengthModelPath,  'ribCageLengthModel');
% save(ribAngleModelCTPath, 'ribAngleModelCT');
% save(ribcageModelPath,  'ribcageModel');
% save(ribcageWOAngleModelPath,  'ribcageWOAngleModel');


%% Model paths

% ribModelPath = [ribsDataPath  settings.ribModelName];
% 
% % ribcageWOAngleModelPath =  [ribsDataPath settings.ribcageWOAngleModelName];
% 
% ribShapeModelPath = [ribsDataPath settings.ribShapeModelName];
% ribShapeCoefModelsPath =[ribsDataPath settings.ribShapeCoefModelsName];
% ribCageLengthModelPath = [ribsDataPath settings.ribCageLengthModeName];
% ribAngleModelCTPath = [ribsDataPath settings.ribAngleModelCTName];
% ribcageModelPath = [ribsDataPath settings.ribcageModelName];
ribcageMRIModelPath = [ ribsDataPath 'new_MRIribcageModel' ];

%% Load Rib Model

% load(ribModelPath,'ribModel')

% ribModelTest = ribModel;
% 
% load(ribShapeCoefModelsPath ,'ribShapeCoefModels');
% load(ribCageLengthModelPath ,'ribCageLengthModel');
% load(ribAngleModelCTPath ,'ribAngleModelCT');
% load(ribcageWOAngleModelPath,  'ribcageWOAngleModel');


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
% load(mriSubjectsPath, 'mriSubject');
% ribcageModel = ribcageCTModel;
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
paramset = generateUniformSamples(allmodels.ribcageModel,settings);

[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
parameter_size =  size(ang_proj,1);%hyps.nHyps;

hypotheses = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts{m}, settings);
% 
% [result.candidate_cost,  validParamset] = paramToCostConv(allmodels,paramset,heatMaps,firstPts...
%     , settings , z_dif, x_dif);

% hyps = generateHypothesesRibcage(allmodels,settings);
parameter_size =  size(ang_proj,1);%hyps.nHyps;


% lenProjected = hyps.lenProjected;
% compParams = hyps.compParams;


ribShapeParams = zeros(length(settings.ribNumber),parameter_size,length(compParams));

for c = 1 :length(compParams)
    
	ribShapeParams(:,:,c)  = compParams{c}';
  
end

%% Save the hypotheses
    
% ribOffsetModel = ribcageModel.ribs(1)-1;
% hypotheses=cell(length(settings.ribNumber),1);
% 
% for r = settings.ribNumber  
%     hypotheses{r} = zeros(3,nPoints,parameter_size);
%     for  k=1:parameter_size %paramshapeSample=1:nSamplesShape
%             
%             Pp = pcaProject(ribShapeModel,squeeze(ribShapeParams(r-ribOffsetModel,k,:))',length(compParams));
%             Pp = Pp*lenProjected(k,r-ribOffsetModel)/meanLen;
%             P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';
%               
%             hypotheses{r}(:,:,k) = P  + repmat(firstPts{m}(:,r) - P(:,settings.startP) ,1,nPoints);
%             
%      end   
%      
% end

%%

for m=mriSubjects
m
    for  k=1:parameter_size %paramshapeSample=1:nSamplesShape
         if mod(k,100)==0
             fprintf(1,' %d / %d ', k,parameter_size);
         end
% k
        for r = settings.ribNumber
            
            [rot, t ]=icp(ptsI{m}{r}(:,1:10:end),hypotheses{r}(:,11:9:end,k)); 
            newData{r} = rot*hypotheses{r}(:,:,k) + repmat(t,1,100);
            
        end
        err(k)= computeErorr(newData,ptsI{m});
%         figure(100);
%         hold off;
%         plot33(pts{m},'b.',[1 3 2]);
%         hold on;
%                 for r = settings.ribNumber
% 
%         plot33(newData{r},'r.',[1 3 2])
%                 end
%                 axis equal
%                 input('hi');
    end
    
    fprintf(1,'\n');    
    [~,k]=min(err);
    bestParams(m)=k;
    
    for r = settings.ribNumber

            [rot, t ]=icp(ptsI{m}{r},hypotheses{r}(:,:,k));
            rib_(:,:,r) = rot*hypotheses{r}(:,:,k) + repmat(t,1,100);
            [ ang_(m,r,1), ang_(m,r,2),  ang_(m,r,3)]=findEuler(rot ,2);
    end

    figure;plot33(pts{m},'b.',[1 3 2]);
    hold on;
    plot33(rib_,'r.',[1 3 2])
    axis equal;

end
%%


ribcageMRI= [compParams{1}(bestParams(mriSubjects),:),...
             compParams{2}(bestParams(mriSubjects),:),...
             lenProjected(bestParams(mriSubjects), :),...
             squeeze(rad2deg(ang_(mriSubjects, settings.ribNumber,1))) ,...
             squeeze(rad2deg(ang_(mriSubjects, settings.ribNumber,2))) ,... 
             squeeze(rad2deg(ang_(mriSubjects, settings.ribNumber,3))) ];
         
% coefs = 100./mean(abs(ribcageMRI));  
meanRibCage =repmat(mean(ribcageMRI),size(ribcageMRI,1),1);
ribcageMRI = ribcageMRI - meanRibCage ; 
coefs = 100./ mean(abs(ribcageMRI));

ribcageMRI = ribcageMRI.*repmat(coefs,size(ribcageMRI,1),1);
ribcageMRI = ribcageMRI+meanRibCage;

ribcageMRIModel = pcaModeling (ribcageMRI);
ribcageMRIModel.coefs  = coefs;
ribcageMRIModel.ribs = settings.ribNumber;
ribcageMRIModel.meanLen = meanLen;

%%
ribcageModel = ribcageMRIModel;
save(ribcageMRIModelPath,  'ribcageModel');


%%

if displayImages
    
    figure;
%     n=(ribNumbersAngle(1)+1)/2;
% n=7;
%     nn=(ribNumbersAngle(end)+1)/2; ang_(mriSubjects,settings.ribNumber,:)

    subplot(1,3,1);plot(repmat(settings.ribNumber',1,numel(mriSubjects)),squeeze(rad2deg(ang_(mriSubjects,settings.ribNumber,1)))')
    subplot(1,3,2);plot(repmat(settings.ribNumber',1,numel(mriSubjects)),squeeze(rad2deg(ang_(mriSubjects,settings.ribNumber,2)))')
    subplot(1,3,3);plot(repmat(settings.ribNumber',1,numel(mriSubjects)),squeeze(rad2deg(ang_(mriSubjects,settings.ribNumber,3)))')
%     subplot(2,3,4);plot(repmat([n:nn]',1,20),(squeeze(ang(1,ctSubjectsVert,n:end) - repmat(mean(ang(3,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
%     subplot(2,3,5);plot(repmat([n:nn]',1,20),(squeeze(ang(2,ctSubjectsVert,n:end) - repmat(mean(ang(2,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)
%     subplot(2,3,6);plot(repmat([n:nn]',1,20),(squeeze(ang(3,ctSubjectsVert,n:end) - repmat(mean(ang(1,ctSubjectsVert,n:end),3),[1 1 numel(ribNumbersAngle)])))'*180/pi)


% 
%     for m=mriSubjects
% 
%         figure;plot33(pts{m},'b.',[1 3 2]);
% 
%         k = bestParams(m);
%         for r = settings.ribNumber
% 
%     %             [rot{r}, t ]=icp(ptsI{m}{r},hypotheses{r}(:,:,k));
%                 [ rot{r}]=findEuler( ang_(m,r,1), ang_(m,r,2),  ang_(m,r,3),2);
% 
%                 rib_(:,:,r) = rot{r}*hypotheses{r}(:,:,k) + repmat(t,1,100);
%         end
% 
%         hold on;
%         plot33(rib_,'r.',[1 3 2])
% 
% end

end























