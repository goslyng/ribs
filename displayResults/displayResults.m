function [p_best, res ,errors]= displayResults(m,nHyps,nBest,fgNum)


if ~exist('fgNum','var')
    fgNum=100;
end

if ~exist('nBest','var')
    nBest=length(b);
end


runFittingSettings;
pathSettings;

%%

load([resultsPaths  num2str(nHyps)],'result');

settings = result.settings;
if ~isfield(result.settings ,'ribModelName');
    result.settings.ribModelName='ribModel_rotatedEuler';
end

ribcageModelPath = [ribsDataPath  result.settings.ribcageModelName];
ribShapeModelPath = [ribsDataPath  result.settings.ribShapeModelName];
%% Load Rib Model

load(ribcageModelPath,'ribcageModel');
load(mriAnglePath,'MRangleModel')
load(ribShapeModelPath,'ribShapeModel');


allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;

%% Load Rib VTK Files

[ptsRibs, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);

%% Find first points


% [firstPts, ptsRibcage] = findFirstPoints(ptsRibs,m,vertebraPredictionMatrixPath,rootPath,settings);
[firstPts, ptsRibcage] = findFirstPoints(settings.ribNumber,ptsRibs,settings,m);

    
% end
%% Display the best cases

[~, b]=sort(result.candidate_cost);


nFirstPts = size(firstPts,3);
d_vector_params = floor((b(1:nBest)-1)/nFirstPts)+1;
perturb = b(1:nBest) - ( (d_vector_params-1)*nFirstPts )   ;
paramset = result.paramset(d_vector_params,1:settings.nCompsRibcage);

hypotheses = generateHypothesesRibcageDisplay(allmodels,settings,paramset,firstPts,perturb);

hyp = hypotheses.transformation;

for r = settings.ribNumber
    
    p_best{r} = hyp{r}(:,settings.startP:settings.nPoints,1) ;
    
end       

offsets = result.paramset(:,settings.nCompsRibcage+1:end);

       

        
for d=1:nBest
        
    if fgNum~=0

        figure(fgNum);
        hold off;
        plot333(ptsRibcage,'b.',[1 3 2]);
        hold on;  
    end
    
    offsetVec(:,settings.ribNumber) = reshape(offsets(d,:),3,length(settings.ribNumber));

    for r = settings.ribNumber

%         p{r}(1,:) = hyp{r}(1,settings.startP:numKnots,d)  + offsetVec(1,r);
%         p{r}(2,:) = hyp{r}(2,settings.startP:numKnots,d)  + offsetVec(2,r);
%         p{r}(3,:) = hyp{r}(3,settings.startP:numKnots,d)  + offsetVec(3,r);
        p{r}(1,:) = hyp{r}(1,:,d)  + offsetVec(1,r);
        p{r}(2,:) = hyp{r}(2,:,d)  + offsetVec(2,r);
        p{r}(3,:) = hyp{r}(3,:,d)  + offsetVec(3,r);

        if fgNum~=0
            plot333(p{r},'r.',[1 3 2]);
        end
    end
    
    if isfield(result,'resultsTrue')
%  num2str(sum(resultsTrue.candidate_cost(settings.ribNumber))/length(settings.ribNumber))]);
        ground_truth = sum(result.resultsTrue.candidate_cost(settings.ribNumber))/length(settings.ribNumber);
%         ground_truth=sum(-log(-result.resultsTrue.candidate_cost(:,settings.ribNumber)),2);
    else
        ground_truth=0;
    end

    [cost, ~,errors]=computeErorr(p,ptsRibs,settings.ribNumber);
    
    if fgNum~=0
        
        axis equal;
%         input([num2str(cost) ' ' num2str(result.candidate_cost(b(d))/length(settings.ribNumber)) ' ' ...
%             num2str(ground_truth)]);
        input([num2str(cost) ' ' num2str(result.candidate_cost(b(d))/length(settings.ribNumber)) ' ' ...
            num2str(ground_truth)]);
    end

    
    res{d} = [cost  result.candidate_cost(b(d)) ground_truth];  

end
%%
% figure;plot33(ptsRibcage(:,1:120),'b.',[1 3 2])
% hold on;
% plot33(p{7},'r.',[1 3 2])
% axis equal
% 

