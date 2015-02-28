

function [cost,  paramset] = paramToCost( allmodels, paramset, heatMaps, firstPts...
    , settings, z_dif, x_dif)


[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels, paramset, settings);


nPoints = settings.nPoints;
ribNumber = settings.ribNumber;
patch_size = settings.patch_size;
startP=settings.startP;
NRibs = ribNumber(end);    

ap = settings.ap;
is = settings.is;
lr = settings.lr;

nHyps = size(paramset,1);
verbose = settings.verbose;

%% Compute valid hypotheses 
if verbose
fprintf(1,'Computing valid Hyposthes ..\n');
end
valid_params = false(nHyps,1);
nIter = ceil(nHyps/settings.maxMem);

if verbose
fprintf(1,' \nTotal hypotheses: %d ',nHyps);
end



for j = 1:nIter
if verbose    
    fprintf(1,' %d ',j);
end
    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,nHyps);
    
    hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  ids, firstPts, settings);
    
    
    for d = ids  

        p = zeros(3, nPoints - startP +1 , NRibs);
        i = d - (j-1)*settings.maxMem;
        
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,settings.startP:nPoints,i) ;
                        
        end
            
        z_p = reshape(p(3,:,ribNumber),[],1);
        y_p = reshape(p(2,:,ribNumber),[],1);
        x_p = reshape(p(1,:,ribNumber),[],1);

        if ( abs(max(z_p) - min(z_p) - z_dif) <settings.tol && abs(abs(max(x_p) - min(x_p)) - x_dif) <settings.tolX ...
                && max(y_p)< size(heatMaps{1},1) && min(y_p)>0 )

            valid_params(d)=true;
            
           
        end
   
    end
end


nHyps = sum(valid_params);
if verbose
fprintf(1,' \n');

fprintf(1,'Valid hypotheses: %d \n',nHyps);
end

for c=1:length(compParams)
    compParams{c} =  compParams{c}(valid_params,:);
end

paramset = paramset(valid_params,:);
ang_proj= ang_proj(valid_params,:);
lenProjected= lenProjected(valid_params,:);

%% Compute   Costs
if verbose
fprintf(1,'Computing  costs...\n');
end

nIter = ceil(nHyps/settings.maxMem);

if verbose
fprintf(1,' \nValid hypotheses: %d ',nHyps);
end

computedPoints  = cell(1,NRibs);
appearanceCost  = cell(1,NRibs);
appearanceCostN = cell(1,NRibs);
neighbours = cell(1,NRibs);

for r = ribNumber
    
    appearanceCost{r} = zeros(nHyps,nPoints);
    appearanceCostN{r} = zeros(nHyps,nPoints,prod(2*settings.hw_s+1)-1);
    computedPoints{r} = cell(1,nHyps);
    neighbours{r} =  zeros(nHyps,nPoints,prod(2*settings.hw_s+1)-1);
    
end

for j = 1:nIter
    
    if verbose    
        fprintf(1,' %d ',j);
    end
    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,nHyps);
    
    hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  ids, firstPts, settings);
    
    
    for d = ids  

        p = zeros(3, nPoints - startP +1 , NRibs);
        i = d - (j-1)*settings.maxMem;
        
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,settings.startP:nPoints,i) ;
                        
        end
            
       

%         if valid_params(d)
            
            for i=1:length(settings.rules)
                
                for r = ribNumber

                selectedPoints = selectPointsR(p(:,:,r),settings.rules{i},settings);

                p_selected = p(:,selectedPoints,r);

                cost_n = zeros(size(p_selected,2),prod(2*settings.hw_s+1) -1);

                % For a neighbourhood around the points calculate the cost
                [n, inRange] = findNeighbours( transCoord(p_selected,ap,is,lr), ...
                    settings.hw_s, [1 1 1], [size(heatMaps{i},2)  size(heatMaps{i},1) size(heatMaps{i},3)] ,patch_size);

                % Cost of the neighbours 
                for k=1:size(n,3)

                    cost_n(:,k) = computeCostVoxelNoIm(n(:,:,k),patch_size,heatMaps{i},inRange(:,k));

                end

                % Cost of the pixel itself
                cost_p = computeCostVoxelNoIm(transCoord(p_selected,ap,is,lr),patch_size,heatMaps{i});

                appearanceCost{r}(d,selectedPoints) =  cost_p; % Later on we can weight these two terms differently
                computedPoints{r}{d} = union(computedPoints{r}{d},selectedPoints);
                appearanceCostN{r}(d,selectedPoints,:) =  cost_n;
                neighbours{r}(d,selectedPoints,:) = inRange;
                
                selectedPoints = computedPoints{r}{d};

%         for p = selectedPoints

                ribCostP{r}(d,selectedPoints) = neighTrans(appearanceCost{r}(d,selectedPoints) ,...
                squeeze(appearanceCostN{r}(d,selectedPoints,:))',reshape(neighbours{r}(d,selectedPoints,:),nPoints,[]),settings.sumMethod,settings.costMethod);

%         end

%         nMiddlePoints = sum(selectedPoints > settings.anglePoint);
%         nFirstPoints = sum(selectedPoints <= settings.anglePoint);

%         weightVector = [ settings.wFirst/nFirstPoints*ones(1, nFirstPoints) settings.wMiddle/nMiddlePoints*ones(1, nMiddlePoints)];
                weightVector = ones(1, length(selectedPoints));

                weightVector = weightVector/sum(weightVector);

                costVector = squeeze(ribCostP{r}(d,selectedPoints));
                ribCost{r}(d) =  weightVector*costVector';
      

                candidate_cost(d) = candidate_cost(d) + ribCost{r}(d);
        
        
                end

            end
            
            
%         end
   
    end
end




%% Evaluate costs

if verbose
    fprintf(1,'Evaluating the costs of hypotheses...\n');
end

ribCostP = cell(1,NRibs);
ribCost = cell(1,NRibs);

for r=ribNumber % for each rib

    ribCostP{r}=zeros(nHyps,nPoints);
    
end

candidate_cost = zeros(1,nHyps);

for d=1:nHyps
            
    candidate_cost(d)=0;

    for r = ribNumber % for each rib

        selectedPoints = computedPoints{r}{d};

%         for p = selectedPoints

            ribCostP{r}(d,selectedPoints) = neighTrans(appearanceCost{r}(d,selectedPoints) ,...
                squeeze(appearanceCostN{r}(d,selectedPoints,:))',reshape(neighbours{r}(d,selectedPoints,:),nPoints,[]),settings.sumMethod,settings.costMethod);

%         end

%         nMiddlePoints = sum(selectedPoints > settings.anglePoint);
%         nFirstPoints = sum(selectedPoints <= settings.anglePoint);

%         weightVector = [ settings.wFirst/nFirstPoints*ones(1, nFirstPoints) settings.wMiddle/nMiddlePoints*ones(1, nMiddlePoints)];
        weightVector = ones(1, length(selectedPoints));

        weightVector = weightVector/sum(weightVector);

        costVector = squeeze(ribCostP{r}(d,selectedPoints));
        ribCost{r}(d) =  weightVector*costVector';
      

        candidate_cost(d) = candidate_cost(d) + ribCost{r}(d);

    end
        

end

%% Save Results



cost = candidate_cost;


