



function [result, hypothesesValid] = computeValidHypotheses(hypotheses, firstPts, z_dif,x_dif,settings)

% Settings
maxMem = settings.maxMem;
hw_s = settings.hw_s;
tol = settings.tol;
startP = settings.startP;
numKnots = settings.nPoints;
ribNumber = settings.ribNumber;

nHyps = hypotheses.nHyps;

verbose=0;

%%

NRibs = ribNumber(end);    
valid_params = false(nHyps,1);
nIter = ceil(nHyps/maxMem);

fprintf(1,' \n');

fprintf(1,'Total hypotheses: %d ',nHyps);

for j=1:nIter
    
    fprintf(1,' %d ',j);

    ids = (j-1)*maxMem +1 : min(j*maxMem,nHyps);
    hyp = buildRibsFromParamsRibcage(hypotheses.allmodels,  hypotheses.compParams...
        , hypotheses.ang_proj, hypotheses.lenProjected,  ids, firstPts,settings);
    
    
    for d = ids  

        p = zeros(3, numKnots - startP +1 , ribNumber(end));
        i = d - (j-1)*maxMem;
        for r = ribNumber

            p(:,:,r) = hyp{r}(:,startP:numKnots,i) ;
                        
        end
        
        if settings.debug
            
            plot333(p,'r.',[1 3 2]);
            axis equal;
            input('hi')
            
        end
        
        z_p= reshape(p(3,:,ribNumber),[],1);
        x_p= reshape(p(1,:,ribNumber),[],1);

        if ( abs(max(z_p) - min(z_p) - z_dif) <tol && abs(abs(max(x_p) - min(x_p)) - x_dif) <settings.tolX)

            if (verbose )
              display(num2str(d));
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
%% 
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

fprintf(1,'Valid hypotheses: %d ',nHyps);

result.computedPoints = cell(NRibs,nHyps);
result.appearanceCost = cell(1,NRibs);
result.appearanceCostN = cell(1,NRibs);


for r = ribNumber
    
    result.appearanceCost{r} = zeros(nHyps,numKnots);
    result.appearanceCostN{r} = zeros(nHyps,numKnots,prod(2*hw_s+1)-1);

end

result.valid_params=true(nHyps,1);
% save(savePath,'result');
