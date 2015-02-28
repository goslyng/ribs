


function cost = paramToCostWrapper(param, models)

allmodels = models.allmodels;
heatMaps = models.heatMaps;
firstPts = models.firstPts;
settings = models.settings;



[paramCost,  validParamset] = paramToCostConvFmin(allmodels,param,heatMaps,firstPts...
    , settings );


if isempty (validParamset)
   
    cost=9999;
    
else
      cost = paramCost;
%     cost = sum(paramCost,2);
end

