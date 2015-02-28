    


function [T, ribs,fval] =  fitnessFunction2( T0, ribShapeModel,heatMaps , settings,LB,UB)


    ribShapeParams = T0(1:2);
    ang_proj = T0(3:5);
    lenProjected = T0(6);
    firstPts = T0(7:9);
    
    Pp = pcaProject(ribShapeModel,ribShapeParams,length(ribShapeParams));
    Pp = Pp*lenProjected;
    P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';
    ribPoints = P - repmat(P(:,1),1,100);


    LB_(1:3) = LB(1:3) + firstPts;
    UB_(1:3) = UB(1:3) + firstPts;
    
    LB_(4:6) = LB(4:6) + ang_proj;
    UB_(4:6) = UB(4:6) + ang_proj;
    
    [T,fval] = ga(@nestedfun,length(LB),[],[],[],[],LB_,UB_);

    R_f = findEuler(T(4:6));

    ribPointsRotated_ = R_f *  ribPoints;

    ribs(1,:) = ribPointsRotated_(1,:,:) +  T(1);
    ribs(2,:) = ribPointsRotated_(2,:,:) +  T(2);
    ribs(3,:) = ribPointsRotated_(3,:,:) +  T(3);

    % Nested function that computes the objective function     
    function ribCost = nestedfun(T)


        offsetVec = T(1:3);
        angles =  T(4:6);

        appearanceCost = zeros(settings.nPoints,1);

        R = findEuler(angles);

        ribPointsRotated = R *  ribPoints;

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