


function [candidate_cost]= evaluateCosts(appearanceCost,  computedPoints, appearanceCostN, neighbours ,settings)

ribCostP = cell(1,settings.NRibs);
ribCost = cell(1,settings.NRibs);

for r=ribNumber % for each rib

    ribCostP{r}=zeros(settings.nHyps,settings.nPoints);
    
end

candidate_cost = zeros(1,settings.nHyps);

for d=1:settings.nHyps
            
    candidate_cost(d)=0;

    for r = settings.ribNumber % for each rib

        selectedPoints = computedPoints{r}{d};

%         for p = selectedPoints

            ribCostP{r}(d,selectedPoints) = neighTrans(appearanceCost{r}(d,selectedPoints) ,...
                squeeze(appearanceCostN{r}(d,selectedPoints,:))',reshape(neighbours{r}(d,selectedPoints,:),nPoints,[]),settings.sumMethod,settings.costMethod);

%         end

%         nMiddlePoints = sum(selectedPoints > settings.anglePoint);
%         nFirstPoints = sum(selectedPoints <= settings.anglePoint);

%         weightVector = [ settings.wFirst/nFirstPoints*ones(1, nFirstPoints) settings.wMiddle/nMiddlePoints*ones(1, nMiddlePoints)];
        weightVector = ones(1, length(selectedPoints));

        weightVector = weightVector/sum(weightVector);

        costVector = squeeze(ribCostP{r}(d,selectedPoints));
        ribCost{r}(d) =  weightVector*costVector';
      

        candidate_cost(d) = candidate_cost(d) + ribCost{r}(d);

    end
        

end