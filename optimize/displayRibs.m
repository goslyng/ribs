close all
    [~,b]=sort(cost);

for h=b(1:nBest)

for r= settings.ribNumber
    
        ribShapeParams = [compParams{1}(h,r-6) compParams{2}(h,r-6)  ] ;
        tmp = reshape(ang_proj(h,:),4,[]);
        ang_rec = tmp(r-6,:);

        R = findEuler(ang_rec(1),ang_rec(2),ang_rec(3),2);

        offsetVec = T(h,1:3);
        angles =  T(h,4:6);

        R1 = findEuler(angles);
        [a_1, a_2, a_3]=findEuler(R1*R);

        TTT= [  offsetVec+firstPts(:,r)' , a_1, a_2, a_3, ribShapeParams, lenProjected(h,r-6) ];
        offsetVec = TTT(1:3);
        angles =  TTT(4:6);

        Pp = pcaProject(ribShapeModel,TTT(7:8),2);
        Pp = Pp*TTT(9);
        P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';
        ribPoints = P - repmat(P(:,1),1,100);

        R = findEuler(angles);

        ribPointsRotated = R *  ribPoints;

        p{r}(1,:) = ribPointsRotated(1,:,:) +  offsetVec(1);
        p{r}(2,:) = ribPointsRotated(2,:,:) +  offsetVec(2);
        p{r}(3,:) = ribPointsRotated(3,:,:) +  offsetVec(3);
        
end

 figure;hold on;
    pp=[];

    for r = settings.ribNumber

        plot33(p{r},'r.',[1 3 2])
        plot33(ptsRibcage,'b.',[1 3 2])

        
    end
    axis equal
end