

function [errs1, errs2 ,ribError1,ribError2,lenError] = setAngeModulNccFullCycle_4(m,cycle,fitted)

% debugText='hi';

if ~(exist('fitted','var'))
    fitted=1;
end

inh=1;
runFittingSettings;

pathSettings;

% settings.nSamplesRibcage = 6;
% settings.wFirstPoint = [0 0 0];
% errs1=6;
% save('/home/sameig/debugText','debugText');
%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;


if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end

if fitted
    fittedText='fitted_';
else
    fittedText='';
end

resultPathNCC = [dataPath num2str(m) '/ribsNCC/'  fittedText 'cycle_' num2str(cycle)  ];
% save('~/debugText1','debugText');

%%
 

[ptsExh, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,0);
[firstPts, pts] = findFirstPoints(rib_nos,ptsExh,settings,m);

% save('~/debugTexHallt2','debugText');

%%


z_dif=[];
x_dif=[];


% load(['/usr/biwinas01/scratch-g/sameig/Data/dataset' num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');

if (m >= 60 )
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster.mat']);
    imExh_.stack.par.thickness =2.5;
imInh_ = load([dataPath num2str(m)  '/masterframes/inhMaster.mat']);
imInh_.stack.par.thickness=2.5
else
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster7_unmasked_uncropped.mat']);
    imExh_.stack.par.thickness =5;
    
end


if fitted

    for i=1:3
        resultPath{i} = [rootPath 'Ribs/res_firstP_'  '_step' num2str(i) '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)];
    end
    ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibFittedRight');
    
    load(resultPath{3},'ang','offset_indx','cost');

    [~,c]=min(sum(cost(:,settings.ribNumber),2));
    ang00(:,5) = ang{c}(:,5);
    ang00(settings.ribNumber,4) = 1;
    offsets_inital(1:3,:) =  offset_indx(c,:,:); 

    clear ang;
    clear cost;


else
    
    if m>=60
        ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightExhNew');
        ribsInh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightInhNew');
    else
        ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightNew');
    end
    ang00(settings.ribNumber,4) = 1;
    ang00(:,5) = 1;

    offsets_inital(1:3,settings.ribNumber) =  0; 
    
    
end


% 
% if m==60
%     for r=8:10
%         ribsExh{r}(2,:) = ribsExh{r}(2,:) + 40;
%     end
% end


        
fixed  = imExh_.stack;
moving = imInh_.stack;


res_1(1,1) = imExh_.stack.par.inplane;
    res_1(2,1) = imExh_.stack.par.inplane;
    res_1(3,1) = imExh_.stack.par.thickness;
    
[s_1, s_2 ,s_3]= size(imInh_.stack.im);
      

for r= settings.ribNumber
    
    
    pp  =  ribsExh{r}./repmat(res_1,1,size(ribsExh{r},2));
    pn2 =  ribsInh{r}./repmat(res_1,1,size(ribsExh{r},2));
    
    
    pp(1,:) = -pp(1,:);
    pp(2,:) = s_2-pp(2,:);
    pp(3,:) = s_3 +pp(3,:);


    pn2(1,:) = -pn2(1,:);
    pn2(2,:) = s_2-pn2(2,:);
    pn2(3,:) = s_3 +pn2(3,:);


    LB = [-0.1 -0.1 -0.1 -2 -2 -2];
    UB = [0.1 0.1 0.1 2 2 2 ];


% 
% LB = [-0.2 -0.2 -0.2 0 0 0 ];
% UB = [0.2 0.2 0.2 0 0 0 ];


displayImages=1;

    patch_size=[1 5 0];

    [T, fval] =  fitnessFunctionReg(LB,UB, fixed.im,moving.im,pp,patch_size,displayImages);


    % err = nccCycle2(fixed.im,moving.im,pp,pp,patch_size)

    R  = findEulerO(T(1:3),[ 1 3 2],0);
    pn = R * (pp - repmat(pp(:,1),1,100)) + repmat(pp(:,1)+T(4:6)',1,100);

    figure;plot33(pp)
    hold on;plot33(pn,'g.')
    hold on;plot33(pn2,'r.')
    axis equal
    
   
    pn(1,:) = -pn(1,:);
    pn(2,:) = s_2-pn(2,:);
    pn(3,:) = pn(3,:) - s_3;
    pn = pn.*repmat(res_1,1,size(ribsExh{r},2));
    pn = transCoord(pn,settings.ap,settings.is,settings.lr);
    writeVTKPolyDataPoints([dataPath num2str(m) '/ribs/RibRightInhReg' num2str(r)],pn)
    
    
end

% 
%   vec = vrrotvec(pp(:,80) - pp(:,1),pn2(:,80) - pn2(:,1));
%     M__ = vrrotvec2mat(vec);
%     [a b c]=findEulerO(M__,[1 3 2],1)
%     
%     R= M__
%     
%     
%   ribCost =  - nccCycle2(fixed,moving,pp,pn2,patch_size);
%   
%   
