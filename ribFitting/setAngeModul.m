

function setAngeModul(m,part1,inh)

loadAndPrepareData;

%%
scale  = 1;
scale2 = 3;

   
resultPath1 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

if exist('inh','var')
    resultPath1 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
    resultPath2 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
end
if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end


%%

if part1

    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma1);
    
    options{1} = -20:5:20;
    options{2} = -25:5:10;
    options{3} = -25:5:10;
    options{4} =  0.8:0.1:1.2;
    options{5} =  -7:4;

    ang0=zeros(1,5);
    ang0(4) = 1;
    ang0(5) = settings.startP;

    makeScaleChanges;

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

    offsets_inital = zeros(3,settings.ribNumber(end));

    k=0;
    for bit1 =2*[-1 0 1 ]
        for bit2 =2*[-1 0 1 ]
            for bit3 =2*[-1 0 1 ]
                k=k+1;
                offsets(:,k)=[bit1 ;bit2 ;bit3];
            end
        end
    end

    offsets=[0;0;0];

%     z_dif=[];
%     x_dif=[];

    for h=1:parameter_size

        for r= settings.ribNumber
            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        end

        [ang_tmp, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,settings.ribNumber,hypotheses,...
            offsets_inital,x_dif,z_dif,firstPts,ptsI,options,ang0,heatMaps,offsets,1,[]);

        ang{h}(settings.ribNumber,:) = ang_tmp;

    end

    save(resultPath1,'ang','cost','offset_indx','scale','scale2');

end

%%

nBest = 5;

heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma2);

z_dif=[];
x_dif=[];

options{1} = -5:5;
options{2} = -5:5;
options{3} = -5:5;
options{4} =  1;
options{5} =  -2:2;

k=0;
for bit1 =[-1 0 1 ]
    for bit2 =[-1 0 1 ]
        for bit3 =[-1 0 1 ]
            k=k+1;
            offsets(:,k)=[bit1 ;bit2 ;bit3];
        end
    end
end

% offsets=[0;0;0];
    
load(resultPath1,'ang','cost','offset_indx','scale','scale2');
scale2_2 = 1;
runFittingSettings

if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

% makeScaleChanges;
testPoints = 1:scale2_2:settings.nPoints;

% offsets_inital = zeros(3,settings.ribNumber(end));

[~,b]=sort(mean(cost(:,settings.ribNumber),2));

for h=b(1:nBest)'
    
    for r= settings.ribNumber
        
        hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        ang{h}(r,5) = ((ang{h}(r,5) -1) * scale2)+1;
        [angNew{h}(r,:), cost(h,r), offset_indxNew(h,:,:)] =  optimzeAngleScalePos(settings,r,hypotheses,reshape(offset_indx(h,:,:),3,[])...
            ,x_dif,z_dif,firstPts,ptsI,options,ang{h}(r,:),heatMaps,offsets,1,[]);

    end
    ang{h}=angNew{h};
end

scale2 = scale2_2;
offset_indx=offset_indxNew;
save(resultPath2,'ang','cost','offset_indx','scale','scale2');

