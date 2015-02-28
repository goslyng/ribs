

function [b]= findOptimalTranslation(settings,testRibs,hypotheses,...
    offset_initial,firstPts,imInh,imExh,pExh,offsets,startP)


for r=testRibs
    firstPts(:,r) =firstPts(:,r) + offset_initial(:,r);
end

 k=0;
    vec1 = sort(unique([0:-offsets.step:offsets.ranges(1,1)   0:offsets.step:offsets.ranges(1,2)]));
    vec2 = sort(unique([0:-offsets.step:offsets.ranges(2,1)   0:offsets.step:offsets.ranges(2,2)]));
    vec3 = sort(unique([0:-offsets.step:offsets.ranges(3,1)   0:offsets.step:offsets.ranges(3,2)]));
    for bit1 = vec1
        for bit2 =vec2
            for bit3 =vec3
                k=k+1;
                offset(:,k)=[bit1 ;bit2 ;bit3];
            end
        end
    end
    
    

err = zeros(size(offset,2),1);


                    
settings.rules={'angle'};
settingsReg = settings; 
settingsReg.nPoints = 10;   % to only include the first points which are least
% affected by the rotation induced by respiration
for o =1:size(offset,2)
    
    for r=testRibs

        newData = hypotheses{r}  + repmat(firstPts(:,r) - hypotheses{r}(:,startP(r)) ,1,settings.nPoints);

        newData_(1,:) = newData(1,:) + offset(1,o);
        newData_(2,:) = newData(2,:) + offset(2,o);
        newData_(3,:) = newData(3,:) + offset(3,o);
       
        [regCost,nccE(o,r,:)] = regCostPar(newData_,pExh{r},imInh,imExh,settingsReg);
        err(o) = err(o)  + regCost;

    end

end

[~, k]=min(err);
b=offset(:,k);
% offset_indx = offset_initial;
% offset_indx(:,testRibs) = offset_initial(:,testRibs) + repmat(offset(:,a),1,length(testRibs)) ;%reshape(offset_index(b,:,:),length(testRibs),[]);

