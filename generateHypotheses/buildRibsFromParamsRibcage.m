
function [ hypotheses, ribShapeParams]= buildRibsFromParamsRibcage(allmodels,compParams...
    ,ang_proj,lenProjected,ids_,firstPts, settings, perturb)


testRibs = settings.ribNumber;
anglePoint = settings.anglePoint;
startP = settings.startP;
nPoints = settings.nPoints;

if ~isfield('settings','angleSegmentRotation')

    angleSegmentRotation = 0;

else
    
    angleSegmentRotation = settings.angleSegmentRotation;

end


if exist('perturb','var')
    displayFlag  = 1;
else
    displayFlag  = 0;
end


ribModel = allmodels.ribcageModel;
ribShapeModel=allmodels.ribShapeModel;

nFirstPts = size(firstPts,3);
ids = floor((ids_(1)-1)/nFirstPts) +1 : ids_(end)/nFirstPts ;
parameter_size = length(ids);
ribOffset = testRibs(1)-1;
hypotheses=cell(length(testRibs),1);%zeros(3,nPoints,total_parameter_size,size(ang_proj,1),size(ang_proj,2));
ang_rec=zeros(3,parameter_size,testRibs(end));

ribShapeParams = zeros(length(testRibs),parameter_size,length(compParams));

for c = 1 :length(compParams)
    
%     comp_ = pcaProject(ribModel.ribShapeCoeffsModel{c},compParams{c}(ids,:),nCompsRibCoef);
    ribShapeParams(:,:,c)  = compParams{c}(ids,:)';
  
end


for d=1:length(testRibs)
    id_rib(d) = find(ribModel.ribs== testRibs(d));
end


for j=1:parameter_size
         d=ids(j);  

%     for k=1:length(testRibs)
        
     ang_rec(:,j,testRibs)=reshape(ang_proj(d,:),length(testRibs),[])';
%      ang_rec(1,j,testRibs(k))=ang_proj(d,id_rib(k));
%      ang_rec(2,j,testRibs(k))=ang_proj(d,id_rib(k)+4);
%      ang_rec(3,j,testRibs(k))=ang_proj(d,id_rib(k)+8);
     
%     end
end



total_parameter_size = parameter_size * nFirstPts;
for r = testRibs
    
    hypotheses{r} = zeros(3,nPoints,total_parameter_size);
    kk=0;
    for  k=1:parameter_size %paramshapeSample=1:nSamplesShape
            j=ids(k);
            Pp = pcaProject(ribShapeModel,squeeze(ribShapeParams(r-ribOffset,k,:))',length(compParams));
            Pp = Pp*lenProjected(j,r-ribOffset);
            P = [Pp(1:100)' Pp(101:200)' Pp(201:300)']';
            if angleSegmentRotation
                [~, P] = findRotaionMatrixNew(P,'Right',anglePoint);
                P=P';
            end
            rot_mat = findEuler(ang_rec(1,k,r),ang_rec(2,k,r),ang_rec(3,k,r),2);          
            hyp0 = rot_mat * P; 
            if displayFlag
                perturbPoints = perturb(k);
            else
                perturbPoints = 1:nFirstPts;
            end
            for d = perturbPoints 
                kk= kk+1;%(k-1)*nFirstPts + d ;
                hypotheses{r}(:,:,kk) = hyp0  + repmat(firstPts(:,r,d) - hyp0(:,startP) ,1,nPoints);
            end
    end   
  
    
end

