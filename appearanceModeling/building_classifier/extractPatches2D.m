function   [ribPatches,nonRibPatches] = extractPatches2DNew(im, ribPts, patch_size,debugMode)
    
    
    
 
    for i=1:length( ribPts )
        
        display(['Subject number: ' num2str(i)]);
%         fprintf(1,'\t Rib number: ');

%         numRibs = 1;%length(ribPts{i});
        ribPatches{i} = [];
        nonRibPatches{i}  = [];
%         for rib=1:numRibs
%             fprintf(1,'%d  ',rib);

            pts = ribPts{i};
            if exist('debugMode','var')
            ribPatches{i} =  extractPatchesRibs2D(im{i},pts,patch_size,debugMode.treePaths{i});
            else
                ribPatches{i} = extractPatchesRibs2D(im{i},pts,patch_size);
            end
            nonRibPatches{i} = extractPatchesNonRibs2D(im{i},pts,patch_size);

%         end
        fprintf(1,'\n');
    end
    