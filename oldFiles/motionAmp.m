

function  ribError1 = motionAmp(m)
inh=1;
runFittingSettings;

pathSettings;

ribsDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';
dataPathUnix = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

    codePath = '/home/sameig/codes/';
    ribsDataPath = ribsDataPathUnix;
    rootPath = '/usr/biwinas01/scratch-g/sameig/';
    dataPath = dataPathUnix;
    rfCodePath ='/home/sameig/codes/RF_MexStandalone-v0.02/randomforest-matlab/RF_Class_C';
    addpath(rfCodePath);




%% Load Rib VTK Files

% for m=mriSubjects
    [ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,inh);
    [ptsExh, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr,0);
% end


testRibs = 7:10;

if (m==59 || m==60 || m==550)
    testRibs=8:10;
end



%%
ribError1=[]
%     hold off;
    for r = testRibs
        
       [~,~,tmp1,lenError(r),outOfPlaneErrorTMP]= computeErorr(ptsExh,ptsI,r,settings,settings.step,1,1);
       [~,b]=min(tmp1{r}(1:20));
       ribError1=[ribError1 ;tmp1{r}(b:end)];
    
    end
  
   





