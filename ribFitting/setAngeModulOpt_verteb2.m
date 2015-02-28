

function mean_er = setAngeModulOpt_verteb2(m,part1,inh)
if ~exist('inh','var')
inh=0;
end
settings.nSamplesRibcage=6;
loadAndPrepareData;
addpath('/home/sameig/codes/vertebrae/')

%%
scale  = 1;
scale2 = 3;
    settings.hw_sigma0=3;

resultPath0 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma0,'%02d')  '_' num2str(m)];
resultPath1 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_verteb1_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_verteb2_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
resultPath3 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_verteb3_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

if inh
    resultPath1 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
    resultPath2 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
end
if (m==59 )%(m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

subjectDataPaths{m}=[ dataPath num2str(m) '/ribs/'];
meanVectorPath = [rootPath 'Ribs/meanVectorVertebra'];

apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];
%%

if part1==0
    
    settings.nSamplesRibcage = 5;

    paramset = generateUniformSamples(allmodels.ribcageModel,settings);

    [compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
    parameter_size =  size(ang_proj,1);
    hyps = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts, settings);

    scale  = 1;
    scale2 = 1;
    settings.hw_s=[5 5 1];

    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);

    options{1} = -20:7:20;
    options{2} = -25:7:10;
    options{3} = -25:7:10;
    options{4} =  1;%
    options{5} =  0;%-7:4;

    ang0=zeros(1,5);
    ang0(4) = 1;
    ang0(5) = 1;

    makeScaleChanges;

    offsets_inital = zeros(3,settings.ribNumber(end));

    k=0;
    
      offsets.ranges = ...
    [-9 9 
     -4 4 
     -9 9];
 
    offsets.step = 3;
    
   
    z_dif=[];
    x_dif=[];
%     offsets=[0;0;0];

    vertebCenters = displayResultsVertebra(m,0,numVerteb(m));
%     vertebCenters(:,2) = size(heatMaps{1},2) - vertebCenters(:,2);
    vertebCenters = transCoord(vertebCenters',apMRI,isMRI,lrMRI);

	firstPts_ =firstPts;
    clear firstPts;
    load(meanVectorPath,'meanVector')
    offset_verteb2 = 6;
    offset_verteb1 = 6;

    if (m==59 )
        offset_verteb1=8;
    end
    
    if (m==56)
        offset_verteb1=5;
    end

    firstPts(:,settings.ribNumber) =  meanVector(:,settings.ribNumber-offset_verteb2) + vertebCenters(:,settings.ribNumber-offset_verteb1);

%     firstPts(:,settings.ribNumber) =  meanVector + vertebCenters(:,1+offVert(m):length(settings.ribNumber)+offVert(m));
    clear offset_;
    
    for h=1:parameter_size

        for r= settings.ribNumber
            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        end

%         [offset_tmp, cost(h,settings.ribNumber)]=  optimzePos(settings,settings.ribNumber,hypotheses,...
%         offsets_inital,firstPts,options,ang0,heatMaps,offsets);
        [~, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePosVerteb(settings,settings.ribNumber,hypotheses,...
            offsets_inital,firstPts,options,ang0,heatMaps,offsets);
        offset_{h} = squeeze(offset_indx(h,:,:));
%         figure;
%         for r= settings.ribNumber
%             hold on;
%             tmp = displayAngles(settings,hypotheses,ang_tmp(r-6,:),firstPts,ptsI,r,ang_tmp(r-6,5),offset_{h},true);
%         end
%         axis equal
    end
    
    
    [~,b]=min(sum(cost,2));
    firstPts = firstPts + offset_{b};

    save(resultPath0,'offsets','cost','firstPts');
firstPtsT = transCoord(firstPts,apMRI,isMRI,lrMRI);
 
    writeVTKPolyDataPoints([subjectDataPaths{m} 'firstPts'],firstPtsT)
end
%%

if part1==1
    
    tmp_hw = settings.hw_s;
    settings.hw_s = settings.hw_s0;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);
    settings.hw_s = tmp_hw;
    
    options{1} = -20:6:20;
    options{2} = -25:6:10;
    options{3} = -25:6:10;
    options{4} =  0.8:0.1:1.2;
    options{5} =  0;

    ang0=zeros(1,5);
    ang0(4) = 1;
    ang0(5) = 1;

    makeScaleChanges;
  
    offsets_inital = zeros(3,settings.ribNumber(end));

    k=0;
    for bit1 =3*[-1 0 1 ]
        for bit2 =3*[-1 0 1 ]
            for bit3 =3*[-1 0 1 ]
                k=k+1;
                offsets(:,k)=[bit1 ;bit2 ;bit3];
            end
        end
    end

    
    for i=settings.ribNumber
        ptsI{i}=ptsI{i}/scale;
        tmp = ptsI{i};
        ptsI{i} = tmp(:,testPoints);
    end

    ptsRibcage=[];

    for r= settings.ribNumber
        ptsRibcage = [ptsRibcage ptsI{r}];
    end

    z_dif =  max([ptsRibcage(3,:) firstPts(3,settings.ribNumber)])-min([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);
    x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));
    
    settings.tolX=10;
    
    options0{1} = -6:2:6;
    options0{2} = -6:2:6;
    options0{3} = -6:2:6;
    options0{4} = 1;
    options0{5} = 0;
        
        
    for h=1:parameter_size

        for r= settings.ribNumber
            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        end

        [ang_tmp, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,settings.ribNumber,hypotheses,...
            offsets_inital,x_dif,z_dif,firstPts,ptsI,options,ang0,heatMaps,offsets,1,[],[],options0);

        ang{h}(settings.ribNumber,:) = ang_tmp(settings.ribNumber,:);

    end

    save(resultPath1,'ang','cost','offset_indx','scale','scale2');

end

%%
if (part1>0 && part1<=2)

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

    offsets=[0;0;0];

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
if (part1>0 && part1<=3)
    
    nBest = 1;
    scale2=1;
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma2);
    testPoints = 1:scale2:settings.nPoints;


    z_dif=[];
    x_dif=[];

    options{1} = -2:0.5:2;
    options{2} = -2:0.5:2;
    options{3} = -2:0.5:2;
    options{4} =  0.98:0.02:1.02;
    options{5} =  0;

    k=0;
    for bit1 =[-1 0 1 ]
        for bit2 =[-1 0 1 ]
            for bit3 =[-1 0 1 ]
                k=k+1;
                offsets(:,k)=[bit1 ;bit2 ;bit3];
            end
        end
    end

    load(resultPath2,'ang','cost','offset_indx','scale','scale2');
    scale2_2 = 1;
    runFittingSettings

    if ( m==59  || m==60)
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


