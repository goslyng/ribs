

function mean_er = setAngeModulOpt_GA2(m,part)
if ~exist('inh','var')
inh=0;
end
settings.nSamplesRibcage =6;
cd('/home/sameig/codes')
addpath('/home/sameig/codes/ribFitting')
addpath('/home/sameig/codes/ribFitting/ribFitting/auxiliary');
addpath('/home/sameig/codes/ribFitting/ribFitting/')
addpath('/home/sameig/codes/ribFitting/prepareData/ ')
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

if part==1
    scale=1;

    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);
    LB=[ -20 -2 -20 , -0.4 , -0.4 , -0.4 ] ;
    UB=[ 20 10 20 , 0.4 , 0.4 , 0.4 ] ;
    
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
if part==2

    scale=1;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(2));

    load(resultPath{1},'T','cost');
    [~,b]=sort(cost);

    LB = [-5.0000   -5.0000   -5.0000   -0.2000   -0.2000   -0.2000  0 0 0];
    UB = [ 5.0000    5.0000    5.0000    0.2000    0.2000    0.2000  0 0 0];
    

    for h=b(1:nBest)
        
        tmp = reshape(ang_proj(h,:),4,[]);
        offsetVec = T(h,1:3);
        angles =  T(h,4:6);
        R1 = findEuler(angles);
        
        for r = settings.ribNumber
            
            ang_rec = tmp(r-6,:);
            R = findEuler(ang_rec(1),ang_rec(2),ang_rec(3),2);

            [a_1, a_2, a_3]=findEuler(R1*R);

            ribShapeParams = [compParams{1}(h,r-6) compParams{2}(h,r-6)  ] ;

            TTT= [  offsetVec+firstPts(:,r)' , a_1, a_2, a_3, ribShapeParams, lenProjected(h,r-6) ];
            [TT_(r,h,:), ribRes{h}{r}, cost_(r,h)] =  fitnessFunction3( TTT, ribShapeModel,heatMaps , settings,LB,UB);

        end

    end
 
    T=TT_;
    cost = cost_;
    save(resultPath{2},'T','cost','ribRes');

end
%%
if part==3
    
    load(resultPath{2},'T','cost','ribRes');
    [~, h ]= min(sum(cost,1));
    p = ribRes{h};
    figure;hold on;
    pp=[];

    for r = settings.ribNumber

        plot33(p{r},'b.',[1 3 2])
        plot33(ptsRibcage,'r.',[1 3 2])
        pp=[pp RR*p{r}];


    end
    
    axis equal
    writeVTKPolyDataPoints(resultPath{2},pp)
    
    for r = settings.ribNumber

        err_ribs(r,1)= computeErorr(p,ptsI,r,settings, settings.step,1,1);
        err_ribs(r,2)= computeErorr(p,ptsI,r,settings, settings.step,1,2);

    %         cost(h,r) = offsetCost(newData_{h}{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);

    end
    err_ribs
end