

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

candidate_cost = zeros(nHyps,1);
for j = 1:nIter
    
    if verbose    
        fprintf(1,' %d ',j);
    end
    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,nHyps);
    
    hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  ids, firstPts, settings);
   
    for d = ids  
        if verbose   
            if mod(d,10)==0
                fprintf(1,' %d ',d);
            end
        end
        p = zeros(3, nPoints - startP +1 , NRibs);
        i = d - (j-1)*settings.maxMem;
        
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,settings.startP:nPoints,i) ;
                        
        end
        appearanceCost  = zeros(nPoints,1);
        appearanceCostN = zeros(nPoints,prod(2*settings.hw_s+1) -1);
        neighbours = zeros(nPoints,prod(2*settings.hw_s+1) -1);
        for r = ribNumber

            for i=1:length(settings.rules)

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

                appearanceCost(selectedPoints)=  cost_p; % Later on we can weight these two terms differently
                appearanceCostN(selectedPoints,:) =  cost_n;
                neighbours(selectedPoints,:) = inRange;
            end


            ribCostP = neighTrans(appearanceCost, appearanceCostN, neighbours, settings);
            weightVector = ones(1, nPoints);
            weightVector = weightVector/sum(weightVector);

            costVector = squeeze(ribCostP);
            ribCost =  weightVector*costVector';
            candidate_cost(d) = candidate_cost(d) + ribCost;

        end
          
    end
end

cost = candidate_cost;


