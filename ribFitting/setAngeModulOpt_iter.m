

function mean_er = setAngeModulOpt_iter(m,part1,inh)
if ~exist('inh','var')
inh=0;
end
settings.nSamplesRibcage =6;

loadAndPrepareData;

%%
scale  = 1;
scale2 = 1;

resultPath0 = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma0,'%02d')  '_' num2str(m)];

for i=1:3
    resultPath{i} = [rootPath 'Ribs/res_wofirstP_'  '_step' num2str(i) '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)];
end
% resultPath{2} = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step'2'_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
% resultPath{3} = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step'3'_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
% resultPath2Old = [rootPath 'Ribs/ang_' 'scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
if inh
    resultPath1 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m)];
    resultPath2 = [rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m)];
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

offsets_inital = zeros(3,settings.ribNumber(end));
settings.tolX = 5;
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


load(resultPath0,'offsets','cost','firstPts');

z_dif =  max([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);%-min([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);
x_dif = max(ptsRibcage(1,:));%-min(ptsRibcage(1,:));
nBest = 5;   

ang0=zeros(1,5);
ang0(4) = 1;
ang0(5) = 1;

if (m==59 || m==60 || m==550)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end
    
%% First run    
    options{1}.ranges = ...
    [-20 20 
     -25 12 
     -25 12 
     0.8 1.2
     0 0];
 
    options{1}.step1 = 6;
    options{1}.step2 = 0.1;
    options{1}.step3=1;
 
    offsets.ranges = ...
    [-3 3 
     -3 3 
     -3 3 ];
 
    offsets.step = 3;
    
  %% Second Run  
  
  
     options{2}.ranges = ...
    [-6 6 
     -6 6 
     -6 6 
     0.95 1.05
     0 0];
 
    options{2}.step1 = 2;
    options{2}.step2 = 0.02;
    options{2}.step3 = 1;
    
    
    %% Third Run
      options{3}.ranges = ...
    [-3 3 
     -3 3  
     -3 3  
     1 1
     0 0];

    options{3}.step1 = 0.5;
    options{3}.step2 = 0.02;
    options{3}.step3 = 1;


%%

if part1==1
    
   
    heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma0);
  
    for h=1:parameter_size

        for r= settings.ribNumber
            hypotheses{r} = hyps{r}(:,testPoints,h)/scale;
        end

        [ang_tmp, cost(h,settings.ribNumber), offset_indx(h,:,:)] =  optimzeAngleScalePos(settings,settings.ribNumber,hypotheses,...
            offsets_inital,x_dif,z_dif,firstPts,ptsI,options{1},ang0,heatMaps,offsets,1,[]);%,[],[],options0);

        ang{h}(settings.ribNumber,:) = ang_tmp(settings.ribNumber,:);

    end

    save(resultPath{1},'ang','cost','offset_indx');

end

%%

    z_dif=[];
    x_dif=[];


%%
for part=2:3    

    offsets.ranges =ceil(offsets.ranges /2);
    offsets.step = ceil(offsets.step /2);
    
   heatMaps = loadAllHeatMaps(heatMapPathRule,m,postFix,scale,im_size_path,settings,settings.hw_sigma(part));

   load(resultPath{part-1},'ang','cost','offset_indx');
    

   [~,b]=sort(mean(cost(:,settings.ribNumber),2));
    clear offset_indxNew;
    for h=b(1:nBest)'

        for r= settings.ribNumber

            hypotheses{r} = hyps{r}(:,:,h);
            [tmp, cost(h,r), offset_indxNew(h,:,:)] =  optimzeAngleScalePos(settings,r,hypotheses,reshape(offset_indx(h,:,:),3,[])...
                ,x_dif,z_dif,firstPts,ptsI,options{part},ang{h}(r,:),heatMaps,offsets,1,[]);
            ang{h}(r,:)=tmp(r,:);
        end

    end

    offset_indx=offset_indxNew;
    save(resultPath{part},'ang','cost','offset_indx');
end


