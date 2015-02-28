

function [cost,  paramset, offsetVec] = paramToCostConv( allmodels, paramset, heatMaps, firstPts...
    , settings, z_dif, x_dif)


[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);


startP=settings.startP;
NRibs = settings.ribNumber(end);    

nHyps = size(paramset,1);

if settings.verbose
    fprintf(1,' \nTotal hypotheses: %d ',nHyps);
end

%% Compute valid hypotheses 

if settings.verbose
    fprintf(1,'Computing valid Hyposthes ..\n');
end

valid_params = false(nHyps,1);
nIter = ceil(nHyps/settings.maxMem);

for j = 1:nIter
    
    if settings.verbose    
        fprintf(1,' %d ',j);
    end
    
    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,nHyps);
    
    hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  ids, firstPts, settings);
   
    for d = ids  

        p = zeros(3, settings.nPoints - startP +1 , NRibs);
        i = d - (j-1)*settings.maxMem;
        
        for r = settings.ribNumber

            p(:,:,r) = hyp{r}(:,settings.startP:settings.nPoints,i) ;
                        
        end
            
        z_p = reshape(p(3,:,settings.ribNumber),[],1);
        y_p = reshape(p(2,:,settings.ribNumber),[],1);
        x_p = reshape(p(1,:,settings.ribNumber),[],1);

        if ( abs(max(z_p) - min(z_p) - z_dif) <settings.tol && abs(abs(max(x_p) - min(x_p)) - x_dif) <settings.tolX ...
                && max(y_p)< size(heatMaps{1},1) && min(y_p)>0 )

            valid_params(d)=true;
            
        end
   
    end
end


nHyps = sum(valid_params);

if settings.verbose
    fprintf(1,' \n');
    fprintf(1,'Valid hypotheses: %d \n',nHyps);
end

for c=1:length(compParams)
    compParams{c} =  compParams{c}(valid_params,:);
end

paramset = paramset(valid_params,:);
ang_proj= ang_proj(valid_params,:);
lenProjected= lenProjected(valid_params,:);

%% Compute Costs

% offset{1} = -settings.wFirstPoint(1) : settings.wFirstPoint(1);
% offset{2} = -settings.wFirstPoint(2) : settings.wFirstPoint(2);
% offset{3} = -settings.wFirstPoint(3) : settings.wFirstPoint(3);

% offsetVec = generatePermutations(offset);

nIter = ceil(nHyps/settings.maxMem);

if settings.verbose
    fprintf(1,'Computing  costs...\n');
end
% candidate_cost = zeros(nHyps,1,NRibs);
candidate_cost = zeros(nHyps,NRibs);

offsetVec = zeros(nHyps,NRibs,3);
for j = 1:nIter
    
    if settings.verbose    
        fprintf(1,' %d ',j);
    end
    
    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,nHyps); 
    hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  ids, firstPts, settings);
   
    for d = ids  
        if settings.verbose   
            
            if mod(d,100)==0
                fprintf(1,' %d ',d);
            end
            
        end
%         p = zeros(3, settings.nPoints - startP +1 , NRibs);
        i = d - (j-1)*settings.maxMem;
        
%         appearanceCost  = zeros(settings.nPoints,1);
        fminStep = settings.fminStep;

        for r = settings.ribNumber
            

%             [n_, cost] = fminbnd(@(offsetVecs) offsetCost(n,hyp{r}(:,settings.startP:settings.nPoints,i),offsetVecs,heatMaps,settings),0,13.31,options);
    
%             [n_, cost] = fminsearch(@(n) offsetCost(n,hyp{r}(:,settings.startP:settings.nPoints,i),offsetVec,heatMaps,settings),ceil(size(offsetVec,1)/2),options);
%             [n_, ribCost] = fminsearch(@(offsetVecs) offsetCost(1,hyp{r}(:,settings.startP:settings.nPoints,i),offsetVecs,heatMaps,settings),[0 0 0]);


%             [n_, ribCost] = fminsearchbnd(@(offsetVecs) offsetCost(1,hyp{r}(:,settings.startP:settings.nPoints,i),offsetVecs,heatMaps,settings,fminStep)...
%                 ,[0 0 0],-settings.wFirstPoint/fminStep,settings.wFirstPoint/fminStep);
            [n_, ribCost] = fminsearchbnd(@(offsetVecs) offsetCost(hyp{r}(:,:,i),offsetVecs,heatMaps,settings,fminStep)...
                ,[0 0 0],-settings.wFirstPoint/fminStep,settings.wFirstPoint/fminStep);
            offsetVec(d,r,:)= round(n_*fminStep);
%             n = find(sum(offsetVec==repmat(n_,size(offsetVec,1),1),2)==3);
%             candidate_cost(d,1,r) =  ribCost;
                        candidate_cost(d,r) =  ribCost;

%             for n=1:size(offsetVec,1)
%                 ribCost =  offsetCost(n, hyp{r}(:,settings.startP:settings.nPoints,i),offsetVec(n,:),heatMaps,settings);
% %                 clear p;
% %                 p(1,:) = hyp{r}(1,settings.startP:settings.nPoints,i) + offsetVec(n,1);
% %                 p(2,:) = hyp{r}(2,settings.startP:settings.nPoints,i) + offsetVec(n,2);
% %                 p(3,:) = hyp{r}(3,settings.startP:settings.nPoints,i) + offsetVec(n,3);
% % 
% %                 for rul=1:length(settings.rules)
% % 
% %                     selectedPoints = selectPointsR(p,settings.rules{rul},settings);
% %                     p_selected = p(:,selectedPoints);
% %                     appearanceCost(selectedPoints) =  ...
% %                         computeCostVoxelNoIm(transCoord(p_selected,ap,is,lr),heatMaps{rul},settings);
% %                 end
% % 
% %                 weightVector = ones(1, settings.nPoints);
% %                 weightVector = weightVector/sum(weightVector);
% % 
% %                 ribCost =  weightVector*appearanceCost;
%                 candidate_cost(d,n,r) =  ribCost;
%                 
%             end
        end
          
    end
end
prior = reshape(-log(1/(sqrt(2*pi))^6 * exp(-1/2*(dot(paramset',paramset')))),[],1);

% cost = sum(-log(-candidate_cost(:,settings.ribNumber)),2);%+ prior;
cost = sum((candidate_cost(:,settings.ribNumber)),2);%+ prior;


