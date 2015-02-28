



function [ang_2, err_ribs, offset_index]=  optimzeAngleScalePosVerteb(settings,ribs,hypotheses,offset_index,...
    firstPts,options,ang0,heatMaps,offsets)

    if (~exist('ribsGroundTruth','var'))
        ribsGroundTruth=[];
    end
    
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

    [ang_tmp, err_ribs_, offset_index]= findOptimalAngleScaleVerteb(settings,ribs,hypotheses,...
        offset_index,firstPts,options,ang0,heatMaps,offsets_);

    err_ribs = err_ribs_(ribs);
    options0{1} = -5:2:5;
    options0{2} = -5:2:5;
    options0{3} = -5:2:5;
    options0{4} = 1;
    options0{5} = 0;
    
    k=0;
    clear offsets_;
    offsets.ranges = ceil(offsets.ranges/3);
    offsets.step=floor(offsets.step/2);
    
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

  
   [ang_tmp, err_ribs_, offset_index]= findOptimalAngleScaleVerteb(settings,ribs,hypotheses,...
        offset_index,firstPts,options0,ang_tmp,heatMaps,offsets_);

    err_ribs = err_ribs_(ribs);   
%%

    if (nRibs==1)
        ang_ = ang_tmp;
    else

        options0{1} = -5:2:5;
        options0{2} = -5:2:5;
        options0{3} = -5:2:5;
     
        x_dif=[];
        z_dif=[];
        
        for indx=1:length(ribs)
           [ang_2(indx,:), er_temp, offset_index] = findOptimalAngleScaleVerteb(settings,ribs(indx),hypotheses,...
            offset_index,firstPts,options0,ang_tmp,heatMaps,offsets_);
            err_ribs(indx) = er_temp(ribs(indx));
        end

    end
