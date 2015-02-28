function [compParams ,ang_proj,lenProjected] = generateHypothesesFromParams(ribcageModel,paramset,settings)


nCompsRibcage = settings.nCompsRibcage;

% ribcageModel=allmodels.ribcageModel;
% meanLen = ribcageModel.meanLen;
nStd = settings.nStd;
parameter_size=size(paramset,1);

%% multiply the standard deviation to bring the parameters from the hyper-sphere to the hyper-ellipsoid

ribcageParams=zeros(parameter_size,nCompsRibcage);

dim=0;
for k=1:nCompsRibcage
    
    dim=dim+1;
    ribcageParams(:,k) = nStd * ribcageModel.stdDev(k)*paramset(:,dim);
    
end

%% Compute the projections given the parameters

coefs = ribcageModel.coefs;

ribcageProj = pcaProject(ribcageModel,ribcageParams,nCompsRibcage);
ribcageProj = ribcageProj - repmat(ribcageModel.mean,size(ribcageProj,1),1);
ribcageProj = ribcageProj./repmat(coefs,size(ribcageProj,1),1);
ribcageProj = ribcageProj + repmat(ribcageModel.mean,size(ribcageProj,1),1);

nRibsModel = length(ribcageModel.ribs);
ribs = settings.ribNumber - ribcageModel.ribs(1)+1;
i=1;
compParams{i} =ribcageProj(:,nRibsModel*(i-1)+ribs);

i=2;
compParams{i} = ribcageProj(:,nRibsModel*(i-1)+ribs);
i=3;
lenProjected = ribcageProj(:,nRibsModel*(i-1)+ribs);
vec=[];
for i=4:6
    vec=[vec nRibsModel*(i-1)+ribs];
end

ang_proj = ribcageProj(:,vec)*pi/180;%deg2rad(ribcageProj(:,vec));


