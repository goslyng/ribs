

function mean_er = setAngeModulOpt_temp(m,part1,inh)
if ~exist('inh','var')
inh=0;
end
loadAndPrepareData;

%%
scale  = 1;
scale2 = 3;

   
resultPath1 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
if inh
    resultPath1 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
    resultPath2 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
end
if (m==59 || m==60)
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

    z_dif=[];
    x_dif=[];

    for h=1:parameter_size

        for r= settings.ribNumber
            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        end

        [ang_tmp, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,settings.ribNumber,hypotheses,...
            offsets_inital,x_dif,z_dif,firstPts,ptsI,options,ang0,heatMaps,offsets,1,[]);

        ang{h}(settings.ribNumber,:) = ang_tmp(settings.ribNumber,:);

    end

    save(resultPath1,'ang','cost','offset_indx','scale','scale2');

end

%%
if (part1<=2)
nBest = 1;
scale2=1;
heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma2);
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

    z_dif =  max([ptsRibcage(3,:) firstPts(3,settings.ribNumber)])-min([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);
    x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));
% z_dif=[];
% x_dif=[];

options{1} = -5:0.5:5;
options{2} = -5:0.5:5;
options{3} = -5:0.5:5;
options{4} =  0.9:0.1:1.1;
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
        angNew{h}(r,:)=tmp(r,:);
    end
    ang{h}=angNew{h};
end

scale2 = scale2_2;
offset_indx=offset_indxNew;
save(resultPath2,'ang','cost','offset_indx','scale','scale2');
end
%%
nBest=5;
testRibs=7:10;
if (m==59 )%|| m==60
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end
heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma2);

load(resultPath2,'ang','cost','offset_indx','scale','scale2');
[~,b]=sort(mean(cost(:,settings.ribNumber),2));

for h=b(1:nBest)'
    ang_rec(:,testRibs)=reshape(ang_proj(h,:),length(testRibs),[])';
    
    for r = settings.ribNumber
        cost(h,r)

    hypotheses{r}= hyps{r}(:,:,h)/scale;
    rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);          
    offset=reshape(offset_indx(h,:,r),3,1);
    offsets = reshape(offset_indx(h,:,:),3,[]);

    compParams_(1,1) = compParams{1}(h,r-7+1);
    compParams_(1,2) = compParams{2}(h,r-7+1);
    startP =  ang{h}(r,5);
    
    leng = lenProjected(h,r-7+1)*ang{h}(r,4);
    % err = optimizeShapeAngleLength(ang0, leng,compParams_, firstPts(:,r), startP, ribShapeModel,rot_mat,offset,heatMaps,settings);

    
        
    tmp = displayAngles(settings,hypotheses,ang{h}(r,:),firstPts,ptsI,r,ang{h}(r,5),offsets,true);
    newData_{h}{r} = tmp{r};
    err_ribs(h,r)= computeErorr(newData_{h},ptsI,r,settings,settings.step,ang{h}(r,5));
        
    params = [ang{h}(r,1:3) leng*ang{h}(r,4) ang{h}(r,5) compParams_ 0];
   
    models.hyps = hyps{r}(:,:,h)/scale;
    models.offset = offset;
    models.heatMaps= heatMaps;
    models.settings = settings;
    models.firstPoint = firstPts(:,r);
    models.ribShapeModel = ribShapeModel;
    models.rot_mat = rot_mat;

   
    
    lowerBounds =[ params(1:3) params(4)*0.9 params(5) params(6)-ribShapeModel.stdDev(1) params(7)-ribShapeModel.stdDev(2) params(8)-ribShapeModel.stdDev(3)] ;
    upperBounds =[ params(1:3) params(4)*1.1 params(5) params(6)+ribShapeModel.stdDev(1) params(7)+ribShapeModel.stdDev(2) params(8)+ribShapeModel.stdDev(3)] ;

%     [er_ hy_]=optimizeShapeAngleLengthWrapper(params,models);
    
    options = optimset('TolFun',1e-8);
    [params, ~] = fminsearchbnd(@(param) optimizeShapeAngleLengthWrapper(param,models),params,lowerBounds, upperBounds,options);

    lowerBounds =[ params(1)-10 params(2)-10 params(3)-10  params(4:end)] ;
    upperBounds =[ params(1)+10 params(2)+10 params(3)+10  params(4:end)];

    [params_(r,:,h), cost_(r,h)] = fminsearchbnd(@(param) optimizeShapeAngleLengthWrapper(param,models),params,lowerBounds, upperBounds,options);


    end
end
ptsAll=[];
[~,h]=min(mean(cost_(settings.ribNumber,:)));
for r= settings.ribNumber
        ang_rec(:,testRibs)=reshape(ang_proj(h,:),length(testRibs),[])';

    rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);          
    offset=reshape(offset_indx(h,:,r),3,1);
    
    models.hyps = hyps{r}(:,:,h)/scale;
    models.offset = offset;
    models.heatMaps= heatMaps;
    models.settings = settings;
    models.firstPoint = firstPts(:,r);
    models.ribShapeModel = ribShapeModel;
    models.rot_mat = rot_mat;

    [er_(r), newData{r}]=optimizeShapeAngleLengthWrapper(params_(r,:,h),models);

    figure(100);
    plot33(newData{r},'g.',[1 3 2])
    hold on
    plot33(ptsI{r},'b.',[1 3 2])
    axis equal
    ribFileName = [subjectDataPaths{m} 'RibFittedRight' num2str(r)];
    pts_ = transCoord(newData{r},apMRI,isMRI,lrMRI);
    writeVTKPolyDataPoints(ribFileName, pts_);
    ptsAll=[ptsAll pts_];
    err_ribs(r)= computeErorr(newData,ptsI,r,settings,settings.step,ang{h}(r,5));

end
ribFileName = [subjectDataPaths{m} 'RibFittedRightAll'];
err_ribs
er_
mean_er = mean(err_ribs(settings.ribNumber))
writeVTKPolyDataPoints(ribFileName, ptsAll);    
    
    
%     [params_(n,:), cost(n)] = fminsearch(@(param) paramToCostWrapper(param,models),params(n,:));
  

