
function ribPoints= buildSingleRibsFromParams(ribShapeModel,T)


    ribShapeParams = T(1:2);
    ang_proj = T(3:5);
    lenProjected = T(6);

    Pp = pcaProject(ribShapeModel,ribShapeParams,length(ribShapeParams));
    Pp = Pp*lenProjected;
    P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';

    rot_mat = findEuler(ang_proj(1),ang_proj(2),ang_proj(3),2);          
    ribPoints = rot_mat * P; 

    ribPoints = ribPoints - repmat(ribPoints(:,1),1,100);
