clear all;
dataPathLinux = '/usr/biwinas03/scratch-c/sameig/Data/dataset';

if isunix()
    pathPrefix = '/home/sameig/';
    christinePrefix = '/usr/biwinas03/scratch-c/tannerch/FUSIMO/ETHliver/dataset';
    dataPath = dataPathLinux;
else
    pathPrefix = 'H:\';
    dataPath = 'M:/dataset';
    christinePrefix = 'Q:\dataset';
end

addpath([pathPrefix '/codes/ribFitting/oldFiles/'])
addpath([pathPrefix '/codes/ribFitting/'])

runFittingSettings;

unix('source /home/sgeadmin/BIWICELL/common/settings.sh');

addpath([pathPrefix 'codes/ribFitting/registration/itkScripts/']);
addpath([pathPrefix 'codes']);
addpath([pathPrefix 'codes/ribFitting/shapeModeling']);
addpath([pathPrefix '/codes/mvonSiebenthal/mri_toolbox_v1.5/']);


%%

 allMriSubjects= [  18 19 23 24 25 26 27 28 31 32 33 34 50   51    52    53    54   56    57    58    59  60     63    64     66]
 
 config_registeration;

%%
% Resample BH images with slick thickness 2.5 to 5 to compare the results

s=66
exe = '/home/tannerch/progs/itk/ResampleVolumesToBeIsotropic'
inputFile = ['~/M/dataset' num2str(s) '/masterframes/inhMaster.img']
outputFile = ['~/M/dataset' num2str(s) '/masterframes/inhMaster_rs.img']

options = [ '-resolutionXYZ ' num2str([1.3393 1.3393 5])];
command = [exe '  ' inputFile '  ' outputFile '  ' options]
unix(command)

   %%
mriSubjects = [18 19 23 24 25 26 27 28 31 33:34 ]% 23 24 25 26 27 28 31 33:34 ]
% 18 19 23 24 25 26 27 28 31 33:34 
% mriSubjects=[   60     63    64     66];
mriSubjects=[ 31 33:34  50   51    52    53    54   56    57    58    59    ];%60    61    63    64     66];

% mriSubjects= [  18 19 23 24 25];%][26 27 28 31 32 33 34];%;%
%% Registration with Matlab using Genetics Algorithm Optimizaiton

for s = 18:19%mriSubjects

    load(['/usr/biwinas01/scratch-g/sameig/Data/dataset' num2str(s) '/allcycles_nrig10_masked'],'cycleinfo');
     s
     cd /home/sameig/codes/ribFitting/  
     addpath('/home/sameig/codes/ribFitting/registration/')    
     addpath(genpath('./sge'))
	for r=7:10

        for cyc=1:5

            ribFit2{s,r,cyc} = createRibJob(1);

            for state = 1:cycleinfo.nStates(cyc)
                 createTask(ribFit2{s,r,cyc},@setAngeModulNccFullCycle_5,0,{s,r,cyc,state,params{s}});%});%

            end
            submit(ribFit2{s,r,cyc});
         end
     end
end
%% Load Results of Registration with Matlab using Genetics Algorithm Optimizaiton
   mriSubjects = [18 19]% 23 24 25 26 27 28 31 33:34 ]
for s = mriSubjects
     s
     cd /home/sameig/codes/ribFitting/  
     addpath('/home/sameig/codes/ribFitting/registration/')    
     addpath(genpath('./sge'))
      cycles=1:20
         for r=7:10
         
         setAngeModulNccFullCycle_load(s,r,cycles,params{s});
         
         end
     
end

%% Create masks rib and spine masks for registeration 
% the spine mask can be made using the first points of the ribs
% with the function createRibMasks(s,0,params{s});
% however, it is not so accurate, therefore, I manually create spine masks
% using Snap, but it needs to be processed using function createSpineMaskSnap(s,0); 


for s = mriSubjects

%     createSpineMaskSnap(s,0); 
%     createRibMasksTrans(s,0);
    createRibMasks(s,0,params{s});
    
