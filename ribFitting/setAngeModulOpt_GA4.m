

function err_ribs = setAngeModulOpt_GA4(m,part,r_p)


if (~exist('r_p','var'))
    r_p=0;
end

cd('/home/sameig/codes');
addpath('/home/sameig/codes/ribFitting');
addpath('/home/sameig/codes/ribFitting/ribFitting/auxiliary');
addpath('/home/sameig/codes/ribFitting/ribFitting/');
addpath('/home/sameig/codes/ribFitting/prepareData/ ');
loadAndPrepareDataForGA;

%%

for i=1:3
    resultPath{i} = [rootPath 'Ribs/res_GA_4_' num2str(i) '_' num2str(m)];
end

if (m==59 || m==60 || m==550)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end



apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];


ptsRibcage=[];

for r= settings.ribNumber
    ptsRibcage = [ptsRibcage ptsI{r}];
end


if (m==59 || m==60 || m==550)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end
    

 RR = [
apMRI;
isMRI
lrMRI];
   
% settings.nStd = 3;
%%

if part==1
    scale=1;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(1));

    bounds =ones(1, settings.nCompsRibcage );
%     bounds = [ bounds 20 10 20 ];
    LB = [- bounds -20 -2 -20];
    UB = [  bounds 20 10 20 ];
    [T, ribs,cost] =  fitnessFunctionAllribs4(LB,UB, firstPts(:,settings.ribNumber)', ribcageModel,ribShapeModel,heatMaps , settings);
    
    ribRes(settings.ribNumber) = ribs;
    
    save(resultPath{1},'T','cost','ribRes');
end
%%
if part==2
    
    
    scale=1
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(1));
    load(resultPath{1},'T','cost','ribRes')
    
    LB = T(1:6) ;+ [-0.1*ones(1, settings.nCompsRibcage ) ];
    UB = T(1:6) ;+ [0.1*ones(1, settings.nCompsRibcage ) ];
    
    LB1 =T(7:9)- 10 *ones(1,3);
    UB1 =T(7:9)+ 10 *ones(1,3);
     
%     LB1 = -[20 10 20];
%     UB1 = [20 10 20];
    xTol = 10;
    yTol = 10;
    zTol = 10;
    b = [xTol * ones(6,1) ; yTol * ones(6,1) ;zTol * ones(6,1)];

    [TT, ribs,cost] =  fitnessFunctionAllribs5(LB,UB, LB1,UB1,b,firstPts(:,settings.ribNumber)', ribcageModel,ribShapeModel,heatMaps , settings);

    ribRes(settings.ribNumber) = ribs;
    T =TT;
    save(resultPath{2},'T','cost','ribRes');
end
%%
if part==3
    scale=1
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(3));
    load(resultPath{2},'T','cost','ribRes');
    
    LB = [(T(1:6) - 0.2*ones(1, settings.nCompsRibcage )) -4 -4 -4];
    UB = [(T(1:6) + 0.2*ones(1, settings.nCompsRibcage ))  4  4  4];
    
    frstP =[ firstPts(:,settings.ribNumber) + reshape(T(7:end),3,[])]';
    [T, ribs,cost] =  fitnessFunctionAllribs4(LB,UB, frstP, ribcageModel,ribShapeModel,heatMaps , settings);
    ribRes(settings.ribNumber) = ribs;

    save(resultPath{3},'T','cost','ribRes');

end


%%
if part==4
    
    load(resultPath{r_p},'T','cost','ribRes');
    p = ribRes;
    figure;hold on;
    pp=[];

    for r = settings.ribNumber

        plot33(p{r},'b.',[1 3 2])
        plot33(ptsRibcage,'r.',[1 3 2])

        err_ribs(r,1)= computeErorr(p,ptsI,r,settings, settings.step,1,1);
        err_ribs(r,2)= computeErorr(p,ptsI,r,settings, settings.step,1,2);

    end
    axis equal
    writeVTKPolyDataPoints(resultPath{3},pp)

    err_ribs
end