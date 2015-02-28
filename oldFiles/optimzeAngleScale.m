



function [ang_, err_ribs]=  optimzeAngleScale(settings,ribs,hypotheses,ang_rec,firstPts,ptsI,options,ang0,heatMaps)

    nRibs = length(ribs);


    ang_tmp= findOptimalAngleScale(settings,ribs,hypotheses,ang_rec,firstPts,ptsI,options,ang0,heatMaps);
    
    
%     ang_(ribs,:) = repmat(ang_tmp,length(ribs),1);

    for r = ribs

%         tmp = displayAngles(settings,hypotheses,ang_(r,:),firstPts,ptsI,r,ang_rec);
        tmp = displayAngles(settings,hypotheses,ang_tmp,firstPts,ptsI,r,ang_rec);

        newData_{r} = tmp{r};
%         err_ribs(r)= computeErorr(newData_,ptsI,r,settings);
 
        err_ribs(r) = offsetCost(newData_{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);

    end
   if (nRibs==1)
       ang_ = ang_tmp;
   else
%%
        options0{1} = options{1}(1)*3/4:options{1}(end)*3/4;
        options0{2} = options{2}(1)*3/4:options{2}(end)*3/4;
        options0{3} = options{3}(1)*3/4:options{3}(end)*3/4;
        options0{4} = 0;

%         options0{1} = -7:7;
%         options0{2} = -7:7;
%         options0{3} = -7:7;
%         options0{4} = 0;
%               options0 = options;
               options0{4} = 0;
        [~, indx]= min(err_ribs(ribs));
        
        ang_(indx,:) = optimzeAngleScale(settings,ribs(indx),hypotheses,ang_rec,firstPts,ptsI,options0,ang_tmp,heatMaps);
%         ang_(ribs(1:indx-1),:) = optimzeAngleScale(settings,ribs(1:indx-1),hypotheses,ang_rec,firstPts,ptsI,options0,ang_(ribs(index),:));
%         ang_(ribs(indx+1:end),:) = optimzeAngleScale(settings,ribs(indx+1:end),hypotheses,ang_rec,firstPts,ptsI,options0,ang_(ribs(index),:));
%
        if indx>1
            ang_(1:indx-1,:) = optimzeAngleScale(settings,ribs(1:indx-1),hypotheses,ang_rec,firstPts,ptsI,options0,ang_tmp,heatMaps);
        end
        if (indx+1<=nRibs)
            ang_(indx+1:nRibs,:) = optimzeAngleScale(settings,ribs(indx+1:end),hypotheses,ang_rec,firstPts,ptsI,options0,ang_tmp,heatMaps);
        end
   end
        
%         ang_tmp = findOptimalAngleScale(settings,testRibs(indx+1:end),hypotheses,ang_rec,firstPts,ptsI,options0,ang_(testRibs(index),:));
%         ang_(testRibs(indx+1:end),:)=repmat(ang_tmp,4 - index,1);       
        