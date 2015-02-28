

function setAngeModulNccCycles(m,cycle,compute)


loadAndPrepareData;

load([dataPath  num2str(m) '/allcycles_nrig10_masked.mat']);
state = cycleinfo.peaks(cycle);

resultPath = [rootPath 'Ribs/ang_reg_bh_' num2str(m) '_' num2str(cycle)  '_' num2str(state) ];

scale  = 1;
scale2 = 1;

if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end


%%

options{1} = -5:5;
options{2} = -5:5;
options{3} = -5:5;
options{4} =  1;
options{5} =  0;


ang0=zeros(1,5);
ang0(4) = 1;
ang0(5) = 1;

makeScaleChanges;

%%

z_dif=[];
x_dif=[];

a = load([dataPath num2str(m)  '/masterframes/resized_exhMaster7_unmasked_uncropped.mat']);
% b = load([dataPath num2str(m) '/masterframes/resized_inhMaster7_unmasked_uncropped.mat']);

imagePathExh = [dataPath num2str(m) '/stacks/original_5_cyc_' num2str(cycle) '_' num2str(1) '.mat'];
savePathExh  = [dataPath num2str(m) '/stacks/resized_original_5_cyc_' num2str(cycle) '_' num2str(1) '.mat'];


imagePathInh = [dataPath num2str(m) '/stacks/original_5_cyc_' num2str(cycle) '_' num2str(state) '.mat'];
savePathInh  = [dataPath num2str(m) '/stacks/resized_original_5_cyc_' num2str(cycle) '_' num2str(state) '.mat'];

try
    a = load(savePathExh);
    
catch
    
    resize_images_hdr_path(m,imagePathExh,savePathExh);
    a = load(savePathExh);

end

try
    b = load(savePathInh);
    
catch
    
    resize_images_hdr_path(m,imagePathInh,savePathInh);
    b = load(savePathInh);

end

imExh = a.im;
imInh = b.im;

% ribsGroundTruth = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightExhNew');
ribsGroundTruth = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibFittedRight');

ribsInhGroundTruth=[];

for i=settings.ribNumber
    ribsGroundTruth{i}=ribsGroundTruth{i}/scale;
    tmp = ribsGroundTruth{i};
    ribsGroundTruth{i} = tmp(:,testPoints);
end

offsets_inital = zeros(3,settings.ribNumber(end));
offsets=[0;0;0];

firstPts = findFirstPoints(settings.ribNumber,ribsGroundTruth,settings,m);
if compute
    for r=settings.ribNumber

        [ang_tmp, cost(r)] =  optimzeAngleScalePos(settings,r,ribsGroundTruth,...
        offsets_inital,x_dif,z_dif,firstPts,ptsI,options,ang0,imExh,offsets,3,imInh,ribsGroundTruth);
        ang(r,:) = ang_tmp;

    end
    save(resultPath,'ang','cost');

else
        load(resultPath,'ang','cost');

    figure;

    for r=settings.ribNumber
        offsets_(:,r)=[0;0;0]
        tmp= displayAngles(settings,ribsGroundTruth,ang(r,:),firstPts,ribsInhGroundTruth,r,ang(r,5),offsets_,false);
        newExh{r} = tmp{r};
        plot33(newExh{r},'b.',[1 3 2])
        hold on;
    %     plot33(ribsInhGroundTruth{r},'g.',[1 3 2])% 
        plot33(ribsGroundTruth{r},'r.',[1 3 2])% 

    end
end
axis equal

%%



