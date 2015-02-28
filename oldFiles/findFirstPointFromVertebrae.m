

function firstPts = findFirstPointFromVertebrae(m)

settings.nSamplesRibcage = 4;
inh=0;
loadAndPrepareData;

%%
scale  = 1;

resultPath0 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma0,'%02d')  '_' num2str(m)];

if (m==59  || m==60 || m==550)
    settings.ribNumber=8:10;
    
else
    settings.ribNumber=7:10;
end

subjectDataPaths{m}=[ dataPath num2str(m) '/ribs/'];
meanVectorPath = [rootPath 'Ribs/meanVectorVertebra'];

apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

addpath('/home/sameig/codes/vertebrae')
%%
    
    settings.nSamplesRibcage = 1;

    paramset = generateUniformSamples(allmodels.ribcageModel,settings);

    [compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
    parameter_size =  size(ang_proj,1);
    hyps = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts, settings);

    scale  = 1;
%     settings.hw_s=[5 5 1];

    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);

    options{1} = -20:7:20;
    options{2} = -25:7:10;
    options{3} = -25:7:10;
    options{4} =  1;
    options{5} =  0;
    
    ang0=zeros(1,5);
    ang0(4) = 1;
    ang0(5) = 1;

    makeScaleChanges;

    
    offsets_inital = zeros(3,settings.ribNumber(end));

    k=0;
    for bit1 = 2*[-3:3]
        for bit2 =3*[-1:1]
            for bit3 =2*[-3:3]
                k=k+1;
                offsets(:,k)=[bit1 ;bit2 ;bit3];
            end
        end
    end

    vertebCenters = displayResultsVertebra(m,0,numVerteb(m));
%     vertebCenters(:,2) = size(heatMaps{1},2) - vertebCenters(:,2);
    vertebCenters = transCoord(vertebCenters',apMRI,isMRI,lrMRI);

	firstPts_ =firstPts;
    clear firstPts;
    load(meanVectorPath,'meanVector');

    offset_verteb2 = 6;
    offset_verteb1 = 6;

    if (m==59 )
        offset_verteb1=7;
    end
    
    if (m==56)
        offset_verteb1=5;
    end

    firstPts(:,settings.ribNumber) =  meanVector(:,settings.ribNumber-offset_verteb2) + vertebCenters(:,settings.ribNumber-offset_verteb1);
    clear offset_;
    for h=1:parameter_size

        for r= settings.ribNumber
            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        end

             [ang_tmp, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePosVerteb(settings,settings.ribNumber,hypotheses,...
            offsets_inital,firstPts,options,ang0,heatMaps,offsets);

        offset_{h} = squeeze(offset_indx(h,:,:));

    end
    
    [~,b]=min(sum(cost,2));
    firstPts = firstPts + offset_{b};

    save(resultPath0,'offsets','cost','firstPts');
    firstPtsT = transCoord(firstPts,apMRI,isMRI,lrMRI);
 
    writeVTKPolyDataPoints([subjectDataPaths{m} 'firstPts'],firstPtsT)



