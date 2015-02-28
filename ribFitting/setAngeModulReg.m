

% function setAngeModulReg(m,part1)
m=63;
part1=true;
loadAndPrepareData;

scale  = 1;
scale2 = 3;

resultPath1 = [rootPath 'Ribs/ang_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
resultPath2 = [rootPath 'Ribs/ang_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end




heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma1);



%%

options{1} = -20:5:20;
options{2} = -25:5:10;
options{3} = -25:5:10;
options{4} =  0.8:0.1:1.2;
options{5} =  -7:4;


ang0=zeros(1,5);
ang0(5) = settings.startP;

makeScaleChanges;


% for i=settings.ribNumber
%     ptsI{i}=ptsI{i}/scale;
%     tmp = ptsI{i};
%     ptsI{i} = tmp(:,testPoints);
% end

% ptsRibcage=[];
% for r= settings.ribNumber
%     ptsRibcage = [ptsRibcage ptsI{r}];
% end

% z_dif =  max([ptsRibcage(3,:) firstPts(3,settings.ribNumber)])-min([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);
% x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));

offsets_inital = zeros(3,settings.ribNumber(end));

k=0;
for bit1 =[-1 0 1 ]
    for bit2 =[-1 0 1 ]
        for bit3 =[-1 0 1 ]
            k=k+1;
            offsets(:,k)=[bit1 ;bit2 ;bit3];
        end
    end
end

offsets=[0;0;0];

%%
z_dif=[];
x_dif=[];

[ribsGroundTruth, rib_nos] = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightExhNew');

    for h=1:parameter_size
    
        for r=settings.ribNumber
            hypotheses{r} = hyps{r}(:,:,h);
        end

        [ang_tmp, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,settings.ribNumber,hypotheses,...
            offsets_inital,x_dif,z_dif,ang_rec(:,:,h),firstPts,ptsI,options,ang0,imExh,offsets,3,imInh,ribsGroundTruth);

        ang{h}(settings.ribNumber,:) = ang_tmp;


    end
save(resultPath1,'ang','cost','offset_indx','scale','scale2');



