

function [errs1, errs2 ,ribError1,ribError2,lenError,outOfPlaneError1]=setAngeModulNcc(m,compute,cycle,fitted)

if ~(exist('fitted','var'))
    fitted=1;
end

inh=1;
runFittingSettings;

pathSettings;

settings.nSamplesRibcage = 6;
settings.wFirstPoint = [0 0 0];


%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;
% resultPath = [rootPath 'Ribs/ang_reg_bh_' num2str(m) '_' num2str(fitted)];


scale  = 1;
scale2 = 1;

if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

for i=1:3
    resultPath{i} = [rootPath 'Ribs/res_firstP_'  '_step' num2str(i) '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)]
%     resultPath{i} = [rootPath 'Ribs/ang_scale1_step' num2str(i) '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)];

    
    
end

resultPathNCC = [rootPath 'Ribs/res_firstP_NCC'  '_step' '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)];
% resultPathNCC = [rootPath 'Ribs/oldResults/ang_reg_bh_' num2str(m) '_1'];
% resultPathNCC = [rootPath 'Ribs/ang_inh_scale1_sigma03_' num2str(m) ]; 
% resultPathNCC = [rootPath 'Ribs//ang_reg_bh_' num2str(m) '_new'];
resultPathNCC = [rootPath 'Ribs//ang_reg_bh_' num2str(m) '_1'];

%%
   

options{1} = -6:6;
options{2} = -6:6;
options{3} = -6:6;
options{4} =  1;
options{5} =  0;



ang0=zeros(settings.ribNumber(end),5);
ang0(settings.ribNumber,4) = 1;
ang0(settings.ribNumber,5) = 1;


[ptsExh, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,0);
[firstPts, pts] = findFirstPoints(rib_nos,ptsExh,settings,m);
makeScaleChanges;


%%

% cycle= 266; %m=50
% state = 8;

z_dif=[];
x_dif=[];



if cycle
    load([dataPath num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');

    state = cycleinfo.peaks(cycle);
%     b = load();
%     imInh = b.stack;
    imagePath = [dataPath num2str(m) '/stacks/original_5_cyc_' num2str(cycle) '_' num2str(state) '.mat'];
    imInh = resize_images_hdr_path(m,imagePath);

else
    b = load([dataPath num2str(m) '/masterframes/resized_inhMaster7_unmasked_uncropped.mat']);
    imInh = b.im;
    ribsInhGroundTruth = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightInhNew');

end


if fitted

    load(resultPath{2},'ang','cost','offset_indx','scale','scale2');
    [~,c]=min(sum(cost(:,settings.ribNumber),2));
    ang0(:,5) = ang{c}(:,5);
end


if fitted

    ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibFittedRight');
else
    ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightExhNew');
end




offsets_inital = zeros(3,settings.ribNumber(end));
offsets.ranges=[0 0;0 0; 0 0];
offsets.step=1;


clear cost;

if compute
    a = load([dataPath num2str(m)  '/masterframes/resized_exhMaster7_unmasked_uncropped.mat']);

imExh = a.im;
imExh = a;
imInh = b;
imInh.par.inplane=1;
imExh.par.inplane=1;
imInh.par.thickness=1;
imExh.par.thickness=1;
    for r=settings.ribNumber
%         options{1} = -6:6;
%         options{2} = -6:6;
%         options{3} = -6:6;
        options.ranges=[-6 6 ;-6 6; -6 6; 1 1 ; 0 0];
        options.step1=1;
        options.step2=1;
        options.step3=1;
        [ang_tmp, cost(r)] =  optimzeAngleScalePos(settings,r,ribsExh,...
        offsets_inital,x_dif,z_dif,firstPts,ptsExh,options,ang0(r,:),imExh,offsets,3,imInh);

%         options{1} = [-0.5 0 0.5 ];
%         options{2} = [-0.5 0 0.5 ];
%         options{3} = [-0.5 0 0.5 ];
        options.ranges=[-2 2 ;-2 2; -2 2; 1 1 ; 0 0];
        options.step1=0.5;
        options.step2=1;
        options.step3=1;
        [ang_tmp, cost(r)] =  optimzeAngleScalePos(settings,r,ribsExh,...
        offsets_inital,x_dif,z_dif,firstPts,ptsExh,options,ang_tmp,imExh,offsets,3,imInh);
        ang_(r,:) = ang_tmp(r,:);

    end
    ang = ang_;
    save(resultPathNCC,'ang','cost');

else

    load(resultPathNCC,'ang','cost');
    figure;

    for r=settings.ribNumber
%         ribsInhGroundTruth=ribsExh;{[],[],[],[],[],[],[],[],[],[]};
        ang(r,5) = ang0(r,5);
        tmp = displayAngles(settings,ribsExh,ang(r,:),firstPts,ribsInhGroundTruth,r,ang(r,5),offsets_inital,false);
        if cycle<1
        [err_ribs1(r),~,tmp1,lenError(r),outOfPlaneError1{r}]= computeErorr(tmp,ribsInhGroundTruth,r,settings,settings.step,ang(r,5),1);
        [err_ribs2(r),~,tmp2]= computeErorr(tmp,ribsInhGroundTruth,r,settings,settings.step,ang(r,5),2);
        ribError1{r}=tmp1{r};
        ribError2{r}=tmp2{r};
        end
        plot33(tmp{r},'b.',[1 3 2])
        hold on;
        plot33(ribsInhGroundTruth{r},'g.',[1 3 2])% 
%         plot33(ribsGroundTruth{r},'r.',[1 3 2])% 


    end
    axis equal

    errs1 = err_ribs1(settings.ribNumber)
    errs2 = err_ribs2(settings.ribNumber)
end

