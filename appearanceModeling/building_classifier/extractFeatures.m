            

function features =  extractFeatures(patches,patch_size,method)

% x_hw = patch_size(1);
% y_hw = patch_size(2);
% patches=[];

for i=1:length(patches)
    features{i} = extractSingleFeature(patches{i},patch_size,method);
end

 