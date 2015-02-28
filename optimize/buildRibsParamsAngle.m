


function ribs = buildRibsParamsAngle(paramset,firstPts,settings,ribcageModel,ribShapeModel,angleModel)

% settings.nCompsRibcage = 5;

[ang_proj, ribShapeParams, lenProjected]=ribParamsFromRibcageParams(paramset,ribcageModel,angleModel,settings);

nRibsModel = length(ribcageModel.ribs);

for r_=1:nRibsModel
        ribs{r_}= buildRibs(...
            ribShapeModel,firstPts(r_,:) ,ang_proj(r_,:) ,ribShapeParams(r_,:),lenProjected(r_));
           
end
   
