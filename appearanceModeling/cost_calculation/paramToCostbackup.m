

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


%% Compute valid hypotheses and  Compute Costs

fprintf(1,'Computing valid Hyposthes and costs...\n');

valid_params = false(nHyps,1);
nIter = ceil(nHyps/settings.maxMem);


fprintf(1,' \nTotal hypotheses: %d ',nHyps);

computedPoints  = cell(NRibs,nHyps);
appearanceCost  = cell(1,NRibs);
appearanceCostN = cell(1,NRibs);


for r = ribNumber
    
    appearanceCost{r} = zeros(nHyps,nPoints);
    appearanceCostN{r} = zeros(nHyps,nPoints,prod(2*settings.hw_s+1)-1);

end

for j = 1:nIter
    
    fprintf(1,' %d ',j);

    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,parameter_size);
    
    hyp = buildRibsFromParamsRibcage(allmodels, ribNumber, compParams...
        , ang_proj, lenProjected, nPoints, ids,...
        firstPts,settings.startP, settings.anglePoint, settings.angleSegmentRotation);
    
    
    for d = ids  

        p = zeros(3, nPoints - startP +1 , NRibs);
        i = d - (j-1)*settings.maxMem;
        
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,settings.startP:nPoints,i) ;
                        
        end
            
        z_p= reshape(p(3,:,ribNumber),[],1);
        x_p= reshape(p(1,:,ribNumber),[],1);

        if ( abs(max(z_p) - min(z_p) - z_dif) <settings.tol && abs(abs(max(x_p) - min(x_p)) - x_dif) <settings.tolX)

            valid_params(d)=true;
            
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
                neighbours{r}(selectedPoints,:)=inRange;
                end

            end
            
            
        end
   
    end
end


nHyps = sum(valid_params);
fprintf(1,' \n');

fprintf(1,'Valid hypotheses: %d \n',nHyps);


for c=1:length(compParams)
    compParams{c} =  compParams{c}(valid_params,:);
end

paramset = paramset(valid_params,:);
ang_proj = ang_proj(valid_params,:);
lenProjected = lenProjected(valid_params,:);

for r = ribNumber

    appearanceCost{r} = appearanceCost{r}(valid_params,:);
    appearanceCostN{r} = appearanceCostN{r}(valid_params,:,:);
    computedPoints{r}=computedPoints{r}(valid_params);
end

%%


fprintf(1,'Valid hypotheses: %d \n',nHyps);
fprintf(1,'Computing costs of hyposthes...\n');

computedPoints  = cell(NRibs,nHyps);
appearanceCost  = cell(1,NRibs);
appearanceCostN = cell(1,NRibs);


for r = ribNumber
    
    appearanceCost{r} = zeros(nHyps,nPoints);
    appearanceCostN{r} = zeros(nHyps,nPoints,prod(2*settings.hw_s+1)-1);

end

nIter = ceil(nHyps/settings.maxMem);
    
for j=1:nIter

    ids = (j-1)*settings.maxMem +1 : min(j*settings.maxMem,nHyps);

    hyp = buildRibsFromParamsRibcage(allmodels,  compParams...
        , ang_proj, lenProjected,  ids, firstPts,settings);
 
    
    for d=ids 
        
        for r = ribNumber

            p= hyp{r}(:,startP:nPoints,d) ;

            for i=1:length(settings.rules)
                

                selectedPoints = selectPointsR(p,settings.rules{i},settings);

                p_selected = p(:,selectedPoints);

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
                computedPoints{r,d} = union(computedPoints{r,d},selectedPoints);
                appearanceCostN{r}(d,selectedPoints,:) =  cost_n;
                neighbours{r}(selectedPoints,:)=inRange;

            end

        end
    end
end

%% Evaluate costs

fprintf(1,'Evaluating the costs of hypotheses...\n');


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

            for p = selectedPoints
                    
                ribCostP{r}(d,p) = neighTrans(appearanceCost{r}(d,p) ,...
                    squeeze(appearanceCostN{r}(d,p,:))',neighbours{r}(p,:),settings.sumMethod,settings.costMethod);

            end
            
            nMiddlePoints = sum(selectedPoints > settings.anglePoint);
            nFirstPoints = sum(selectedPoints <= settings.anglePoint);

            weightVector = [ settings.wFirst/nFirstPoints*ones(1, nFirstPoints) settings.wMiddle/nMiddlePoints*ones(1, nMiddlePoints)];
            weightVector = weightVector/sum(weightVector);

            costVector = squeeze(ribCostP{r}(d,selectedPoints));
            ribCost{r}(d) =  weightVector*costVector';

            candidate_cost(d) = candidate_cost(d)+ribCost{r}(d);
            
        end
        

end

%% Save Results



cost = candidate_cost;


