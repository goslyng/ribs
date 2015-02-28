  

function heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,sigma_)

newHeatMaps=1;
for i=1:length(settings.rules)



        try
%         
            load([heatMapPathRule{m}{i} postFix(1:end-4) '_scale' num2str(scale) '_sigma' num2str(10*sigma_)],'heatMap');
            heatMaps{i} = heatMap;
%             
        catch
            
%             if newHeatMaps
                
                load(im_size_path,'s_1','s_2','s_3');
                heatMap = loadHeatMaps(heatMapPathRule{m}{i},s_1(m),s_2(m),165,settings.patch_size ,-9999,postFix);
     
%             else
%                 load(heatMapPathRule{i},'heatMap');
%             end
            
            indxN = logical(heatMap==-9999);

            if strcmp(settings.costMethod,'log')
                heatMap = -log(heatMap);
                maxCost = 10;
                
            elseif strcmp(settings.costMethod,'prob');
                heatMap = -(heatMap);
                maxCost = 0 ;

            end 
            
            heatMap(indxN) = maxCost;
            heatMaps{i} = convolveHeatmap(heatMap ,sigma_);        
            
%             heatMaps{i} = resizeHeatmap(heatMap ,scale,settings.doConv,settings,sigma_);        
            heatMap = heatMaps{i};
            save([heatMapPathRule{m}{i} postFix(1:end-4) '_scale' num2str(scale) '_sigma' num2str(10*sigma_)],'heatMap');
        end
        
        
        
end 

