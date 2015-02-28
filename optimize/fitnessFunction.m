    


function [T, fval] =  fitnessFunction( ribPoints, heatMaps , settings,LB,UB)

[T,fval] = ga(@nestedfun,length(LB),[],[],[],[],LB,UB);

% Nested function that computes the objective function     
    function ribCost = nestedfun(T)


        offsetVec = T(1:3);
        angles =  T(4:6);

        appearanceCost = zeros(settings.nPoints,1);

        R = findEuler(angles);

        ribPointsRotated = R * ( ribPoints - repmat( ribPoints(:,1) , 1, settings.nPoints) ) +...
        repmat( ribPoints(:,1) , 1, settings.nPoints);

        p(1,:) = ribPointsRotated(1,:,:) +  offsetVec(1);
        p(2,:) = ribPointsRotated(2,:,:) +  offsetVec(2);
        p(3,:) = ribPointsRotated(3,:,:) +  offsetVec(3);


        computedPoints= false(settings.nPoints,1);

        for rul=1:length(settings.rules)
            %     rul
            % startP = max(settings.startPEval,firstP);
            selectedPoints = selectPointsR5(p,settings.rules{rul},settings);

            %     selectedPoints = selectPointsR(p,settings.rules{rul},settings,startP);
            p_selected = p(:,selectedPoints);
            %     if size(p_selected,2)<1
            %         display('hi');
            %     end
            appearanceCost(selectedPoints) =  ...
            computeCostVoxelNoIm(transCoord(p_selected,settings.ap,settings.is,settings.lr),heatMaps{rul},settings);
            computedPoints = computedPoints | selectedPoints;

        end

        % weightVector = computedPoints./computedPoints;
        weightVector = reshape(double(computedPoints)/sum(computedPoints),1,[]);

        ribCost =  weightVector*appearanceCost;
    end
end