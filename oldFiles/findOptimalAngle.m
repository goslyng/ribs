
params_

heatMaps
nBest=7;
nFirstPts = size(firstPts,3);
d_vector_params = floor((b(1:nBest)-1)/nFirstPts)+1;
perturb = b(1:nBest) - ( (d_vector_params-1)*nFirstPts )   ;

hypotheses = generateHypothesesRibcageDisplay(allmodels,settings,params_(:,1:6),firstPts,perturb);

hyp = hypotheses.transformation;

for r = settings.ribNumber
    
    p{r} = hyp{r}(:,1:settings.nPoints,5) ;
    
end     



figure;plot33(ptsRibcage(:,1:120),'b.',[1 3 2])
hold on;
plot33(p{7},'r.',[1 3 2])
axis equal

%%
clear ribCost;
for delta = -20:20
    
    



    figure(103);
hold off;
plot33(ptsRibcage,'b.',[1 3 2])


ribCost(delta+21)=0;
for r=7:10
    
    
points = p{r}(:,settings.startP:settings.startP+10)


    [Point, Dir] = lsqLine(points')
    R= vrrotvec2mat([Dir pi/180*delta]);

    p_ = R*p{r};
    clear p_2;
    p_2(1,:) =  p_(1,:) - p_(1,settings.startP)  + ptsRibcage(1,(r-7)*120+1); 
    p_2(2,:) =  p_(2,:) - p_(2,settings.startP)  + ptsRibcage(2,(r-7)*120+1); 
    p_2(3,:) =  p_(3,:) - p_(3,settings.startP)  + ptsRibcage(3,(r-7)*120+1); 

    computedPoints= false(settings.nPoints,1);
    for rul=1:length(settings.rules)

        selectedPoints = selectPointsR(p_2,settings.rules{rul},settings);
        p_selected = p_2(:,selectedPoints);
        appearanceCost(selectedPoints) =  ...
        computeCostVoxelNoIm(transCoord(p_selected,settings.ap,settings.is,settings.lr),heatMaps{rul},settings);
        computedPoints = computedPoints | selectedPoints;

    end

    % weightVector = computedPoints./computedPoints;
    weightVector = reshape(double(computedPoints)/sum(computedPoints),1,[]);
    weightVector*appearanceCost'
    ribCost(delta+21) =  ribCost(delta+21) + weightVector*appearanceCost';
    hold on;
    plot33(p_2,'r.',[1 3 2])
    axis equal
end



input(num2str(delta))
end