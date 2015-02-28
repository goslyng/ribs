


function [err, newData_] = optimizeShapeAngleLength(ang,firstPts,offsets,heatMaps,hypotheses,settings,compParams,ribShapeModel,rot_mat)
% (ang0,lenProjected,compParams, firstPoint, startP, ribShapeModel,rot_mat,offset,heatMaps,settings,hyps)
lenProjected = ang(4);
        ribShapeParams = zeros(1,length(compParams));

        for c = 1 :length(compParams)
            ribShapeParams(c)  = compParams(c);
        end
        Pp = pcaProject(ribShapeModel,compParams,length(compParams));
        Pp = Pp*lenProjected;
        P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';
%         
   if ~exist('displayImages','var')
       displayImages=false;
   end
startP=ang(5);
   M1 = vrrotvec2mat([0 1 0 ang(1)/180*pi]);

% figure(102);


%     P = hypotheses;
%     P = ang(4)* P ;
%     rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);          
%     rot_mat = findRotaionMatrixNew(hypotheses);
    M1_ = rot_mat*  M1;

%     M1_ = rot_mat*  M1* rot_mat';
    hyp0 = M1_ * P;   
    direc1= rot_mat * [0 1 0 ]';
    points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);

    [~, direc2] = lsqLine(points');
    M2 = vrrotvec2mat([direc2 ang(2)/180*pi]);
    direc3 = cross(direc1, direc2);

    M3 = vrrotvec2mat([direc3 ang(3)/180*pi]);
    hyp0_ = M3 * M2* hyp0;

    newData_ = hyp0_  + repmat(firstPts - hyp0_(:,startP) ,1,settings.nPoints);
    newData_ = newData_+ repmat(offsets,1,size( hyp0_,2));
   
          
        err =  offsetCost(newData_,offsets,heatMaps,settings,startP);
