
%% Create Rib masks Series

s=26;
params{s}.r_h2 = 14/2;
createRibMasks(s,0,params{s},'display');
   
    
volumeFlag=0;

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
	pN=100;
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
 
 
