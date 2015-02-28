
function ribPoints= buildSingleRibsFromParams0(ribShapeModel,T)


    ribShapeParams = T(1:2);
    lenProjected = T(3);

    Pp = pcaProject(ribShapeModel,ribShapeParams,length(ribShapeParams));
    Pp = Pp*lenProjected;
    P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';

   ribPoints = P - repmat(P(:,1),1,100);
