function [ang_, err_ribs, offset_index,heatMaps]=  optimzeAngleScalePos(settings,ribs,hypotheses,offset_index,x_dif,z_dif,...
    firstPts,ptsI,options,ang0,heatMaps,offsets,errType,imInh)


         
    vec_options{1} = sort(unique([0:-options.step1:options.ranges(1,1)   0:options.step1:options.ranges(1,2)]));
    vec_options{2} = sort(unique([0:-options.step1:options.ranges(2,1)   0:options.step1:options.ranges(2,2)]));
    vec_options{3} = sort(unique([0:-options.step1:options.ranges(3,1)   0:options.step1:options.ranges(3,2)]));
    vec_options{4} = sort(unique([0:-options.step2:(options.ranges(4,1)-1)   0:options.step2:(options.ranges(4,2)-1)]))  +1;
    vec_options{5} = sort(unique([0:-options.step3:(options.ranges(5,1))   0:options.step3:(options.ranges(5,2))]));
    
    
    
    
    k=0;
    vec1 = sort(unique([0:-offsets.step:offsets.ranges(1,1)   0:offsets.step:offsets.ranges(1,2)]));
    vec2 = sort(unique([0:-offsets.step:offsets.ranges(2,1)   0:offsets.step:offsets.ranges(2,2)]));
    vec3 = sort(unique([0:-offsets.step:offsets.ranges(3,1)   0:offsets.step:offsets.ranges(3,2)]));
    
    
    for bit1 = vec1
        for bit2 =vec2
            for bit3 =vec3
                k=k+1;
                offsets_(:,k)=[bit1 ;bit2 ;bit3];
            end
        end
    end
    
    

    
    nRibs = length(ribs);

    [ang_tmp, err_ribs_, offset_index,heatMaps]= findOptimalAngleScale(settings,ribs,hypotheses,...
        offset_index,x_dif,z_dif,firstPts,ptsI,vec_options,ang0,heatMaps,offsets_,errType,imInh);

    err_ribs = err_ribs_(ribs);
    
    
%%
    if (nRibs==1)
        ang_ = ang_tmp;
    else

       offsets.ranges(:,1)= floor(offsets.ranges(:,1)/2);
       offsets.ranges(:,2)= ceil(offsets.ranges(:,2)/2);
       offsets.step=ceil(offsets.step/2);
       
       options0 = options;
       options0.ranges([1:3 5 ],:) =ceil(options.ranges([1:3 5 ],:)/3);
       options0.step1= options.step1/2;
       options0.ranges(4,:) = [1 1];
       options0.step2= options.step2/2;
       options0.step3= ceil(options.step3/2);
       
       
        [~, indx]= min(err_ribs);
        
        x_dif=[];
        z_dif=[];
        
        [tmp, err_ribs(indx), offset_index,heatMaps] = optimzeAngleScalePos(settings,ribs(indx),hypotheses,offset_index...
            ,x_dif,z_dif,firstPts,ptsI,options0,ang_tmp,heatMaps,offsets,errType,imInh);
        ang_(ribs(indx),:)=tmp(ribs(indx),:);
        if indx>1

            [tmp , err_ribs(1:indx-1), offset_index,heatMaps] = optimzeAngleScalePos(settings,ribs(1:indx-1),hypotheses,...
                offset_index,x_dif,z_dif,firstPts,ptsI,options0,ang_tmp,heatMaps,offsets,errType,imInh);
            ang_(ribs(1:indx-1),:) = tmp(ribs(1:indx-1),:);
        end

        if (indx+1<=nRibs)

            [tmp , err_ribs(indx+1:nRibs),offset_index,heatMaps]= optimzeAngleScalePos(settings,ribs(indx+1:nRibs),...
                hypotheses,offset_index,x_dif,z_dif,firstPts,ptsI,options0,ang_tmp,heatMaps,offsets,errType,imInh);
            ang_(ribs(indx+1:nRibs),:) = tmp(ribs(indx+1:nRibs),:);
        end


    end
