

function err_ribs = setAngeModulOpt_GA9(m,part,r_p)


if (~exist('r_p','var'))
    r_p=0;
end
inh=0;
if isunix
    codePath = '/home/sameig/';
else
    codePath = 'H:\';
end
cd([codePath 'codes']);
addpath([codePath 'codes/ribFitting']);
addpath([codePath 'codes/ribFitting/ribFitting/auxiliary']);
addpath([codePath 'codes/ribFitting/ribFitting/']);
addpath([codePath 'codes/ribFitting/prepareData/']);
loadAndPrepareDataForGA;

%%

for i=1:3
    resultPath{i} = [rootPath 'Ribs/res_GA_9_' num2str(i) '_' num2str(m)];
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
       settings.nCompsRibcage = 5;
    settings.nCompsAngle = 4;
% settings.nStd = 3;
%%
% allmodels.mrAngleModel = MRangleModel;
% allmodels.ribcageWOAngleModel = ribcageWOAngleModel;

if part==1
    
    scale=1;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(1));
    settings.nCompsRibcage = 5;
    settings.nCompsAngle = 4;
    
    bounds =ones(1, settings.nCompsRibcage +  settings.nCompsAngle);

    LB = [-bounds -20 -2 -20];
    UB = [ bounds  20 10  20];
    
    settings.nStd = 3;
    
    [T, ribs,cost] =  fitnessFunctionAllribs6(LB,UB, firstPts(:,settings.ribNumber)', ribcageWOAngleModel,ribShapeModel,MRangleModel,heatMaps , settings);
    
    ribRes(settings.ribNumber) = ribs;
    
    save(resultPath{1},'T','cost','ribRes');
end

%%
if part==2

    scale=1
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(3));
    load(resultPath{1},'T','cost','ribRes');
    
    settings.nStd = 2;
    settings.nCompsRibcage = 5;
    settings.nCompsAngle =settings.nCompsAngle + 4 ;
    
    bounds =[ zeros(1, settings.nCompsRibcage ) ones(1,settings.nCompsAngle) 4 4 4 ];
    T_ext = [T(1:end-3) zeros(1,4) T(end-2:end)];
    LB = -bounds + T_ext;
    UB =  bounds + T_ext;
    
    [T, ribs,cost] =  fitnessFunctionAllribs6(LB,UB, firstPts(:,settings.ribNumber)', ribcageWOAngleModel,ribShapeModel,MRangleModel,heatMaps , settings);
   
    ribRes(settings.ribNumber) = ribs;

    save(resultPath{2},'T','cost','ribRes');

end
%%

if part==3
    scale=1;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(3));
    load(resultPath{2},'T','cost','ribRes');
      
    [ang_proj, ribShapeParams, lenProjected]=ribParamsFromRibcageParams(T,ribcageWOAngleModel,MRangleModel,settings);

    
    settings.nCompsRibcage = 5;
    settings.nCompsAngle = 8;

    bounds = [0.1 0.1 0.1 3 3 3 ];
    LB = -bounds ;
    UB =  bounds ;
    for r=1:4
        [TT(r,:), ribs{r},cost] =  fitnessFunction4(LB,UB, firstPts(:,settings.ribNumber(r)), T(end-2:end),ang_proj(r,:),ribShapeParams(r,:),lenProjected(r), ribShapeModel,heatMaps , settings);
    end
    
    ribRes(settings.ribNumber) = ribs;

    save(resultPath{3},'TT','cost','ribRes');
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
        pp=[pp RR*p{r}];

        err_ribs(r,1)= computeErorr(p,ptsI,r,settings, settings.step,1,1);
        err_ribs(r,2)= computeErorr(p,ptsI,r,settings, settings.step,1,2);
        writeVTKPolyDataPoints([resultPath{3} '_r' num2str(r)],RR*p{r})
    end
    axis equal
    writeVTKPolyDataPoints(resultPath{3},pp)

    err_ribs
end