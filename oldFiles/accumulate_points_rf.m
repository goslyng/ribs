


function coords_all = accumulate_points_rf(subjects,rule,selectedPoints,...
    pos,s_3,imPath_)

coords_all='';
if length(rule)==1
    for s = subjects 


        pts =  selectedPoints{rule}{s};

        for i=1:s_3(s)

            inds = find(pts(3,:)==i);

            pts_i = unique(pts(:,inds)','rows')';

            coords=sprintf('%s%d/exh/%03d.png %d %d',imPath_,s,i,pos,size(pts_i,2));

            for j=1:size(pts_i,2)    
                coords = sprintf('%s %d %d',coords, pts_i(1,j), pts_i(2,j));
            end
            if ~isempty(inds)
                coords_all = sprintf('%s%s\n',coords_all,coords);
            end
        end
    end

else

    for s = subjects 

        for r=rule
            pts =  selectedPoints{r}{s};

            for i=1:s_3(s)

                inds = find(pts(3,:)==i);

                pts_i = unique(pts(:,inds)','rows')';

                coords=sprintf('%s%d/exh/%03d.png %d %d',imPath_,s,i,pos,size(pts_i,2));

                for j=1:size(pts_i,2)    
                    coords = sprintf('%s %d %d',coords, pts_i(1,j), pts_i(2,j));
                end
                if ~isempty(inds)
                    coords_all = sprintf('%s%s\n',coords_all,coords);
                end
            end
        end
    end

end