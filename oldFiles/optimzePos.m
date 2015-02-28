



function [offset_opt1, err_ribs, offset_index]=  optimzePos(settings,ribs,hypotheses,offset_index,...
    firstPts,ang0,heatMaps,offsets)

    if (~exist('ribsGroundTruth','var'))
        ribsGroundTruth=[];
    end
    
    
    nRibs = length(ribs);

    [offset_opt0, err_ribs_]= findOptimalPos(settings,ribs,hypotheses,...
    offset_index,firstPts,ang0,heatMaps,offsets);
    err_ribs = err_ribs_(ribs);
    
    
%%
    if (nRibs==1)
        offset_opt1 = offset_opt0;
    else
    k=0;
    clear offsets;
    for bit1 =-5:5
        for bit2 =-2:2
            for bit3 =-5:5
                k=k+1;
                offsets(:,k)=[bit1 ;bit2 ;bit3];
            end
        end
    end

    for indx=1:length(ribs)
            [tmp, err_ribs(indx)] = optimzePos(settings,ribs(indx),hypotheses,offset_opt0,firstPts,ang0,heatMaps,offsets);
            offset_opt1(:,ribs(indx)) = tmp(:,ribs(indx));
    end
%%
       
%         [~, indx]= min(err_ribs);
%         
%            
%         [tmp, err_ribs(indx)] = optimzePos(settings,ribs(indx),hypotheses,offset_opt0,firstPts,ang0,heatMaps,offsets);
%         offset_opt1(:,ribs(indx)) = tmp(:,ribs(indx));
%         if indx>1
% 
%             [tmp , err_ribs(1:indx-1)] = optimzePos(settings,ribs(1:indx-1),hypotheses,offset_opt0,firstPts,ang0,heatMaps,offsets);
%             offset_opt1(:,ribs(1:indx-1)) =  tmp(:,ribs(1:indx-1));
%         end
% 
%         if (indx+1<=nRibs)
% 
%             [tmp , err_ribs(indx+1:nRibs)]= optimzePos(settings,ribs(indx+1:nRibs),hypotheses,offset_opt0,firstPts,ang0,heatMaps,offsets);
%             offset_opt1(:,ribs(indx+1:nRibs)) =  tmp(:,ribs(indx+1:nRibs));
%         end


    end
