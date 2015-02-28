    


function [T, ribs,fval] =  fitnessFunctionAllribs3( T0, ribShapeModel,heatMaps , settings,LB,UB)


    firstPts = T0(:,1:3);
    ang_proj = T0(:,4:6);
    ribShapeParams = T0(:,7:8);
    lenProjected = T0(:,9);
    
    nRibs = size(T0,1);
   
    [T,fval] = ga(@nestedfun,length(LB),[],[],[],[],LB,UB);
    
    for r_=1:nRibs
        ribs{r_}= buildRibs(...
            ribShapeModel,firstPts(r_,:) + T(1:3),ang_proj(r_,:) + T(4:6),ribShapeParams(r_,:),lenProjected(r_)*T(9));
           
   end
    
    
    % Nested function that computes the objective function
    function ribCost = nestedfun(T)

        ribCost = 0;
        
        for r=1:nRibs
            
            p = buildRibs(...
            ribShapeModel,firstPts(r,:) + T(1:3),ang_proj(r,:) + T(4:6),ribShapeParams(r,:),lenProjected(r)*T(9));
           

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