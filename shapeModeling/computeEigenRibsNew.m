
for s = ctSubjects
    for m = testRibs
        
       sp{s,(m+1)/2} = ctSubject{s}.ribs{m}.proj;

    end
end

%% Make general eigen ribs

rib_acc_pts = zeros(3*nPoints,numel(ctSubjects)*numel(testRibs));
counter=1;

for s=ctSubjects
    for m = testRibs
%         rib_acc_pts(:,counter) =reshape(ctSubject{s}.ribs{m}.proj,[],1);
        rib_acc_pts(:,counter) =reshape(sp{s,(m+1)/2},[],1);
        counter=counter+1;
        
    end
end


%% Model the length of the ribs

%Length of each rib

x = rib_acc_pts(1:nPoints,:);
y = rib_acc_pts(nPoints+1:2*nPoints,:);
z = rib_acc_pts(2*nPoints+1:3*nPoints,:);

pp=cat(3,x,y,z);
len =  squeeze(sum(sqrt(sum((pp(2:end,:,:)-pp(1:end-1,:,:)).^2,3)),1));

% PCA
meanLen = mean(len);
lenghthModel.mean = meanLen;
lenMatrix = reshape(len/meanLen,[],numel(ctSubjects));
lenMatrix1 = reshape(len,[],numel(ctSubjects));
lenMatrix1 = lenMatrix1./repmat(lenMatrix1(1,:),4,1);
N=mean(lenMatrix1,2);

    
%% Model the ribs normalized according to length, and rotated


rib_acc_pts0 = rib_acc_pts ./repmat(len/meanLen,[ size(rib_acc_pts,1) 1]);

%% Building the models

ribShapeModel= pcaModeling(rib_acc_pts0');


%%
ribcage=[];

for i=1:nCompsShape
  
    ribcage=[ribcage, reshape(ribShapeModel.proj(:,i),[],length(ctSubjects))'];
    
end


ribcage=[ribcage,...
    lenMatrix',...reshape(len,[],numel(ctSubjects))',... 
    squeeze(rad2deg(ang(1,ctSubjectsVert,n:end)))  ,... 
    squeeze(rad2deg(ang(2,ctSubjectsVert,n:end))) ,... 
    squeeze(rad2deg(ang(3,ctSubjectsVert,n:end))) ];
    
    
%     
%     
% ribcage=[reshape(ribShapeModel.proj(:,1),[],length(ctSubjects))',... 
%         reshape(ribShapeModel.proj(:,2),[],length(ctSubjects))' ,... 
%         lenMatrix',...reshape(len,[],numel(ctSubjects))',... 
%         squeeze(rad2deg(ang(1,ctSubjectsVert,n:end)))  ,... 
%         squeeze(rad2deg(ang(2,ctSubjectsVert,n:end))) ,... 
%         squeeze(rad2deg(ang(3,ctSubjectsVert,n:end))) ];
%     
meanRibCageCT =repmat(mean(ribcage),size(ribcage,1),1);
ribcageCT = ribcage - meanRibCageCT ; 
coefs = 100./ mean(abs(ribcageCT));

ribcageCT = ribcageCT.*repmat(coefs,size(ribcageCT,1),1);
ribcageCT = ribcageCT+meanRibCageCT;

ribcageCTModel = pcaModeling (ribcageCT);
ribcageCTModel.coefs  = coefs;
ribcageCTModel.ribs = (testRibs+1)/2;
ribcageCTModel.meanLen = meanLen;


%% Models

ribCageLengthModel = pcaModeling(lenMatrix');

ribShapeLengthModel= pcaModeling(rib_acc_pts');

ribAngleModelCT = pcaModeling(ang_mat);

ribAngleModelCT.ribNumbers= (testRibs+1)/2;
% ribShapeCoefModels = cell(1,nCompsRibCage);

% for c = 1 :nCompsRibCage
%     
%     comp_ = reshape(ribShapeModel.proj(:,c),[],length(ctSubjects));
%     ribShapeCoefModels{c}  = pcaModeling(comp_');
%     
% end


% ribCageLengthModel.mean =[1.06 1.06 1.06 0.99];
%%
ribcageModel = ribcageCTModel;
save(ribShapeModelPath, 'ribShapeModel');
% save(ribShapeCoefModelsPath,  'ribShapeCoefModels');
% save(ribCageLengthModelPath,  'ribCageLengthModel');
% save(ribAngleModelCTPath, 'ribAngleModelCT');
save(ribcageModelPath,  'ribcageModel');
% save(ribcageWOAngleModelPath,  'ribcageWOAngleModel');

