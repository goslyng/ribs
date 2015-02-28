

function  setAngeModulNccFullCycle_loadResults2(m,fitted)



    if ~(exist('fitted','var'))
        fitted=1;
    end

    inh=1;
    runFittingSettings;

    pathSettings;

    settings.nSamplesRibcage = 6;
    settings.wFirstPoint = [0 0 0];

    if (m==59 || m==60)
        settings.ribNumber=8:10;
    else
        settings.ribNumber=7:10;
    end



%%


    for i=1:3
        resultPath{i} = [rootPath 'Ribs/res_firstP_'  '_step' num2str(i) '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)];
    end

    [ptsExh, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,0);
    firstPts = findFirstPoints(rib_nos,ptsExh,settings,m);

    load([dataPath num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');

    if fitted
        ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibFittedRight');
    else
        if s>=60
            ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightExhNew');
        else
            ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightNew');
        end
    end

%%

ang_ = -999*ones(10,5,999999);
k=0;
for cycle = 1: cycleinfo.nCycs 
    
    resultPathNCC = [dataPath num2str(m) '/ribsNCC' '/'  'cycle_' num2str(cycle) ];

    try
        load(resultPathNCC,'ang','cost','offset_index');
    catch
        ang=ang_;
        resultPathNCC = [dataPath num2str(m) '/ribsNCC/allCycles'];
        save(resultPathNCC,'pExh','ang','offset','angE');
        return
     end
    
%     load(resultPathNCC,'ang','cost','offset_index');
    k=k+1;
    hypotheses = buildExhale(ang(:,:,1),ribsExh,settings,offset_index(:,:,1),firstPts);
    for r = settings.ribNumber
        pExh{r}(:,:,k) = hypotheses{r};
       [angE(1,k,r), angE(2,k,r), angE(3,k,r)]=  findEuler(  findRotaionMatrixNew(pExh{r}(:,:,k)));

    end
    offset(:,:,k)=offset_index(:,:,1);
    ang_(:,:,k)=ang(:,:,1);
    for state=2:cycleinfo.nStates(cycle)
        ang0 = ang(:,:,state);
        k=k+1;
        ang_(:,:,k)=ang(:,:,state);

        for r = settings.ribNumber

            rot_mat = findRotaionMatrixNew(hypotheses{r});

            direc1= rot_mat * [0 1 0 ]';

            deg1= ang0(r,1);
            deg2= ang0(r,2);   
            deg3= ang0(r,3);
            scale = ang0(r,4); 
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

            pExh{r}(:,:,k) = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
            pExh{r}(1,:,k) =  pExh{r}(1,:,k) + offset_index(1,r,state);
            pExh{r}(2,:,k) =  pExh{r}(2,:,k) + offset_index(2,r,state);
            pExh{r}(3,:,k) =  pExh{r}(3,:,k) + offset_index(3,r,state);
            
            [angE(1,k,r), angE(2,k,r), angE(3,k,r)]=  findEuler(  findRotaionMatrixNew(pExh{r}(:,:,k)));
%             offset(:,:,k)=o(:,:,state);
            offset(:,:,k)=offset_index(:,:,1);
        end
        
    end
end
%%

ang=ang_(:,:,1:k);
resultPathNCC = [dataPath num2str(m) '/ribsNCC' '/allCycles'];
save(resultPathNCC,'pExh','ang','offset','angE');
%%
% figure;plot(squeeze(a.pExh{8}(2,100,1:500))-100);hold on;plot(coos{1}(100,1:500,2)-50,'r')
% hold on;
% plot(squeeze(a.pExh{8}(2,100,1:500))-100,'b.')
% plot(cycleBeings(1:50),coos{1}(100,cycleBeings(1:50),2)-50,'g*')
