function [ang_proj, ribShapeParams, lenProjected]=ribParamsFromRibcageParams(paramset,ribcageModel,angleModel,settings)



ribcageParams=zeros(1,settings.nCompsRibcage);

dim=0;
for k=1:settings.nCompsRibcage
    
    dim=dim+1;
    ribcageParams(k) = settings.nStd * ribcageModel.stdDev(k)*paramset(dim);
    
end

coefs = ribcageModel.coefs;

ribcageProj = pcaProject(ribcageModel,ribcageParams,settings.nCompsRibcage);
ribcageProj = ribcageProj - repmat(ribcageModel.mean,size(ribcageProj,1),1);
ribcageProj = ribcageProj./repmat(coefs,size(ribcageProj,1),1);
ribcageProj = ribcageProj + repmat(ribcageModel.mean,size(ribcageProj,1),1);

nRibsModel = length(ribcageModel.ribs);
ribsNs = settings.ribNumber - ribcageModel.ribs(1)+1;
i=1;
compParams{i} =ribcageProj(:,nRibsModel*(i-1)+ribsNs);

i=2;
compParams{i} = ribcageProj(:,nRibsModel*(i-1)+ribsNs);
i=3;
lenProjected = ribcageProj(:,nRibsModel*(i-1)+ribsNs);

ribShapeParams = [compParams{1}' compParams{2}'  ] ;


%%
% settings.nCompsAngle = 4;
angleParams=zeros(1,settings.nCompsAngle);

for k=1:settings.nCompsAngle
    
    dim=dim+1;
    angleParams(k) = settings.nStd * angleModel.stdDev(k)*paramset(dim);
    
end

ang_proj_ = pcaProject(angleModel,angleParams,settings.nCompsAngle);

% vec=[];
% for i=4:6
%     vec=[vec nRibsModel*(i-1)+ribsNs];
% end

% ang_proj = reshape(ang_proj_,4,[]);
ang_proj = reshape(ang_proj_,3,[])';

