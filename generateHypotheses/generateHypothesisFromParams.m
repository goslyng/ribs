function [compParams ,ang_proj,lenProjected] = generateHypothesisFromParams(allmodels,paramset,settings)


nCompsRibcage = settings.nCompsRibcage;

ribcageModel=allmodels.ribcageModel;
meanLen = ribcageModel.meanLen;
nStd = settings.nStd;
parameter_size=size(paramset,1);

%% multiply the standard deviation to bring the parameters from the hyper-sphere to the hyper-ellipsoid

ribcageParams=zeros(parameter_size,nCompsRibcage);

dim=0;
for k=1:nCompsRibcage
    doo
    dim=dim+1;
    ribcageParams(:,k) = nStd * ribcageModel.stdDev(k)*paramset(:,dim);
    
end

%% Compute the projections given the parameters

coefs = ribcageModel.coefs;

ribcageProj = pcaProject(ribcageModel,ribcageParams,nCompsRibcage);
ribcageProj = ribcageProj.*repmat(coefs,size(ribcageProj,1),1);

i=1;
compParams{i} =ribcageProj(:,4*(i-1)+(1:4));

i=2;
compParams{i} = ribcageProj(:,4*(i-1)+(1:4));

lenProjected = ribcageProj(:,9:12);

ang_proj = deg2rad(ribcageProj(:,13:24));