end
%% edit 60s 
% because the reference image is not a reconstructed volume (from 2D slice)
% with the same resolutino as the rest of the 4DMRIs 
% and therefore here it is resized, padded ...


a = load('~/M/dataset60/masterframes/exhMaster7_unmasked_uncropped')
im = avw_img_read('~/M/dataset60/masterframes/exhMaster_rs.img',3)
im.img = permute(im.img,[2 1 3]);
im.img = flip(im.img,3);
% im.img(:,:,61:64)=0;
% saveAnlz(im.img,a.stack.par, '~/M/dataset60/masterframes/exhMaster_rs_padded2.img'   ,0,3)


imm = zeros(size(a.stack.im));
imm(:,:,5:64) = im.img;
saveAnlz(imm,a.stack.par, '~/M/dataset60/masterframes/exhMaster_rs_padded2.img'   ,0,3)

%% Save & Run Translation Scripts


for s = mriSubjects
    saveRegistrationForTranslationScripts(s,params{s});
end
%% A test for registering first translation then rotation, didn't get good results

for s = mrSubjects
    params{s}.angleBoundSpine = [-0.08 -0.08 -0.08; 0.08 0.08 0.08 ];
    params{s}.translationBoundSpine = [ -5 -5 -2; 5 5 5 ] ;
    saveRegistrationForTranslationScripts_rotation(s,params{s});
end
%% Save & Run Translation Scripts

for s = mriSubjects

    saveRegistrationForTranslationScriptsRibs(s,params{s});

end


for s = mriSubjects
 
    for r=7:10
        
        unix(['qsub ' params{s}.registrationTransRibs{r}]);
%         fprintf(1,['qsub ' params{s}.registrationRotation{r} '\n']);

    end
end

for s = mriSubjects
    
    extractTransCycRibs(s,params{s},okCycles{s},[]);%,,'bigMask');
    
end
%%
load([params{s}.dataPathUnix num2str(s) '/motionfields/ribsMotion_rib' ],'trans','trans_');
%% Load and save the rigid transformation of the exhale states

for s = mriSubjects
  s   
    extractTranslationCyc(s,params{s});
    
end
corruptCycles{18} = 14;

editTranslation(s,params{s},corruptCycles{s})

% 56 57 58 59
corruptCycles{25}=[52 53 70 71 75 77 78]
corruptCycles{66} = [6 42 56 76]
corruptCycles{57} = [3 7 20 26 45]
% 28 and 27 are too jaggy
%%

for s = mriSubjects
 
    saveRegistrationForRotationScripts(s,params{s});
    
end

for s = mriSubjects
    
    
    for r=7:10
        
        unix(['qsub ' params{s}.registrationRotation{r}]);
%         fprintf(1,['qsub ' params{s}.registrationRotation{r} '\n']);
    end
end


%%
for s = mriSubjects
    
    extractRotationCyc(s,params{s},[]);%,,'bigMask');
    
end

for s = mriSubjects

    [params{s}.missedCycs, params{s}.err_cyc_states, params{s}.err_initial]= computeP(s,params{s},[]);%,,'bigMask');
    
end
%%
commands= [];
fitted=1;

for s = mriSubjects

    params{s}.angleBound = [-0.1 -0.1 -0.1; 0.1 0.1 0.1];
    params{s}.translationBound = zeros(2,3);% [ -2 -2 -2 ; 2 2 2 ];

    commands_ = saveRegistrationForRotationScriptsBH(s,params{s},fitted);
    commands= [commands commands_];
end
%%
for s = mriSubjects
    transformBH(s,params{s},1,8:10)
end

%%

for s = mriSubjects
    
    
%     params{s}.missedCycs = error_{s};
    saveRegistrationForRotationScriptsMissedCycles(s,params{s});

end


for s = mriSubjects
    
    for r=params{s}.ribs
    
        if (~isempty(params{s}.missedCycs{r}))

            unix(['qsub ' params{s}.registrationRotation_missed{r}]);
