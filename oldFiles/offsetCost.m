    


function [ribCost, heatMaps] =  offsetCost( hypothesis,offsetVec,heatMaps,settings,firstP,fminStep)

if ~exist('fminStep','var')
    fminStep=1;
end

if ~exist('firstP','var')
    firstP=1;
end


appearanceCost = zeros(settings.nPoints,1);
offsetVec =round(fminStep*offsetVec);

p(1,:) = hypothesis(1,:,:) + offsetVec(1);
p(2,:) = hypothesis(2,:,:) + offsetVec(2);
p(3,:) = hypothesis(3,:,:) + offsetVec(3);
computedPoints= false(settings.nPoints,1);


for rul=1:length(settings.rules)
%     rul
% startP = max(settings.startPEval,firstP);
            selectedPoints = selectPointsR5(p,settings.rules{rul},settings);

%     selectedPoints = selectPointsR(p,settings.rules{rul},settings,startP);
    p_selected = p(:,selectedPoints);
%     if size(p_selected,2)<1
%         display('hi');
%     end
    appearanceCost(selectedPoints) =  ...
    computeCostVoxelNoIm(transCoord(p_selected,settings.ap,settings.is,settings.lr),heatMaps{rul},settings);
    computedPoints = computedPoints | selectedPoints;
    
end

% weightVector = computedPoints./computedPoints;
weightVector = reshape(double(computedPoints)/sum(computedPoints),1,[]);

ribCost =  weightVector*appearanceCost;
