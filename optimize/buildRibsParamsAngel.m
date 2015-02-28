


function ribs = buildRibsParams(paramset,firstPts,settings,ribcageModel,ribShapeModel,nStd)


ribcageParams=zeros(1,settings.nCompsRibcage);

dim=0;
for k=1:settings.nCompsRibcage
    
    dim=dim+1;
    ribcageParams(k) = nStd * ribcageModel.stdDev(k)*paramset(dim);
    
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
vec=[];
for i=4:6
    vec=[vec nRibsModel*(i-1)+ribsNs];
end

ang_proj_ = deg2rad(ribcageProj(:,vec));
ang_proj = reshape(ang_proj_,4,[]);
ribShapeParams = [compParams{1}' compParams{2}'  ] ;

for r_=1:nRibsModel
        ribs{r_}= buildRibs(...
            ribShapeModel,firstPts(r_,:) ,ang_proj(r_,:) ,ribShapeParams(r_,:),lenProjected(r_));
           
end
   
