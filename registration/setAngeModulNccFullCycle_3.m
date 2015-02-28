

function [errs1, errs2 ,ribError1,ribError2,lenError] = setAngeModulNccFullCycle_3(m,cycle,fitted)

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


load(['/usr/biwinas01/scratch-g/sameig/Data/dataset' num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');

if (m >= 60 )
    
    imExh_ = load([dataPath num2str(m)  '/masterframes/exhMaster.mat']);
    imExh_.stack.par.thickness =2.5;

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
    else
        ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightNew');
    end
    ang00(settings.ribNumber,4) = 1;
    ang00(:,5) = 1;

    offsets_inital(1:3,settings.ribNumber) =  0; 
    
    
end



if m==60
    for r=8:10
        ribsExh{r}(2,:) = ribsExh{r}(2,:) + 40;
    end
end


offsets.ranges=[-6 6; -6 6 ;-6 6 ];
offsets.step=2;



options.ranges=[-6 3 ;-3 3; -3 3; 1 1 ; 0 0];
options.step1=0.5;
options.step2=1;
options.step3=1;
        
moving = imExh_.stack.im;
fixed = imInh_.stack.im;
imm=moving(:,:,end:-1:1);
imm=imm(end:-1:1,:,:);
              

figure;imshow(im(:,:,50),[])
figure;imshow(im(:,:,250),[])
figure;imshow(imm(:,:,10),[])
figure;imshow(imm(:,:,50),[])


res_1(1,1) = imExh_.stack.par.inplane;
    res_1(2,1) = imExh_.stack.par.inplane;
    res_1(3,1) = imExh_.stack.par.thickness;
    

                
pp = ribsExh{7};
pp = transCoord(pp,settings.ap,settings.is,settings.lr);

pp(1,:) = -pp(1,:);
pp(2,:) = -pp(2,:);
pp(3,:) = -pp(3,:);

pp(2,:) = pp(2,:) + size(imExh_.stack.im,2)*res_1(2);
pp(3,:) = pp(3,:) + size(imExh_.stack.im,3)*res_1(3);


pp(1,:) = -pp(1,:) + size(imExh_.stack.im,1)*res_1(1);
pp(3,:) = pp(3,:) + size(imExh_.stack.im,3)*res_1(3);


pp =  pp ./repmat(res_1,1,100);
figure
moving=imm;
for z=1:20
    hold off
imshow(moving(:,:,z),[]);hold on; plot33(pp(:,find(abs(pp(3,:)-z)<1)),'b.')
pause(0.5);
end


pp(1,:) = pp(1,:) + size(imExh_.stack.im,1)
pp(3,:) = pp(3,:) + size(imExh_.stack.im,3)

% 
%      pExh % RAS
%      imExh% IPR
%      pp = coordSysTransform(ribsExh{7},'RAS','IPR')
%      pp = ribsExh{7};
%      pp =  pp ./repmat(res_1,1,100); 
%      pp(1,:) = pp(1,:) + size(imExh_.stack.im,1)
%      pp(2,:) = pp(2,:) + size(imExh_.stack.im,2)
%      pp(3,:) = pp(3,:) + size(imExh_.stack.im,3)



    res_2(1,1) = im2.par.inplane;
    res_2(2,1) = im2.par.inplane;
    res_2(3,1) = im2.par.thickness;

%     pExh_ = (transCoord(ribsExh{7},settings.ap,settings.is,settings.lr));  

%     p1=pExh_./repmat(res_1,1,100);
%     p1 = ceil(p1);
p1=ceil(pp);
moveing_mask = moving*0; 
for i=1:100
    for ii=-3:3
        for jj=-3:3
            for kk=-2:2
                try
                    moveing_mask(p1(1,i)+ii,p1(2,i)+jj,p1(3,i)+kk) = 1;
                catch
                end
            end
        end
    end
end

[optimizer, metric] = imregconfig('monomodal')
moving_masked = moveing_mask.*moving;
transformType='rigid'
moving_reg = imregister(moving_masked,fixed,transformType,optimizer,metric);
moving_reg = imregister(moving,fixed,transformType,optimizer,metric);


for state = 1:cycleinfo.nStates(cycle)

    if ( m >= 60 || m==57)
        imagePath = [dataPath num2str(m) '/stacks/cyc_' num2str(cycle) '_' num2str(state) '.mat'];
    else
        imagePath = [dataPath num2str(m) '/stacks/original_5_cyc_' num2str(cycle) '_' num2str(state) '.mat'];
    end

    imInh_ = load(imagePath);
    imInh_.stack.par.thickness =5;    
    
    if state ==1
        ang0= ang00;

        offsets.ranges=[-6 6; -6 6 ;-6 6 ];
        offsets.step=2;
        iter=0;     
        o=[-999 -999 -999];
        
        while ( any (o~=0 ) && iter<5 )
            iter=iter+1;
            o= findOptimalTranslation(settings,settings.ribNumber,ribsExh,...
                offsets_inital,firstPts,imInh_.stack,imExh_.stack,ribsExh,offsets,ang0(:,5));

            offsets_inital(1,:) = offsets_inital(1,:) +o(1);
            offsets_inital(2,:) = offsets_inital(2,:) +o(2);
            offsets_inital(3,:) = offsets_inital(3,:) +o(3);
        
        end
        
        offsets.ranges=[-1 1; -1 1 ;-1 1 ];
        offsets.step=0.5;
         
        o=[-999 -999 -999];
        iter=0;
        
        while ( any (o~=0)  && iter<5 )
            iter=iter+1;
            o= findOptimalTranslation(settings,settings.ribNumber,ribsExh,...
                offsets_inital,firstPts,imInh_.stack,imExh_.stack,ribsExh,offsets,ang0(:,5));

            offsets_inital(1,:) = offsets_inital(1,:) +o(1);
            offsets_inital(2,:) = offsets_inital(2,:) +o(2);
            offsets_inital(3,:) = offsets_inital(3,:) +o(3);

        end
        offsets.ranges = zeros(3,2);
        for r = settings.ribNumber

            options.ranges = [-6 6 ;-6 6; -6 6; 1 1 ; 0 0];
            options.step1=2;
                        
            ang_tmp = ang0;
            iter=0;
            a=[-999 -999 -999];
            while (any ( a ~=0) && iter <5 )
                
                iter=iter+1;
                [ang_tmp2, cost(r), offset_indexTmp] =  optimzeAngleScalePos(settings,r,ribsExh,...
                offsets_inital,x_dif,z_dif,firstPts,ptsExh,options,ang_tmp(r,:),imExh_.stack,offsets,3,imInh_.stack);
                a = ang_tmp(r,:) - ang_tmp2(r,:);
                ang_tmp = ang_tmp2;
            end
                        
            options.ranges=[-1 1 ;-1 1; -1 1; 1 1 ; 0 0];
            options.step1=0.5;
            
            iter=0;
            a=[-999 -999 -999];

            while (any ( a ~=0) && iter <5 )
                iter=iter+1;
                [ang_tmp2, cost(r), offset_indexTmp] =  optimzeAngleScalePos(settings,r,ribsExh,...
                offsets_inital,x_dif,z_dif,firstPts,ptsExh,options,ang_tmp(r,:),imExh_.stack,offsets,3,imInh_.stack);
                a = ang_tmp(r,:) - ang_tmp2(r,:);
                ang_tmp = ang_tmp2;
            end
            
            ang(r,:,1) = ang_tmp(r,:);
            offset_index(:,r,state) = offset_indexTmp(:,r);

            rot_mat = findRotaionMatrixNew(ribsExh{r});

            direc1= rot_mat * [0 1 0 ]';

            deg1= ang(r,1,1);
            deg2= ang(r,2,1);   
            deg3= ang(r,3,1);
            scale =  ang(r,4,1); 
            startP = ang(r,5,1);

            M1 = vrrotvec2mat([0 1 0 deg1/180*pi]);
            M1_r =  rot_mat*M1*rot_mat';

            P = scale*ribsExh{r};
            hyp0 = M1_r * P; 
            points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);
            [~, direc2] = lsqLine(points');

            M2 = vrrotvec2mat([direc2 deg2/180*pi]);
            direc3 = cross(direc1,direc2);

            M3 = vrrotvec2mat([direc3 deg3/180*pi]);
            hyp0_ = M3 * M2* hyp0;

            ribsExh_{r} = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
            
            ribsExh_{r}(1,:) = ribsExh_{r}(1,:) + offset_index(1,r,state);
            ribsExh_{r}(2,:) = ribsExh_{r}(2,:) + offset_index(2,r,state);
            ribsExh_{r}(3,:) = ribsExh_{r}(3,:) + offset_index(3,r,state);
        
        end

        imExh_ = imInh_;
        ribsExh = ribsExh_;
        
    else

        ang0 =ang(:,:,state-1);
        for r=settings.ribNumber
            
            options.ranges=[-6 6 ;-6 6; -6 6; 1 1 ; 0 0];
            options.step1=2;
            
            ang_tmp = ang0;

            iter=0;
            a=[-999 -999 -999];
            offsets.ranges = [-2 2; -2 2 ;-2 2 ];
            offsets.step=1;
        
            while ( any( a ~=0) && iter <5 )
                
                iter=iter+1;
                [ang_tmp2, cost(r), offset_indexTmp] =  optimzeAngleScalePos(settings,r,ribsExh,...
                offsets_inital,x_dif,z_dif,firstPts,ptsExh,options,ang_tmp(r,:),imExh_.stack,offsets,3,imInh_.stack);
                a = ang_tmp(r,:)  - ang_tmp2(r,:) ;
                ang_tmp = ang_tmp2;
                
            end
                        
            options.ranges=[-1 1 ;-1 1; -1 1; 1 1 ; 0 0];
            options.step1=0.5;
            
            iter=0;
            a=[-999 -999 -999];

            while (any ( a ~=0) && iter <5 )
                
                iter=iter+1;
                [ang_tmp2, cost(r), offset_indexTmp] =  optimzeAngleScalePos(settings,r,ribsExh,...
                offsets_inital,x_dif,z_dif,firstPts,ptsExh,options,ang_tmp(r,:),imExh_.stack,offsets,3,imInh_.stack);
                a = ang_tmp(r,:) - ang_tmp2(r,:) ;
                ang_tmp = ang_tmp2;
                
            end
                     
            ang(r,:,state) = ang_tmp(r,:);
            offset_index(:,r,state) = offset_indexTmp(:,r) + offset_index(:,r,1);

        end
    end
%     ang(:,:,state) = ang_;
end

save(resultPathNCC,'ang','cost','offset_index');

