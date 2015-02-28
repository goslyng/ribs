    


function [T, ribs,fval] =  fitnessFunctionAllribs4(LB,UB, firstPts, ribcageModel,ribShapeModel,heatMaps , settings)




    nRibs = length(ribcageModel.ribs);
    [T,fval] = ga(@nestedfun,length(LB),[],[],[],[],LB,UB);
    
    %%
    p_ = buildRibsParams(T,firstPts,settings,ribcageModel,ribShapeModel,settings.nStd);
    offsetVec_ = T(end-2:end);
    for r_=1:nRibs

        ribs{r_}(1,:) = p_{r_}(1,:) +  offsetVec_(1);
        ribs{r_}(2,:) = p_{r_}(2,:) +  offsetVec_(2);
        ribs{r_}(3,:) = p_{r_}(3,:) +  offsetVec_(3);
    end
    %%  Nested function that computes the objective function
    
    function ribCost = nestedfun(T)
        
        offsetVec = T(end-2:end);

        ribCost = 0;
        ribs_ = buildRibsParams(T,firstPts,settings,ribcageModel,ribShapeModel,settings.nStd);
        
        for r=1:nRibs
            
            p(1,:) = ribs_{r}(1,:) +  offsetVec(1);
            p(2,:) = ribs_{r}(2,:) +  offsetVec(2);
            p(3,:) = ribs_{r}(3,:) +  offsetVec(3);
            computedPoints= false(settings.nPoints,1);
            appearanceCost = zeros(settings.nPoints,1);

            for rul=1:length(settings.rules)
              
                selectedPoints = selectPointsR5(p,settings.rules{rul},settings);
                p_selected = p(:,selectedPoints);
                
                appearanceCost(selectedPoints) =  ...
                computeCostVoxelNoIm(transCoord(p_selected,settings.ap,settings.is,settings.lr),heatMaps{rul},settings);
                computedPoints = computedPoints | selectedPoints;

            end

            weightVector = reshape(double(computedPoints)/sum(computedPoints),1,[]);

            ribCost =  ribCost + weightVector*appearanceCost;
        end
    end


end