
for m=[ 63 ]%60 63 64 66

    setAngeModulNccFullCycle_loadResults2(m)
end

%%
surrId=124;
close all

for m=[63]
    
    
    dataPath = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

%     load([dataPath num2str(m) '/motionfields/coos_correspGrid_proto1_res_2_3red_2steps_x15y15z15'],'coos');
        load([dataPath num2str(m) '/motionfields/coos_refPose'],'coos');

    load([dataPath num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');
    load([dataPath num2str(m) '/ribsNCC/allCycles'],'pExh');

    for blockNo=2;%cycleinfo.nBlocks%1%:
        firstCycle = cycleinfo.cycsInBlock{blockNo}(1);
        lastCycle = cycleinfo.cycsInBlock{blockNo}(end);
        lastCycle = firstCycle + 30;
        cycleBegins = [0 cumsum(cycleinfo.nStates(1:end-1))]+1;
        cycleEnds = cumsum(cycleinfo.nStates);

        cycleSteps = firstCycle:lastCycle;

        timeSteps=cycleBegins(firstCycle):cycleEnds(lastCycle);

        for r=7:10
            
            
            try
                
                figure;hold on;
                
                plot(timeSteps,squeeze(pExh{r}(2,100,timeSteps))-pExh{r}(2,100,timeSteps(1)),'b');
                plot(timeSteps,squeeze(pExh{r}(2,100,timeSteps))-pExh{r}(2,100,timeSteps(1)),'b.');
                plot(timeSteps,coos{1}(surrId,timeSteps,2)-coos{1}(surrId,timeSteps(1),2),'r');
                plot(timeSteps,coos{1}(surrId,timeSteps,2)-coos{1}(surrId,timeSteps(1),2),'r.')
               
                plot(cycleBegins(cycleSteps),coos{1}(surrId,cycleBegins(cycleSteps),2)-coos{1}(surrId,timeSteps(1),2),'g*')
                plot(cycleBegins(cycleSteps),squeeze(pExh{r}(2,100,cycleBegins(cycleSteps)))-pExh{r}(2,100,timeSteps(1)),'m*')
                
                Y=coos{1}(124,timeSteps,2)-coos{1}(surrId,timeSteps(1),2);
                X = squeeze(pExh{r}(2,100,timeSteps))-pExh{r}(2,100,timeSteps(1));
                corr(X,Y')
                title([num2str(m) ' ' num2str(r)])

            catch
                r
            end
        end
    end

end


a = load([dataPath num2str(m) '/ribsNCC/allCycles']);
%%
r=7;
m=64;

 dataPath = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

    load([dataPath num2str(m) '/motionfields/coos_correspGrid_proto1_res_2_3red_2steps_x15y15z15'],'coos');
    load([dataPath num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');
    load([dataPath num2str(m) '/ribsNCC/res_NCC_' num2str(m)],'pExh');

    lastCycle = cycleinfo.cycsInBlock{1}(end);
    cycleBegins = [0 cumsum(cycleinfo.nStates(1:end-1))]+1;

    cycleSteps = 1:lastCycle;
    timeSteps=1:cycleBegins(lastCycle+1)-1;

%     X = squeeze(pExh{r}(+,100,timeSteps))-pExh{r}(2,100,(1))   ; 

    figure;plot(squeeze(pExh{r}(2,100,timeSteps))-pExh{r}(2,100,timeSteps(1)),coos{1}(124,timeSteps,2)-coos{1}(124,timeSteps(1),2),'b.')



    figure;plot(timeSteps,squeeze(pExh{r}(2,100,timeSteps))-pExh{r}(2,100,timeSteps(1)));hold on;plot(timeSteps,coos{1}(100,timeSteps,2)-coos{1}(100,timeSteps(1),2),'r')
    plot(cycleBegins(cycleSteps),coos{1}(100,cycleBegins(cycleSteps),2)-coos{1}(100,timeSteps(1),2),'g*')
    plot(cycleBegins(cycleSteps),squeeze(pExh{r}(2,100,cycleBegins(cycleSteps)))-pExh{r}(2,100,timeSteps(1)),'m*')

    
    
    
    
    %%
    
    close all;
    a= load([dataPath num2str(m) '/ribsNCC/allCycles']);
    load([dataPath num2str(m) '/ribsNCC/allCycles'],'angE');
    clear vr;
    for r=7:10
        
        angles = squeeze(angE(:,:,r));

        for i=1:size(angE,2)
            M = findEuler(angles(1,i),angles(2,i),angles(3,i));
            vr(i,:) = vrrotmat2vec(M);
        end
        figure;plot33([vr(:,1:3) ;[0 0 0] ],'b.')
        axis equal
        figure;plot(vr(:,4))

    end
    %%
        for i=1:100
figure;plot33(vr(:,1:3),'b.')
    figure;plot(angles(1,1:100)); hold on;plot(angles(1,1:100),'b.')
        figure;plot(angles(2,1:100)); hold on;plot(angles(2,1:100),'b.')

        figure;plot(angles(3,1:100)); hold on;plot(angles(3,1:100),'b.')

    
    
    
    
    
    
    
    
    
    
    
    
    
    

