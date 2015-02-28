function heatMap = generateHeatMap(im,treePath,patch_size,heatMap,z_vec)
    
% for m=[13 16 17 18 20 21]
%         m
%         z_mid = floor( size(im,3)/2 );

        x_vec = patch_size(1)+1:size(im,1)-patch_size(1);
        y_vec = patch_size(2)+1:size(im,2)-patch_size(2);

        [p_x,p_y] = meshgrid(x_vec,y_vec);
        
        load(treePath,'treeModel')
%         z_vec =[ z_mid-50:z_mid-20 z_mid+20:z_mid+50] ;

        %         heatMap= 0*im;
        for z=z_vec
      
            p_vec = [ p_x(:)';  p_y(:)'; ones(1,numel(p_x))*z] ; 

            test_patches =  extractPatchesRibs2DCell(im, p_vec , patch_size);
            % Discard the setting if there are very few patches inside the
            % image
            featuresRibs =  extractSingleFeature(test_patches,patch_size,'meanCenter2');

            [~, vote] = classRF_predict(featuresRibs',treeModel);
            appCost = vote(:,2)/treeModel.ntree;

            tmp = reshape(appCost,length(y_vec),length(x_vec));
%             heatMap{m}(:,:,floor(z/10)+1) = 0*im{m}(:,:,floor(z/10)+1);
%             heatMap{m}(:,:,z) = 0*im{m}(:,:,z);

            heatMap(y_vec,x_vec,z) =tmp;
        end 
 