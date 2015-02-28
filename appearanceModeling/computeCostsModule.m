


function [ appearanceCost,  computedPoints, appearanceCostN, neighbours ] ...
 = computeCostsModule( allmodels,  compParams, ang_proj...
        , lenProjected,   firstPts, heatMaps, patch_size, settings)


computedPoints  = cell(1,settings.NRibs);
appearanceCost  = cell(1,settings.NRibs);
appearanceCostN = cell(1,settings.NRibs);
neighbours = cell(1,settings.NRibs);


for r = settings.ribNumber
    
    appearanceCost{r} = zeros(settings.nHyps,settings.nPoints);
    appearanceCostN{r} = zeros(settings.nHyps,nPoints,prod(2*settings.hw_s+1)-1);
    computedPoints{r} = cell(1,settings.nHyps);
    neighbours{r} =  zeros(settings.nHyps,settings.nPoints,prod(2*settings.hw_s+1)-1);
    
end

nIter = ceil(settings.nHyps/settings.maxMem);

for j = 1:nIter
    
    if verbose    
        fprintf(1,' %d ',j);
    end
    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,settings.nHyps);
    
    hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  ids, firstPts, settings);
    
    
    for d = ids  

        p = zeros(3, settings.nPoints - startP +1 , settings.NRibs );
        i = d - (j-1)*settings.maxMem;
        
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,settings.startP:settings.nPoints,i) ;
                        
        end
            
       

        if valid_params(d)
            
            for i=1:length(settings.rules)
                
                for r = settings.ribNumber

                selectedPoints = selectPointsR(p(:,:,r),settings.rules{i},settings);

                p_selected = p(:,selectedPoints,r);

                cost_n = zeros(size(p_selected,2),prod(2*settings.hw_s+1) -1);

                % For a neighbourhood around the points calculate the cost
                [n, inRange] = findNeighbours( transCoord(p_selected,settings.ap,settings.is,settings.lr), ...
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
                end

            end
            
            
        end
   
    end
end
          