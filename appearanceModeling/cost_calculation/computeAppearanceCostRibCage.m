function result = computeAppearanceCostRibCage(hypotheses, result, im,  firstPts, treePath,...
      settings,rule)

maxMem = settings.maxMem;
  
patch_size = settings.patch_size;
hw_s = settings.hw_s;
ribNumber = settings.ribNumber;

startP=settings.startP;
numKnots = settings.nPoints;
nHyps = hypotheses.nHyps;


ap = settings.ap;
is = settings.is;
lr = settings.lr;


valid_params = result.valid_params;

verbose=0;

%%

load(treePath,'treeModel');


display(num2str(sum(valid_params)));

nIter = ceil(nHyps/maxMem);
    
for j=1:nIter

    ids = (j-1)*maxMem +1 : min(j*maxMem,nHyps);

    hyp= buildRibsFromParamsRibcage(hypotheses.allmodels,hypotheses.compParams...
        ,hypotheses.ang_proj,hypotheses.lenProjected,ids,firstPts,settings);
 
    
    for d=ids 
        if (valid_params(d))

            if (verbose )
                  display(num2str(d));

            end
                        
            i = d - (j-1)*maxMem;
            p = zeros(3,numKnots - startP +1 , ribNumber(end));

            for r = ribNumber
                
                p(:,:,r) = hyp{r}(:,startP:numKnots,i) ;
                
                selectedPoints = selectPointsR(p(:,:,r),rule,settings);
                
                p_selected = p(:,selectedPoints,r);

                cost_n = zeros(size(p_selected,2),prod(2*hw_s+1) -1);

                % For a neighbourhood around the points calculate the cost
                [n, inRange] = findNeighbours( transCoord(p_selected,ap,is,lr), hw_s, [1 1 1], [size(im,2)  size(im,1) size(im,3)] ,patch_size);
                
                % Cost of the neighbours 
                for k=1:size(n,3)

                    [cost_n(:,k),  result.im_cost] = computeCostVoxel(im,n(:,:,k),patch_size,treeModel,result.im_cost,inRange(:,k));

                end

                % Cost of the pixel itself
                [cost_p, result.im_cost] = computeCostVoxel(im,transCoord(p_selected,ap,is,lr),patch_size,treeModel,result.im_cost);

                result.appearanceCost{r}(d,selectedPoints) =  cost_p; % Later on we can weight these two terms differently
                result.computedPoints{r,d} = union(result.computedPoints{r,d},selectedPoints);
                result.appearanceCostN{r}(d,selectedPoints,:) =  cost_n;
                result.neighbours{r}(selectedPoints,:)=inRange;
                
                
            end
        end
    end
end

