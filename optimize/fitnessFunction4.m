    


function [T, ribs,fval] =  fitnessFunction4(LB,UB, firstPts, offsetVec,ang_proj,ribShapeParams,lenProjected, ribShapeModel,heatMaps , settings)



    LB_(1:3) = LB(1:3) + ang_proj;
    UB_(1:3) = UB(1:3) + ang_proj;
        
    LB_(4:6) = LB(4:6) + offsetVec;
    UB_(4:6) = UB(4:6) + offsetVec;

    [T,fval] = ga(@nestedfun,length(LB),[],[],[],[],LB_,UB_);
    
    Pp_ = pcaProject(ribShapeModel,ribShapeParams,2);
    Pp_ = Pp_*lenProjected;
    P_ = [Pp_(1:100)' Pp_(101:200)' Pp_(201:300)']';
    ribPoints_ = P_ - repmat(P_(:,1),1,100);
    R_f = findEuler(T(1),T(2),T(3),2);

    ribPointsRotated_ = R_f *  ribPoints_;

    ribs(1,:) = ribPointsRotated_(1,:) +  firstPts(1) + T(4);
    ribs(2,:) = ribPointsRotated_(2,:) +  firstPts(2) + T(5);
    ribs(3,:) = ribPointsRotated_(3,:) +  firstPts(3) + T(6);

    % Nested function that computes the objective function     
    function ribCost = nestedfun(T)

%         offsetVec = T(1:3);
        angles = T(1:3 );
        
        Pp = pcaProject(ribShapeModel,ribShapeParams,2);
        Pp = Pp*lenProjected;
        P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';
        ribPoints = P - repmat(P(:,1),1,100);
        appearanceCost = zeros(settings.nPoints,1);

        R = findEuler(angles(1),angles(2),angles(3),2);
        ribPointsRotated = R *  ribPoints;

        p(1,:) = ribPointsRotated(1,:,:) +  firstPts(1) + T(4);
        p(2,:) = ribPointsRotated(2,:,:) +  firstPts(2) + T(5);
        p(3,:) = ribPointsRotated(3,:,:) +  firstPts(3) + T(6);


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