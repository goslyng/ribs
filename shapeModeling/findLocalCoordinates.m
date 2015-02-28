function vertebra = findLocalCoordinates(vertebra,ribNumbers,verteb,smooth_factor,numKnotsVertebra,ribOffset)
%% Local coordinate system

    if ~exist('ribOffset','var')
        ribOffset=0;
    end
    
    for p=1:numKnotsVertebra

        range_p = max(p-smooth_factor,1):min(p+smooth_factor,numKnotsVertebra);
        
        [~, bz]=lsqPlane([vertebra.sp1(range_p,:) ;vertebra.sp2(range_p,:)]);
        if bz(3)<0
            bz=-bz;
        end
        
        [~, by1] = lsqLine(vertebra.sp1(range_p,:));
        
        if dot(vertebra.sp1(range_p(1),:) - vertebra.sp1(range_p(end),:) ,by1)<0
            by1=-by1;
        end
        
        [~, by2] = lsqLine(vertebra.sp2(range_p,:));

        if dot(vertebra.sp2(range_p(1),:) - vertebra.sp2(range_p(end),:) ,by2)<0
            by2=-by2;
        end
        
        by=(by1+by2)/norm(by1+by2);
        bx = cross(by,bz);

        coord(:,:,p) = [bx' by' bz'];
 
    end






    for rib=ribNumbers
        
       
        [a1,b1]=min(sum((repmat(vertebra.pts(:,verteb(2*rib-1)),1,100)- vertebra.sp1').^2,1));
        [a2,b2]=min(sum((repmat(vertebra.pts(:,verteb(2*rib-1)),1,100)- vertebra.sp2').^2,1));
        
        [b ,bb] = min([a1, a2]);
            
        if bb==1
            p=b1;
        else
            p=b2;
        end
        vertebra.rib(rib)=p;
        vertebra.coord(:,:,rib+ribOffset) = coord(:,:,p);
        
    end



        
   