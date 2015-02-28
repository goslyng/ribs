    


function ribCost =  offsetFind(n, hypothesis,offsetVec,heatMaps,settings)


%   for n=1:size(offsetVec,1)
%                 clear p;
                appearanceCost = zeros(nPoints,1);
                p(1,:) = hypothesis(1,:,:) + offsetVec(n,1);
                p(2,:) = hypothesis(2,:,:) + offsetVec(n,2);
                p(3,:) = hypothesis(3,:,:) + offsetVec(n,3);

                for rul=1:length(settings.rules)

                    selectedPoints = selectPointsR(p,settings.rules{rul},settings);
                    p_selected = p(:,selectedPoints);
                    appearanceCost(selectedPoints) =  ...
                        computeCostVoxelNoIm(transCoord(p_selected,settings.ap,settings.is,settings.lr),heatMaps{rul},settings);
                end

                weightVector = ones(1, nPoints);
                weightVector = weightVector/sum(weightVector);

                ribCost =  weightVector*appearanceCost;
%                 candidate_cost(d,n,r) =  ribCost;
                
%             end