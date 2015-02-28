
function Hyp = generateHypothesesRibcageDisplay(allmodels,settings,paramset,firstPts,perturb)


parameter_size = size(paramset,1);
[compParams ,ang_proj,lenProjected]=generateHypothesesFromParams(allmodels.ribcageModel,paramset,settings);

%% Build ribs based on the parameters

 hypotheses= buildRibsFromParamsRibcage(allmodels,compParams...
        ,ang_proj,lenProjected,1:parameter_size,firstPts,settings,perturb);
    
  

%% Save the hypotheses


% Hyp.parameters.ribShapeCompsParams = compParams;
% Hyp.parameters.lengthParams = lengthParams;
% Hyp.parameters.angleParams = angleParams;

Hyp.transformation = hypotheses;
Hyp.nHyps = parameter_size;