%                 fprintf(1,['qsub ' params{s}.registrationRotation_missed{r} '\n']);
        end
    end
end

%%

%% Create Rib masks Series
 volumeFlag=0;
 s=52;
createRibMasksSeries(s,params{s},0,7:10,1:3,volumeFlag);
% exe= '/home/tannerch/progs/itk/ImageReadWrite3D' ;
% r=7;a=1;
% sourcePath = [dataPath num2str(s) '/stacks_test/stacksSeq/seqs/']
% mkdir([sourcePath '/mha/']);
% for a=1:100
% filePath1=[sourcePath '/file' num2str(a) '.img'];
% filePath2=[sourcePath '/mha/file' num2str(a) '.mha'];
% system([ exe '  ' filePath1 '  ' filePath2]);
% end

exe= '/home/tannerch/progs/itk/ImageReadWrite3D' ;

for r=7:10
    
    mkdir([dataPath num2str(s)  '/mask_series/mask' num2str(r) '/mha/'])

    for a=1:60
        filePath1=[dataPath num2str(s)  '/mask_series/mask' num2str(r) '/time' num2str(a) '.img'];
        filePath2=[dataPath num2str(s)  '/mask_series/mask' num2str(r) '/mha/time' num2str(a) '.mha'];
        system([ exe '  ' filePath1 '  ' filePath2]);
    end
end

%%

close all
% for s = mriSubjects
    
     load([params{s}.dataPathUnix num2str(s) '/motionfields/ribsMotion'])
