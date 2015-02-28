

function  setAngeModulOptInh(m)

inh=1;
loadAndPrepareData;

%%
scale  = 1;
scale2 = 3;

   
% resultPath1 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
% resultPath2 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

% if exist('inh','var')
    resultPath1 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
    resultPath2 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

    resultPathExh = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];

% end
if (m==59 )%(m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

subjectDataPaths{m}=[ dataPath num2str(m) '/ribs/'];


apMRI=[-1  0  0];
isMRI=[ 0  1  0];
lrMRI=[ 0  0 -1];

%%
    
heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma1);
    
z_dif=[];
x_dif=[];

options{1} = -16:2:16;
options{2} = -16:2:16;
options{3} = -16:2:16;
options{4} =  1;
options{5} =  0;


offsets=[0;0;0];
    
load(resultPathExh,'ang','cost','offset_indx','scale','scale2');
runFittingSettings

if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

[~,h]=min(mean(cost(:,settings.ribNumber),2));

for r= settings.ribNumber

    hypotheses{r} = hyps{r}(:,:,h);
end
% offsets_inital = zeros(3,settings.ribNumber(end));
ang{h}(r,5) = ((ang{h}(r,5) -1) * scale2)+1;

tmp = settings.hw_s;
settings.hw_s = settings.hw_s0;
heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);
settings.hw_s =tmp;


for r= settings.ribNumber
    
    [t1, ~, t3] =findOptimalAngleScale(settings,r,hypotheses,...
        reshape(offset_indx(h,:,:),3,[]),x_dif,z_dif,firstPts,ptsI,options,ang{h}(r,:),heatMaps,offsets,1,[]);
    
    
%     [tmp, costInh(h,r), offset_indxInh(h,:,:)] =  optimzeAngleScalePos(settings,r,hypotheses,reshape(offset_indx(h,:,:),3,[])...
%         ,x_dif,z_dif,firstPts,ptsI,options,ang_tmp(r,:),heatMaps,offsets,1,[]);
    ang_tmp(r,:) = t1(r,:);
%     costInh(h,r) = t2(r);
    offset_indxInh(h,:,r) = t3(:,r);

end

% % [ang_tmp, ~, offset_indxInh(h,:,:)]= findOptimalAngleScale(settings,settings.ribNumber,hypotheses,...
% %         reshape(offset_indx(h,:,:),3,[]),x_dif,z_dif,firstPts,ptsI,options,ang{h},heatMaps,offsets,1,[]);
options{1} = -4:0.5:4;
options{2} = -4:0.5:4;
options{3} = -4:0.5:4;

heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma2);

for r= settings.ribNumber
    
    [t1, t2, t3] =findOptimalAngleScale(settings,r,hypotheses,...
        reshape(offset_indx(h,:,:),3,[]),x_dif,z_dif,firstPts,ptsI,options,ang_tmp(r,:),heatMaps,offsets,1,[]);
    
    
%     [tmp, costInh(h,r), offset_indxInh(h,:,:)] =  optimzeAngleScalePos(settings,r,hypotheses,reshape(offset_indx(h,:,:),3,[])...
%         ,x_dif,z_dif,firstPts,ptsI,options,ang_tmp(r,:),heatMaps,offsets,1,[]);
    angInh{h}(r,:) = t1(r,:);
    costInh(h,r) = t2(r);
    offset_indxInh(h,:,r) = t3(:,r);

end
    
scale2 = 1;
offset_indx=offset_indxInh;
cost = costInh;
ang = angInh;

save(resultPath2,'ang','cost','offset_indx','scale','scale2');

 