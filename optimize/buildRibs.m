function ribs = buildRibs(ribShapeModel,firstPts,ang_proj,ribShapeParams,lenProjected)

            
            Pp_ = pcaProject(ribShapeModel,ribShapeParams,2);
            Pp_ = Pp_*lenProjected;
            P_ = [Pp_(1:100)' Pp_(101:200)' Pp_(201:300)']';
            ribPoints_ = P_ - repmat(P_(:,1),1,100);

            R_ = findEuler(ang_proj(1),ang_proj(2),ang_proj(3),2);

            ribPointsRotated_ = R_ *  ribPoints_;

            ribs(1,:) = ribPointsRotated_(1,:) +  firstPts(1) ;
            ribs(2,:) = ribPointsRotated_(2,:) +  firstPts(2) ;
            ribs(3,:) = ribPointsRotated_(3,:) +  firstPts(3) ;

