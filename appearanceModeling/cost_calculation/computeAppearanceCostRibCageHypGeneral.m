function result = computeAppearanceCostRibCageHypGeneral(hypotheses, result, im,  firstPts, treePath,...
      settings,rule)

patch_size = settings.patch_size;
hw_s = settings.hw_s;
ribNumber = settings.ribNumber;
startP=settings.startP;
numKnots = settings.nPoints;
ap = settings.ap;
is = settings.is;
lr = settings.lr;

%%
       
verbose=0;

load(treePath,'treeModel');

hyp = hypotheses.transformation;
nHyps = hypotheses.nHyps;

valid_params = result.valid_params;
display(num2str(sum(valid_params)));
for d = 1:nHyps
        clear p;
        
         for r = ribNumber

            p(:,:,r) = hyp{r}(:,startP:numKnots,d) + repmat(firstPts(:,r) -hyp{r}(:,startP,d) ,1,numKnots-startP+1);
            
        end
       
        if (valid_params(d))%

            if (verbose )
                  display(num2str(d));

            end
            if result.im_cost(100,100,4)==-9999
                display('ds');
            end
            for r = ribNumber
                   
                selectedPoints = selectPointsR(p(:,:,r),rule,settings);
                
                p_selected = p(:,selectedPoints,r);

                cost_n = zeros(size(p_selected,2),prod(2*hw_s+1) -1);

                % For a neighbourhood around the points calculate the cost
                [n, inRange] = findNeighbours( transCoord(p_selected,ap,is,lr), hw_s, [1 1 1], [size(im,2)  size(im,1) size(im,3)] ,patch_size);
                % Cost of the neighbours 
                for k=1:size(n,3)

                    %efficient way
                    
                    if size(n,2)~=size(inRange,1)
                        display('hi');
                    end
                    [cost_n(:,k),  result.im_cost] = computeCostVoxelNew(im,n(:,:,k),patch_size,treeModel,result.im_cost,inRange(:,k));
                   

                end


                % Cost of the pixel itself
                
                [cost_p, result.im_cost] = computeCostVoxelNew(im,transCoord(p_selected,ap,is,lr),patch_size,treeModel,result.im_cost);
                
                result.appearanceCost{r}(d,selectedPoints) =  cost_p; % Later on we can weight these two terms differently
                result.computedPoints{r,d} = union(result.computedPoints{r,d},selectedPoints);
                result.appearanceCostN{r}(d,selectedPoints,:) =  cost_n;
                result.neighbours{r}(selectedPoints,:)=inRange;
            end
        end
end

