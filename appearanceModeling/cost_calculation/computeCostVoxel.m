
function [cost, im_cost] = ...
    computeCostVoxel(im,p,p_s,treeModel,im_cost,inRange)

    % input settings
   
    p = floor(p);
    x = p(1,:);
    y = p(2,:);
    z = p(3,:);
    p_indx = 1:size(p,2);



    if ~exist('inRange','var')
        
        inRange  = logical( ((x - p_s(1)) > 0) .* ((x + p_s(1)) <= size(im,2)) .* ...
                            ((y - p_s(2)) > 0) .* ((y + p_s(2)) <= size(im,1)) .* ...
                            ((z - p_s(3)) > 0) .* ((z + p_s(3)) <= size(im,3))   ) ; 

    end



    validIds  = p_indx(inRange);
    indx = sub2ind(size(im),y(validIds),x(validIds),z(validIds));
    cost = -9999 * ones(size(p,2),1);
    
           
    newPIndx = validIds(im_cost(indx)==-9999);
    nPatches = length(newPIndx);

    if ~isempty(newPIndx)
        newP = p(:,newPIndx);
        testP=newP;
        indxNew = sub2ind(size(im),newP(2,:),newP(1,:),newP(3,:));
    end
   


    if nPatches > 0

        test_patches =  extractPatchesRibs2DCell(im, testP , p_s);
        featuresRibs =  extractSingleFeature(...
            test_patches,p_s,treeModel.featureType);


        [~, vote] = classRF_predict(featuresRibs',treeModel);

        costNew =  vote(:,2)/treeModel.ntree;

        im_cost(indxNew) = costNew;
            

    end

   
    cost(validIds) = im_cost(indx);
   
 
        


    
    
end