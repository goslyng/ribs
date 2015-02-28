function [result, hypothesesValid]= icpTransformCompute(hypotheses, firstPts, settings)
    


maxMem = settings.maxMem;
hw_s = settings.hw_s;
tol = settings.tol;
startP = settings.startP;
numKnots = settings.nPoints;
ribNumber = settings.ribNumber;
angleSegmentRotation = settings.angleSegmentRotation;
anglePoint = settings.anglePoint;    
verbose=0;
%%

NRibs = ribNumber(end);
            
% result.im_cost = -9999*ones(size(im));
                     
% params = hypotheses.params;
% hyp = hypotheses.transformation;

% numAngles = size(hyp{ribNumber(1)} ,3);
% numShapes = size(hyp{ribNumber(1)} ,4);


nHyps = hypotheses.nHyps;

valid_params = false(nHyps,1);%numShapes,numAngles);

% for i=1:numShapes
%     for a=1:numAngles
nIter = ceil(nHyps/maxMem);
fprintf(1,' \n');

fprintf(1,'Total hypotheses: %d ',nHyps);

for j=1:nIter
%     if mod(d,100)==0
            fprintf(1,' %d ',j);
%         end

    ids = (j-1)*maxMem +1 : min(j*maxMem,nHyps);% - (j-1)*maxMem);
    hyp= buildRibsFromParamsRibcage(hypotheses.ribModel,hypotheses.ribNumber,hypotheses.compParams,hypotheses.nCompsRibCoef...
        ,hypotheses.ang_proj,hypotheses.lenProjected,hypotheses.nPoints,ids,firstPts,startP,angleSegmentRotation,anglePoint);
    
    
    for d=ids  
%         if mod(d,100)==0
%             fprintf(1,' %d ',d);
%         end
        clear p;
        i = d - (j-1)*maxMem;
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,startP:numKnots,i) ;%+ repmat(firstPts(:,r) -hyp{r}(:,startP,i) ,1,numKnots-startP+1);
                        
        end
%         plot333(p,'r.',[1 3 2]);
%         axis equal;
%         input('hi')
        z_p= reshape(p(3,:,ribNumber),[],1);
        x_p= reshape(p(1,:,ribNumber),[],1);
%         x_p= reshape(p(1,:,ribNumber),[],1);
        if ( abs(max(z_p) - min(z_p) - z_dif) <tol && abs(abs(max(x_p) - min(x_p)) - x_dif) <settings.tolX)%

            if (verbose )
              display(num2str(d));

%                 display([' shape :' num2str(params(d,1)) ' length :' num2str(params(d,2)) ' angle :' num2str(params(d,3))]);
            end
            valid_params(d)=true;
            
        end
    end
end
fprintf(1,' \n');
nFirstPts = size(firstPts,3);
hyp_id = false(nHyps/nFirstPts,1);

for j=1:nHyps/nFirstPts
    for i=1:nFirstPts
        hyp_id(j) = hyp_id(j) | valid_params((j-1)*nFirstPts +i);
    end
end


hypothesesValid = hypotheses;
hypothesesValid.nHyps = sum(valid_params);
for c=1:length(hypotheses.compParams)
    hypothesesValid.compParams{c} =  hypotheses.compParams{c}(hyp_id,:);
end
hypothesesValid.paramset = hypotheses.paramset(hyp_id,:);
hypothesesValid.ang_proj = hypotheses.ang_proj(hyp_id,:);
hypothesesValid.lenProjected = hypotheses.lenProjected(hyp_id,:);
hypothesesValid.valid_params = valid_params;

nHyps = hypothesesValid.nHyps;

% nHyps =sum(valid_params);

% ribNumber = 6:10;
fprintf(1,'Valid hypotheses: %d ',nHyps);

result.computedPoints = cell(NRibs,nHyps);%numAngles  ,numShapes);
result.appearanceCost = cell(1,NRibs);
result.appearanceCostN = cell(1,NRibs);


for r = ribNumber
    
    result.appearanceCost{r} = zeros(nHyps,numKnots);%,numAngles ,numShapes,numKnots);
    result.appearanceCostN{r} = zeros(nHyps,numKnots,prod(2*hw_s+1)-1);%zeros(numAngles ,numShapes,numKnots,prod(2*w_s+1)-1);

end



result.valid_params=true(nHyps,1);

% save(savePath,'result');
