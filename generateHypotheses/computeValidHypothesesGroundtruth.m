function result = computeValidHypothesesGroundtruth(hypotheses, firstPts, ...
      heatMaps,settings)

hw_s = settings.hw_s;
startP = settings.startP;
nPoints = settings.nPoints;
ribNumber = settings.ribNumber;
        

%%

NRibs = ribNumber(end);
            
hyp = hypotheses.transformation;

result.computedPoints = cell(NRibs,1);
result.appearanceCost = cell(1,NRibs);
result.appearanceCostN = cell(1,NRibs);
result.neighbours =  cell(1,NRibs);

for r = ribNumber
    
    result.appearanceCost{r} = zeros(1,nPoints);
    result.appearanceCostN{r} = zeros(1,nPoints,prod(2*hw_s+1)-1);
    result.neighbours{r} = false(1,nPoints,prod(2*hw_s+1)-1);
    
end

clear p;

for r = ribNumber

    p(:,:,r) = hyp{r}(:,startP:nPoints,1) + repmat(firstPts(:,r) -hyp{r}(:,startP,1) ,1,nPoints-startP+1);
    
    for i=1:length(settings.rules)
        
                   
        selectedPoints = selectPointsR(p(:,:,r),settings.rules{i},settings);
        p_selected = p(:,selectedPoints,r);

        cost_n = zeros(size(p_selected,2),prod(2*hw_s+1) -1);

        % For a neighbourhood around the points calculate the cost
        [n, inRange] = findNeighbours( transCoord(p_selected,settings.ap,settings.is,settings.lr), hw_s, [1 1 1], ...
            [size(heatMaps{i},2)  size(heatMaps{i},1) size(heatMaps{i},3)] ,settings.patch_size);
        
        % Cost of the neighbours 
        for k=1:size(n,3)

           cost_n(:,k)   = computeCostVoxelNoIm(n(:,:,k),settings.patch_size,heatMaps{i},inRange(:,k));

        end
        % Cost of the pixel itself

        cost_p= computeCostVoxelNoIm(transCoord(p_selected,settings.ap,settings.is,settings.lr),settings.patch_size,heatMaps{i});

        result.appearanceCost{r}(1,selectedPoints) =  cost_p; % Later on we can weight these two terms differently
        result.computedPoints{r,1} = union(result.computedPoints{r,1},selectedPoints);
        result.appearanceCostN{r}(1,selectedPoints,:) =  cost_n;
        result.neighbours{r}(1,selectedPoints,:) = inRange;
        
    end
   
end