%         load([params{s}.dataPathUnix num2str(s) '/motionfields/ribsMotionbigMask']);



    figure;
   pN=100
    for r=7:10%params{s}.ribs
        start=1;%20;
        endC = size(P{r},3);%120;%
        
        [a b c]=princomp(squeeze(P{r}(:,pN,start:endC))');
        subplot(4,1,r-6)
        plot(b(:,1)); title(num2str(r))
    %         cor = corrcoef([bb{r}(:,1) bb{8}(:,1)]);
    %         cor(1:3,4:6)
%             figure
% %             R = findEulerXfirst(angles_{r}(1,i),angles_{r}(2,i),angles_{r}(3,i)); % itk default order is ZXY
%             
%             subplot(4,1,1)
%             plot(squeeze(P{r}(1,pN,start:endC))');  
% %             axis([start,endC ,mean(squeeze(P{r}(1,pN,start:endC))')-3, mean(squeeze(P{r}(1,pN,start:endC))')+3]);
%             subplot(4,1,2)
% % %             figure;
%             plot(squeeze(P{r}(2,pN,start:endC))')
% %             axis([start,endC ,mean(squeeze(P{r}(2,pN,start:endC))')-3, mean(squeeze(P{r}(2,pN,start:endC))')+3]);
% 
%             subplot(4,1,3)
%             plot(squeeze(P{r}(3,pN,start:endC))')
% %             axis([start,endC ,mean(squeeze(P{r}(3,pN,start:endC))')-3, mean(squeeze(P{r}(3,pN,start:endC))')+3]);
%             
%             subplot(4,1,1)
%             title([num2str(r) ' ' num2str(s)])
%     


% xx = squeeze(P{r}(:,100,:));
% xx_0 = [xx - repmat(mean(xx,2),1,698)];



end
subplot(4,1,1)
title(num2str(s))

% end

%%

close all
for s = [18 19 23 24 25 26 27 28]%mriSubjects
    
     load([params{s}.dataPathUnix num2str(s) '/motionfields/ribsMotion'])
%         load([params{s}.dataPathUnix num2str(s) '/motionfields/ribsMotionbigMask']);

%     for r=7:10
r=7;
        X = P{r} - repmat(P{r}(:,:,1),1,1,size(P{r},3));
        Y = sqrt(sum(X.^2,1));
%     end

    surrg = squeeze(Y(1,100,:));

    inh=[];

    for i=5:length(surrg)-5

        neighbours = i-4:i+4;
        if (surrg(i)==max(surrg(neighbours)))

            inh=[inh i];
        end
    end

rng=rad2deg(0.02);
 
    for r=7:10%params{s}.ribs
            surrg = rad2deg(angles_{r});

            start=1;
            endC = size(surrg,2);%120;%
            figure
            subplot(4,1,1)
            plot(surrg(1,start:endC)');%plot(squeeze(trans_{r}(1,start:endC))')
            hold on;
            axis([1 endC mean(surrg(1,start:endC))-rng mean(surrg(1,start:endC))+rng]);
            try
            plot(inh,surrg(1,inh)','r*');%plot(squeeze(trans_{r}(1,start:endC))')
            catch
                r
            end
            subplot(4,1,2)
            plot(surrg(2,start:endC)');%plot(squeeze(trans_{r}(2,start:endC))')
            hold on;
            axis([1 endC mean(surrg(2,start:endC))-rng mean(surrg(2,start:endC))+rng]);
            try
            plot(inh,surrg(2,inh)','r*');%plot(squeeze(trans_{r}(2,start:endC))')
            catch
            end
            subplot(4,1,3)
            plot(surrg(3,start:endC)');%plot(squeeze(trans_{r}(2,start:endC))')
            hold on;
            axis([1 endC mean(surrg(3,start:endC))-rng mean(surrg(3,start:endC))+rng]);
            try
            plot(inh,surrg(3,inh)','r*');%plot(squeeze(trans_{r}(3,start:endC))')
            catch
            end
            subplot(4,1,1)
            title([num2str(r) ' ' num2str(s)])

    end
end




for i=1:size(angles_{r},2)
    vr(i,:) = vrrotmat2vec(findEulerO(angles_{r}(:,i),params{s}.o,0));
end
%%


%%

figure;plot(trans_{r}')
for r=7:10
    for i=1:100
    t_r{r}(:,i) = trans{r}{i}(:,1);
    end
end

for r=7:10
    figure;plot(t_r{r}');
end

figure;plot(trans_{7}')
figure;plot(trans_{7}(2,:))
figure;plot(angles_{10}')
%%
close all
for s = mriSubjects

    load(params{s}.outputTranslationFile,'initialTranslation','initialRotation','t_','moved_center');

    figure; hold on;
    plot(t_{7}(:,1:end)')
    plot(t_{8}(:,1:end)')
    plot(t_{9}(:,1:end)')
    plot(t_{10}(:,1:end)')
    title(num2str(s))
%     trans_t=[];
%     for i=1:20
%         clear tmp;
%      tmp(1,:)= trans{7}{i}(1,:)-t_{7}(1,i);
%      tmp(2,:)= trans{7}{i}(2,:)-t_{7}(2,i);
%      tmp(3,:)= trans{7}{i}(3,:)-t_{7}(3,i);
%      trans_t = [trans_t tmp];
%     end
%     figure;plot(trans_t');
    
%     
%     figure;plot(t_{7}(:,1:end)')
%     figure;plot(t_{8}(:,1:end)')
%     figure;plot(t_{9}(:,1:end)')
%     figure;plot(t_{10}(:,1:end)')

%     figure;plot(initialTranslation')
%     title(num2str(s))
% 
%     figure;plot(initialRotation')
%     title(num2str(s))

end

%%
[cyc state]=findCycle(angles,j)
gt_ribs(params{s},cyc,state,r)
  testRibPath = [params{s}.subjectPath '/stacks_gt/cyc_' num2str(cyc) '_' num2str(state) '_rib' num2str(r) '_full'] 
sp_temp = readVTKPolyDataPoints(testRibPath );
x = load([params{s}.dataPathUnix num2str(s) '/motionfields/ribsMotion'])
test = x.P{10}(:,:,170)
[cost, dist ,errors,lenError,outOfPlaneError]=computeErorrRibs(test,sp_temp,1)      
             
 figure;
 plot33(pExh);
 hold on;
 plot33(sp_temp,'r.')
 plot33(test,'g*')
 
 
 