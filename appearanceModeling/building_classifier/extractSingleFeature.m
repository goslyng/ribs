
function features = extractSingleFeature(patches,hw,method)
    



    x_hw = hw(1);
    y_hw = hw(2);

    features = 0 * patches;
    for c = 1 : size(patches,2)
        patch_reshaped = reshape(patches(:,c),2*y_hw+1,2*x_hw+1);
%         patch_reshaped = 
        if (    patches(1,c) < 0 ) % an out of range feature point
            
            features(:,c) = patches(:,c);
            
        elseif strcmp(method,'gradient')
    %         G = fspecial('gaussian',[3 3],2);
    %         Ig = imfilter(patch_reshaped,G,'same');
    %                 [mag, direc] = imgradient(Ig);

            [mag, direc] = imgradient(patch_reshaped);
            features{1}(:,c)=reshape(mag,[],1);
            features{2}(:,c)=reshape(direc,[],1);
            
            
        elseif strcmp(method,'meanCenter')
            
            patch_reshaped0 = patch_reshaped - patch_reshaped(floor(1+end/2));
            features(:,c) = reshape(patch_reshaped0,[],1);
            
            
        elseif strcmp(method,'meanCenter2')
            
            
            w=1;
            w_v = -w:w;
            
            cntrValue = mean(reshape(patch_reshaped(x_hw+1+w_v,y_hw+1+w_v),1,[]));
            patch_reshaped0 = patch_reshaped - cntrValue;
            features(:,c) = reshape(patch_reshaped0,[],1);
            
            
        elseif strcmp(method,'meanAverage')
            
            patch_reshaped0 = patch_reshaped - mean(patch_reshaped(:));
            features(:,c) = reshape(patch_reshaped0,[],1);
        end

    end
end