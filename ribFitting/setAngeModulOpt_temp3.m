

function mean_er = setAngeModulOpt_temp3(m,part1,inh)
if ~exist('inh','var')
inh=0;
end
settings.nSamplesRibcage =6;

loadAndPrepareData;

%%
scale  = 1;
scale2 = 1;

resultPath0 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma0,'%02d')  '_' num2str(m)];

resultPath1 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step1_sigma'  num2str(10*settings.hw_sigma(1),'%02d')  '_' num2str(m)];
resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step2_sigma'  num2str(10*settings.hw_sigma(2),'%02d')  '_' num2str(m)];
resultPath3 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step3_sigma'  num2str(10*settings.hw_sigma(3),'%02d')  '_' num2str(m)];
% resultPath2Old = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
if inh
    resultPath1 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
    resultPath2 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma(2),'%02d')  '_' num2str(m)];
end
if (m==59 || m==60 || m==550)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

subjectDataPaths{m}=[ dataPath num2str(m) '/ribs/'];


apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

%%

if part1==1
    
    load(resultPath0,'offsets','cost','firstPts');

    tmp_hw = settings.hw_s;
    settings.hw_s = settings.hw_s0;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);
    settings.hw_s = tmp_hw;
    
   

    options.ranges = ...
    [-20 20 
     -25 12 
     -25 12 
     0.8 1.3];
 
    options.step1 = 6;
    options.step2=0.1;
    
    ang0=zeros(1,5);
    ang0(4) = 1;
    ang0(5) = 1;

%     options0{1} = -6:2:6;
%     options0{2} = -6:2:6;
%     options0{3} = -6:2:6;
%     options0{4} = 1;
%     options0{5} = 0;

%     makeScaleChanges;
  
    offsets_inital = zeros(3,settings.ribNumber(end));

   
    offsets.ranges = ...
    [-3 3 
     -3 3 
     -3 3 ];
 
    offsets.step = 3;
    
%     offsets=[0;0;0];
    testPoints=1:settings.nPoints;
    for i=settings.ribNumber
        ptsI{i}=ptsI{i}/scale;
        tmp = ptsI{i};
        ptsI{i} = tmp(:,testPoints);
    end

    ptsRibcage=[];

    for r= settings.ribNumber
        ptsRibcage = [ptsRibcage ptsI{r}];
    end

    z_dif =  max([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);%-min([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);
    x_dif = max(ptsRibcage(1,:));%-min(ptsRibcage(1,:));
    
    settings.tolX = 5;

    for h=1:parameter_size

        for r= settings.ribNumber
            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        end

        [ang_tmp, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,settings.ribNumber,hypotheses,...
            offsets_inital,x_dif,z_dif,firstPts,ptsI,options,ang0,heatMaps,offsets,1,[]);%,[],[],options0);

        ang{h}(settings.ribNumber,:) = ang_tmp(settings.ribNumber,:);

    end

    save(resultPath1,'ang','cost','offset_indx','scale','scale2');

end

%%
if (part1<=2)

    nBest = 5;
    scale2=1;
    
    tmp_hw = settings.hw_s;
    settings.hw_s =[ 4 4 1];
    
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma1);
    settings.hw_s = tmp_hw;

    testPoints = 1:scale2:settings.nPoints;

    for i=settings.ribNumber
        ptsI{i}=ptsI{i}/scale;
        tmp = ptsI{i};
        ptsI{i} = tmp(:,testPoints);
    end

    ptsRibcage=[];

    for r= settings.ribNumber
        ptsRibcage = [ptsRibcage ptsI{r}];
    end

    z_dif = [];% max([ptsRibcage(3,:) firstPts(3,settings.ribNumber)])-min([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);
    x_dif = [];%max(ptsRibcage(1,:))-min(ptsRibcage(1,:));
    
    settings.tolX=5;   

    options{1} = -6:2:6;
    options{2} = -6:2:6;
    options{3} = -6:2:6;
    options{4} = 1;
    options{5} = 0;

    offsets.ranges = ...
    [-2 2 
     -2 2 
     -2 2];
 
    offsets.step = 2;
    
%     offsets=[0;0;0];

    load(resultPath1,'ang','cost','offset_indx','scale','scale2');
    
    scale2_2 = 1;
    runFittingSettings

    if (m==59 || m==60 || m==550)
        settings.ribNumber=8:10;
    else
        settings.ribNumber=7:10;
    end


    testPoints = 1:scale2_2:settings.nPoints;
    
    [~,b]=sort(mean(cost(:,settings.ribNumber),2));

    for h=b(1:nBest)'

        for r= settings.ribNumber

            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
            ang{h}(r,5) = ((ang{h}(r,5) -1) * scale2)+1;
            [tmp, cost(h,r), offset_indxNew(h,:,:)] =  optimzeAngleScalePos(settings,r,hypotheses,reshape(offset_indx(h,:,:),3,[])...
                ,x_dif,z_dif,firstPts,ptsI,options,ang{h}(r,:),heatMaps,offsets,1,[]);
            ang{h}(r,:)=tmp(r,:);
        end
    end

    scale2 = scale2_2;
    offset_indx=offset_indxNew;
    save(resultPath2,'ang','cost','offset_indx','scale','scale2');
end
%%
if (part1<=3)
    
    nBest = 1;
    scale2=1;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(2));
    testPoints = 1:scale2:settings.nPoints;


    z_dif=[];
    x_dif=[];

    options{1} = -3:0.5:3;
    options{2} = -3:0.5:3;
    options{3} = -3:0.5:3;
    options{4} =  0.95:0.02:1.05;
    options{5} =  0;



     offsets.ranges = ...
    [-1 1 
     -1 1 
     -1 1];
 
    offsets.step = 1;
    
    load(resultPath2,'ang','cost','offset_indx','scale','scale2');
    scale2_2 = 1;
    runFittingSettings
    
    if (m==59 || m==60 || m==550)
        settings.ribNumber=8:10;
    else
        settings.ribNumber=7:10;
    end

    testPoints = 1:scale2_2:settings.nPoints;

    [~,b]=sort(mean(cost(:,settings.ribNumber),2));

    for h=b(1:nBest)'

        for r= settings.ribNumber

            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
            ang{h}(r,5) = ((ang{h}(r,5) -1) * scale2)+1;
            [tmp, cost(h,r), offset_indxNew(h,:,:)] =  optimzeAngleScalePos(settings,r,hypotheses,reshape(offset_indx(h,:,:),3,[])...
                ,x_dif,z_dif,firstPts,ptsI,options,ang{h}(r,:),heatMaps,offsets,1,[]);
            ang{h}(r,:)=tmp(r,:);
        end

    end

    scale2 = scale2_2;
    offset_indx=offset_indxNew;
    save(resultPath3,'ang','cost','offset_indx','scale','scale2');
end


