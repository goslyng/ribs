function result = computeAppearanceCostRibCageGroundtruth(hypotheses, result, firstPts, heatMaps,settings)
      

patch_size = settings.patch_size;
hw_s = settings.hw_s;
ribNumber = settings.ribNumber;
startP=settings.startP;
numKnots = settings.nPoints;
ap = settings.ap;
is = settings.is;
lr = settings.lr;

%%
    

hyp = hypotheses.transformation;




for r = ribNumber
    
    p(:,:,r) = hyp{r}(:,startP:numKnots,1) + repmat(firstPts(:,r) -hyp{r}(:,startP,1) ,1,numKnots-startP+1);
    
    for i=1:length(settings.rules)
        
        selectedPoints = selectPointsR(p(:,:,r),settings.rules{i},settings);
        p_selected = p(:,selectedPoints,r);

        cost_n = zeros(size(p_selected,2),prod(2*hw_s+1) -1);

        % For a neighbourhood around the points calculate the cost
        [n, inRange] = findNeighbours( transCoord(p_selected,ap,is,lr), hw_s, [1 1 1], [size(heatMaps{i},2)  size(heatMaps{i},1) size(heatMaps{i},3)] ,patch_size);
        % Cost of the neighbours 
        for k=1:size(n,3)

            cost_n(:,k) = computeCostVoxelNoIm(n(:,:,k),patch_size,heatMaps{i},inRange(:,k));

        end
        % Cost of the pixel itself

        cost_p = computeCostVoxelNoIm(transCoord(p_selected,ap,is,lr),patch_size,heatMaps{i});

        result.appearanceCost{r}(1,selectedPoints) =  cost_p; % Later on we can weight these two terms differently
        result.computedPoints{r,1} = union(result.computedPoints{r,1},selectedPoints);
        result.appearanceCostN{r}(1,selectedPoints,:) =  cost_n;
        result.neighbours{r}(1,selectedPoints,:)=inRange;
    end
end
       


