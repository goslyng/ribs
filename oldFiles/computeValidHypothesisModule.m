

function valid_params = computeValidHypothesisModule(allmodels,  compParams, ang_proj...
        , lenProjected,   firstPts, heatMaps, z_dif, x_dif, settings)

valid_params = false(settings.nHyps,1);
nIter = ceil(settings.nHyps/settings.maxMem);



if verbose
    fprintf(1,' \nTotal hypotheses: %d ',settings.nHyps);
end



if verbose
    
    fprintf(1,'Computing valid Hyposthes ..\n');
    
end

for j = 1:nIter
if verbose    
    fprintf(1,' %d ',j);
end
    ids = (j-1) * settings.maxMem +1 : min(j*settings.maxMem,settings.nHyps);
    
    hyp = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  ids, firstPts, settings);
    
    
    for d = ids  

        p = zeros(3, settings.nPoints - settings.startP +1 , settings.NRibs);
        i = d - (j-1)*settings.maxMem;
        
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,settings.startP:settings.nPoints,i) ;
                        
        end
            
        z_p = reshape(p(3,:,settings.ribNumber),[],1);
        y_p = reshape(p(2,:,settings.ribNumber),[],1);
        x_p = reshape(p(1,:,settings.ribNumber),[],1);

        if ( abs(max(z_p) - min(z_p) - z_dif) <settings.tol && abs(abs(max(x_p) - min(x_p)) - x_dif) <settings.tolX ...
                && max(y_p)< size(heatMaps{1},1) && min(y_p)>0 )

            valid_params(d)=true;
            
           
        end
   
    end
end


for c=1:length(compParams)
    compParams{c} =  compParams{c}(valid_params,:);
end
