function ribsExh_= buildExhale(ang,ribsExh,settings,offset_index,firstPts)

    for r=settings.ribNumber
        
        
        rot_mat = findRotaionMatrixNew(ribsExh{r});

        direc1= rot_mat * [0 1 0 ]';
        deg1= ang(r,1);
        deg2= ang(r,2);   
        deg3= ang(r,3);
        scale =   ang(r,4); 
        startP = ang(r,5);

        M1 = vrrotvec2mat([0 1 0 deg1/180*pi]);
        M1_r =  rot_mat*M1*rot_mat';

        P = scale*ribsExh{r};
        hyp0 = M1_r * P; 
        points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);
        [~, direc2] = lsqLine(points');


        M2 = vrrotvec2mat([direc2 deg2/180*pi]);
        direc3 = cross(direc1,direc2);


        M3 = vrrotvec2mat([direc3 deg3/180*pi]);
        hyp0_ = M3 * M2* hyp0;

        ribsExh_{r} = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
        ribsExh_{r}(1,:) = ribsExh_{r}(1,:) + offset_index(1,r);
        ribsExh_{r}(2,:) = ribsExh_{r}(2,:) + offset_index(2,r);
        ribsExh_{r}(3,:) = ribsExh_{r}(3,:) + offset_index(3,r);

    end