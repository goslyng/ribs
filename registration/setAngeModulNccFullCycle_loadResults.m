

function  setAngeModulNccFullCycle_loadResults(m)

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
   

[ptsExh, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,0);
firstPts = findFirstPoints(rib_nos,ptsExh,settings,m);

load([dataPath num2str(m) '/allcycles_nrig10_masked'],'cycleinfo');

if fitted
    ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibFittedRight');
else
    ribsExh = loadRibVTKFilesTag(dataPath,m,settings.ap,settings.is,settings.lr,'RibRightExhNew');
end
pathPrefix = [dataPath num2str(m) '/ribsNCC/cycle_'];
%%

k=1;
for cycle = 1: cycleinfo.nCycs 
    
    resultPathNCC = [pathPrefix num2str(cycle) ];
    try
        load(resultPathNCC,'ang','cost','offset_index');
    catch
        ang=ang_;
        resultPathNCC = [dataPath num2str(m) '/ribsNCC/allCycles'];
        save(resultPathNCC,'pExh','ang');
        return
    end
    hypotheses = ribsExh;

    for state = 1:cycleinfo.nStates(cycle)
        ang0 = ang(:,:,state);

        for r=settings.ribNumber

            rot_mat = findRotaionMatrixNew(hypotheses{r});

            direc1= rot_mat * [0 1 0 ]';

            deg1 = ang0(r,1);
            deg2 = ang0(r,2);   
            deg3 = ang0(r,3);
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
            ang_(:,:,k)=ang(:,:,state);
        end
        k=k+1;
    end
end
%%
ang=ang_;
resultPathNCC = [dataPath num2str(m) '/ribsNCC/allCycles'];
save(resultPathNCC,'pExh','ang');
