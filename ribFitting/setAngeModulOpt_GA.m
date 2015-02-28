

function mean_er = setAngeModulOpt_GA(m,part,inh)
if ~exist('inh','var')
inh=0;
end
settings.nSamplesRibcage =6;
addpath('/home/sameig/codes/ribFitting')
addpath('/home/sameig/codes/ribFitting/ribFitting/auxiliary');
loadAndPrepareData;

%%


for i=1:3
    resultPath{i} = [rootPath 'Ribs/res_GA_step' num2str(i) '_' num2str(m)];
end

if (m==59 || m==60 || m==550)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end



apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

testPoints=1:settings.nPoints;


for i=settings.ribNumber
    ptsI{i}=ptsI{i};
    tmp = ptsI{i};
    ptsI{i} = tmp(:,testPoints);
end

ptsRibcage=[];

for r= settings.ribNumber
    ptsRibcage = [ptsRibcage ptsI{r}];
end



nBest = 5;   


if (m==59 || m==60 || m==550)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end
    

 RR = [
apMRI;
isMRI
lrMRI];

   

%%

if (part==1 || part==12)
    scale=1;

    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);
    LB=[ -1 -1 -1 , -0.4 , -0.4 , -0.4 ] ;
    UB=[ 1 1 1 , 0.4 , 0.4 , 0.4 ] ;
    for h=1:parameter_size

        for r= settings.ribNumber
            
            hypotheses{r} = hyps{r}(:,testPoints,h);
            ribPoints{r} = hyps{r}(:,:,h) -  repmat( hypotheses{r}(:,1) - firstPts(:,r), 1, settings.nPoints);
        end
        
        [T(h,:), cost(h)] =  fitnessFunctionAllribs( ribPoints,heatMaps , settings,LB,UB);
        
    end
    
    save(resultPath{1},'T','cost');

end


%%
if (part==2 || part==12)

    scale=1;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(part));

    load(resultPath{part-1},'T','cost');

    LB=[ -1 -1 -1 , -0.4 , -0.4 , -0.4 ] ;
    UB=[ 1 1 1 , 0.4 , 0.4 , 0.4 ] ;
    [~,b]=sort(cost);

    %     [~,b]=sort(mean(cost(:,settings.ribNumber),2));
    for h=b(1:nBest)'

        offsetVec = T(h,1:3);
        angles =  T(h,4:6);

        R = findEuler(angles);

        for r = settings.ribNumber

            ribPoints{r} = hyps{r}(:,:,h) -  repmat( hyps{r}(:,1,h) - firstPts(:,r), 1, settings.nPoints);
            ribPointsRotated = R * ( ribPoints{r} - repmat( ribPoints{r}(:,1) , 1, settings.nPoints) ) +...
            repmat( ribPoints{r}(:,1) , 1, settings.nPoints);

            p_(1,:) = ribPointsRotated(1,:,:) +  offsetVec(1);
            p_(2,:) = ribPointsRotated(2,:,:) +  offsetVec(2);
            p_(3,:) = ribPointsRotated(3,:,:) +  offsetVec(3);


            [T_(r,h,:), cost_(r,h)] =  fitnessFunction( p_,heatMaps , settings,LB,UB);
            plot33(p_,'b.',[1 3 2])
        end


    end

    [~, h ]= min(sum(cost_,1));
    for r= settings.ribNumber

        offsetVec = T(h,1:3);
        angles =  T(h,4:6);
        R = findEuler(angles);

        ribPoints{r} = hyps{r}(:,:,h) -  repmat( hyps{r}(:,1,h), 1, settings.nPoints);
        ribPointsRotated = R * ribPoints{r} + repmat( firstPts(:,r) , 1, settings.nPoints) ; 


        p_(1,:) = ribPointsRotated(1,:) +  offsetVec(1);
        p_(2,:) = ribPointsRotated(2,:) +  offsetVec(2);
        p_(3,:) = ribPointsRotated(3,:) +  offsetVec(3);
        %                   
        %            p{r}(1,:) = ribPointsRotated(1,:,:) +  offsetVec(1);
        %             p{r}(2,:) = ribPointsRotated(2,:,:) +  offsetVec(2);
        %             p{r}(3,:) = ribPointsRotated(3,:,:) +  offsetVec(3);

        offsetVec = squeeze(T_(r,h,1:3));
        angles =  squeeze(T_(r,h,4:6));


        R = findEuler(angles);
        ribPointsRotated = R * ( p_ - repmat( p_(:,1) , 1, settings.nPoints) ) +...
        repmat( p_(:,1) , 1, settings.nPoints);

        p{r}(1,:) = ribPointsRotated(1,:,:) +  offsetVec(1);
        p{r}(2,:) = ribPointsRotated(2,:,:) +  offsetVec(2);
        p{r}(3,:) = ribPointsRotated(3,:,:) +  offsetVec(3);
    end

    figure;hold on;
    pp=[];

    for r=7:10

        plot33(p{r},'b.',[1 3 2])
        pp=[pp RR*p{r}];
        plot33(ptsRibcage,'r.',[1 3 2])

        
    end
    axis equal
    writeVTKPolyDataPoints(resultPath{part},pp)

end

 for r = testRibs

        newData_{h}{r} = p{r};
        err_ribs(h,r,1)= computeErorr(newData_{h},ptsI,r,settings, settings.step,1,1);
        err_ribs(h,r,2)= computeErorr(newData_{h},ptsI,r,settings, settings.step,1,2);
        
%         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);
 
 end
