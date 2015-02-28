


function result = evaluateHypotheses(result, hypotheses,  settings)
     

 
ribNumber = settings.ribNumber;
wFirst = settings.wFirst;
wMiddle = settings.wMiddle;
anglePoint = settings.anglePoint;
nPoints = settings.nPoints;
sumMethod = settings.sumMethod;
costMethod = settings.costMethod;


  
appearanceCost = result.appearanceCost;
appearanceCostN = result.appearanceCostN;
neighbours = result.neighbours;      


nHyps = hypotheses.nHyps;


%% Total Cost with same angle for all ribs in ribcage


ribCostP = cell(1,ribNumber(end));
ribCost = cell(1,ribNumber(end));

for rib=ribNumber % for each rib

    ribCostP{rib}=zeros(nHyps,nPoints);
    
end


k=0;
candidate_cost = zeros(1,sum(result.valid_params));
% candidate_params = zeros(1,sum(result.valid_params));

for d=1:nHyps
    
    if result.valid_params(d)
        
        k=k+1;
        candidate_cost(k)=0;
        
        for rib=ribNumber % for each rib

            selectedPoints = result.computedPoints{rib,d};

            for p = selectedPoints
                    
%                 ribCostP{rib}(d,p) = neighTrans(appearanceCost{rib}(d,p) ,...
%                     squeeze(appearanceCostN{rib}(d,p,:))',squeeze(neighbours{rib}(d,p,:)),sumMethod,costMethod);
  ribCostP{rib}(d,p) = neighTrans(appearanceCost{rib}(d,p) ,...
                    squeeze(appearanceCostN{rib}(d,p,:))',squeeze(neighbours{rib}(p,:)),sumMethod,costMethod);

            end
            
%             nMiddlePoints = sum(selectedPoints>anglePoint);
%             nFirstPoints = sum(selectedPoints<=anglePoint);
% 
%             weightVector = [ wFirst/nFirstPoints*ones(1, nFirstPoints) wMiddle/nMiddlePoints*ones(1, nMiddlePoints)];
%             weightVector = weightVector/sum(weightVector);
            weightVector = ones(1,length(selectedPoints))/length(selectedPoints);
            costVector = squeeze(ribCostP{rib}(d,selectedPoints));
            ribCost{rib}(d) =  weightVector*costVector';

            candidate_cost(k)=candidate_cost(k)+ribCost{rib}(d);
            
        end
        
        candidate_params(k,:) = d;

    end

end

%% Save Results


result.ribCostP = ribCostP ;
result.candidate_cost = candidate_cost;
result.candidate_params = candidate_params; % the id of the parameter sets which are valid

