

function [errs1, errs2 ,ribError1,ribError2,lenError]=setAngeModulNccFullCycle(m,compute,cycle,fitted)

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


if (m==59 || m==60)
    settings.ribNumber=8:10;
else
    settings.ribNumber=7:10;
end
if fitted
    fittedText='_fitted';
else
    fittedText='';
end

resultPathNCC = [rootPath 'Ribs/res_firstP_NCC'  fittedText '_cycle' num2str(cycle)  '_' num2str(m)];

%%
   

% options{1} = -6:6;
% options{2} = -6:6;
% options{3} = -6:6;
% options{4} =  1;
% options{5} =  0;


% 
% ang0=zeros(settings.ribNumber(end),5);
% ang0(settings.ribNumber,4) = 1;
% ang0(settings.ribNumber,5) = 1;


[ptsExh, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,0);
[firstPts, pts] = findFirstPoints(rib_nos,ptsExh,settings,m);
% makeScaleChanges;


%%


z_dif=[];
x_dif=[];


load(['/usr/biwinas01/scratch-g/sameig/Data/dataset' num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');

a = load([dataPath num2str(m)  '/masterframes/resized_exhMaster7_unmasked_uncropped.mat']);
imExh = a.im;

 

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
    ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightExhNew');
    ang00(:,5) = 1;
    ang00(settings.ribNumber,4) = 1;
    offsets_inital(1:3,settings.ribNumber) =  0; 
    
    
end



offsets.ranges=[-6 6; -6 6 ;-6 6 ];
offsets.step=2;

options.ranges=[-2 2 ;-2 2; -2 2; 1 1 ; 0 0];
options.step1=0.5;
options.step2=1;
options.step3=1;
        
        
if compute
  
    for state=1:cycleinfo.nStates(cycle)
        
        imagePath = [dataPath num2str(m) '/stacks/original_5_cyc_' num2str(cycle) '_' num2str(state) '.mat'];
        fprintf(1,'Resizing images...\n');
        imInh = resize_images_hdr_path(m,imagePath);
        fprintf(1,'Done!\n');
        
        if state ==1
            ang0= ang00;
            
            o= findOptimalTranslation(settings,settings.ribNumber,ribsExh,...
            offsets_inital,firstPts,imInh,imExh,ribsExh,offsets,ang0(:,5));
        
        
            offsets_inital(1,:) = offsets_inital(1,:) +o(1);
            offsets_inital(2,:) = offsets_inital(2,:) +o(2);
            offsets_inital(3,:) = offsets_inital(3,:) +o(3);
            offsets.ranges=zeros(3,2);
    
    
        else
            ang0 =ang(:,:,state-1);
        end
             
        for r=settings.ribNumber

            [ang_tmp, cost(r),offset_indexTmp] =  optimzeAngleScalePos(settings,r,ribsExh,...
            offsets_inital,x_dif,z_dif,firstPts,ptsExh,options,ang0(r,:),imExh,offsets,3,imInh,ribsExh);
        
            ang_(r,:) = ang_tmp(r,:);
            offset_index(:,r,state) = offset_indexTmp(:,r);

        end
        ang(:,:,state) = ang_;
    end
    
    save(resultPathNCC,'ang','cost','offset_index');

else
    load(resultPathNCC,'ang','cost');
    figure;
    hypotheses = ribsExh;

    for state=1:cycleinfo.nStates(cycle)
        ang0 = ang(:,:,state);

        for r=settings.ribNumber

            rot_mat = findRotaionMatrixNew(hypotheses{r});

            direc1= rot_mat * [0 1 0 ]';

            deg1= ang0(r,1);
            deg2= ang0(r,2);   
            deg3= ang0(r,3);
            scale =   ang0(r,4); 
            startP = ang0(r,5);

            M1 = vrrotvec2mat([0 1 0 deg1/180*pi]);
            M1_r =  rot_mat*M1*rot_mat';

            P = scale*hypotheses{r};
            hyp0 = M1_r * P; 
            points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);
            [~, direc2] = lsqLine(points');


            M2 = vrrotvec2mat([direc2 deg2/180*pi]);
            direc3 = cross(direc1,direc2);


            M3 = vrrotvec2mat([direc3 deg3/180*pi]);
            hyp0_ = M3 * M2* hyp0;

            pExh{r}(:,:,state) = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
            pExh{r}(1,:,state) =  pExh{r}(1,:,state) + offset_index(1,r,state);
            pExh{r}(2,:,state) =  pExh{r}(2,:,state) + offset_index(2,r,state);
            pExh{r}(3,:,state) =  pExh{r}(3,:,state) + offset_index(3,r,state);
        end
    end


    for r=settings.ribNumber
        ribsInhGroundTruth=ribsExh;{[],[],[],[],[],[],[],[],[],[]};
        ang(r,5) = ang0(r,5);
        tmp = displayAngles(settings,ribsExh,ang(r,:),firstPts,ribsInhGroundTruth,r,ang(r,5),offsets_inital,false);
        if cycle<1
        [err_ribs1(r),~,tmp1,lenError(r)]= computeErorr(tmp,ribsInhGroundTruth,r,settings,settings.step,ang(r,5),1);
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

    errs1 = err_ribs1(settings.ribNumber);
    errs2 = err_ribs2(settings.ribNumber);
end

