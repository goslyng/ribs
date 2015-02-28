
function Hyp = generateHypothesesRibcage(allmodels,settings)



%% Generate the parameters

[paramset, parameter_size] = generateUniformSamples(allmodels.ribcageModel,settings);


%% Generate Hypothesis From Parameters


[Hyp.compParams ,Hyp.ang_proj,Hyp.lenProjected] = generateHypothesesFromParams(allmodels,paramset,settings);

%% Save the hypotheses

Hyp.nPoints = settings.nPoints;
Hyp.paramset = paramset;
Hyp.ribModel = allmodels.ribcageModel;
Hyp.ribNumber =  settings.ribNumber;
Hyp.nCompsRibCoef = settings.nCompsRibCoef;
Hyp.allmodels = allmodels;


nFirstPts = prod(2*settings.wFirstPoint+1);%*settings.wFirstPointY*settings.wFirstPointZ;
total_parameter_size = parameter_size * nFirstPts;

Hyp.nHyps = total_parameter_size;


