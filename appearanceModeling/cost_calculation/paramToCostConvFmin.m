

function [cost,  paramset] = paramToCostConvFmin( allmodels, paramset, heatMaps, firstPts...
    , settings )


[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset(:,1:settings.nCompsRibcage), settings);


% nPoints = settings.nPoints;
ribNumber = settings.ribNumber;

% startP=settings.startP;
NRibs = ribNumber(end);    
% 
% ap = settings.ap;
% is = settings.is;
% lr = settings.lr;
% 
% verbose = settings.verbose;

offsets = paramset(settings.nCompsRibcage+1:end);

%% Compute Costs

offsetVec(:,settings.ribNumber) = reshape(offsets,3,length(settings.ribNumber));

candidate_cost = zeros(1,NRibs);


    
hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1, firstPts, settings);
    
        
% appearanceCost  = zeros(nPoints,1);

            
for r = ribNumber

   candidate_cost(r) =  offsetCost(hyp{r},offsetVec(:,r),heatMaps,settings);
%         clear p;
% %         p(1,:) = hyp{r}(1,settings.startP:nPoints) + offsetVec(1,r);
% %         p(2,:) = hyp{r}(2,settings.startP:nPoints) + offsetVec(2,r);
% %         p(3,:) = hyp{r}(3,settings.startP:nPoints) + offsetVec(3,r);
% 
%         p(1,:) = hyp{r}(1,:) + offsetVec(1,r);
%         p(2,:) = hyp{r}(2,:) + offsetVec(2,r);
%         p(3,:) = hyp{r}(3,:) + offsetVec(3,r);
% 
%         for rul=1:length(settings.rules)
% 
%             selectedPoints = selectPointsR(p,settings.rules{rul},settings);
%             p_selected = p(:,selectedPoints);
%             appearanceCost(selectedPoints) =  ...
%                 computeCostVoxelNoIm(transCoord(p_selected,ap,is,lr),heatMaps{rul},settings);
%         end
% 
%         weightVector = ones(1, nPoints);
%         weightVector = weightVector/sum(weightVector);
% 
%         ribCost =  weightVector*appearanceCost;
%         candidate_cost(r) =  ribCost;

    
end
prior = reshape(-log(1/(sqrt(2*pi))^6 * exp(-1/2*(dot(paramset',paramset')))),[],1);

% cost = sum(-log(-candidate_cost(:,settings.ribNumber)),2);%+ prior;          
cost = sum((candidate_cost(:,settings.ribNumber)),2);%+ prior;          

% cost = candidate_cost;




