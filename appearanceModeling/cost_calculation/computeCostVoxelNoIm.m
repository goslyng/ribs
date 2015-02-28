
function cost = computeCostVoxelNoIm(p,im_cost,settings,inRange,im)

    if isempty(p)
        cost=[];
    else
    % input settings
    p_s = settings.patch_size;
    p = floor(p);
    x = p(1,:);
    y = p(2,:);
    z = p(3,:);
    p_indx = 1:size(p,2);



    if ~exist('inRange','var')
        
        inRange  = logical( ((x - p_s(1)) > 0) .* ((x + p_s(1)) <= size(im_cost,2)) .* ...
                            ((y - p_s(2)) > 0) .* ((y + p_s(2)) <= size(im_cost,1)) .* ...
                            ((z - p_s(3)) > 0) .* ((z + p_s(3)) <= size(im_cost,3))   ) ; 

    end



    validIds  = p_indx(inRange);
    indx = sub2ind(size(im_cost),y(validIds),x(validIds),z(validIds));
    cost = settings.outOfRangeCost * ones(size(p,2),1);
    
 
    if im_cost(indx)==-555
%         im_cost(indx)  = computeCost(im,indx,settings);
%         cost(validIds) =  im_cost(indx) ;
    else
        cost(validIds) = im_cost(indx);
    end
   
 
        


    
    
end