% function ribFittingHypTestRibRotateEuler(m,steps,params)
clear all
%% Path Settings

if isunix()
    codePathRoot = '/home/sameig/codes';
else
    codePathRoot = 'H:/codes';

end

codePath = [codePathRoot '/ribFitting/'];
addpath(codePath)

%% Steps

ribsDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';
dataPathUnix = '/usr/biwinas03/scratch-c/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
    ribsDataPath = ribsDataPathUnix;
    rootPath = '/usr/biwinas03/scratch-c/sameig/';
    dataPath = dataPathUnix;

%     compile_linux;
else
    codePath = 'H:\codes\';
    rootPath = 'N:/';
    ribsDataPath = 'O:\Bjorn_CT\';
    dataPath = 'N:/Data/dataset';
   
end


codePathRibs=[codePath 'ribFitting/'];
codePathRibsAppearance=[codePath 'ribFitting/appearanceModeling/'];
codePathRibsShape=[codePath 'ribFitting/shapeModeling/'];
codePathSkeleton =   [codePath 'skeleton/'];

codePathVTK = [codePath 'mvonSiebenthal/subscripts/'];

ribModelPath = [ribsDataPath  'ribModel_rotatedEuler'];
ribCageModelPath = [ribsDataPath  'ribCageModel'];

mriDataPath = [rootPath 'Ribs/resized_exhMaster7_unmasked_uncropped_'];
mriSubjectsPath = [rootPath 'Ribs/mriSubjects'];
treePath = [rootPath 'Ribs/Trees/'];
heatMapPath = [rootPath 'Ribs/heatMap'];
mriAnglePath =[rootPath 'Ribs/mriAngleModel'];

addpath(codePath);
addpath(codePathVTK);
addpath(genpath(codePathRibs));
addpath(codePathSkeleton);
addpath(codePathRibsAppearance)
addpath(codePathRibsShape)


% mriSubjects = [18 19 23:28 31:34 50:54 56:59];
mriSubjects = [50:54 56:59];

% subjects = [50:54 56:59];
displayImages =1 ;
nPoints= 100; % Number of points on each rib on the shape model
side='Right';
readVertebraeFlag=0;

numKnots=100;
numKnotAngle=20;
%%
 
rib_nos{18} = [3:8];%4:length(pts{m});%:6:9
rib_nos{19} = [6:9];%4:length(pts{m});%:6:9
rib_nos{23} = [4:9];
rib_nos{24} = [5:9];
rib_nos{25} = [5:9];
rib_nos{26} = [5:9];
rib_nos{27} = [5:9];
rib_nos{28} = [2:9];
rib_nos{31} = [5:10];
rib_nos{32} = [4:8];
rib_nos{33} = [3:9];
rib_nos{34} = [5:9];
% 
% 
% rib_nos{50} = [5:9];
% rib_nos{51} = [3:7];
% rib_nos{52} = [4:8];
% rib_nos{53} = [1:6];
% rib_nos{54} = [1:5];
% % rib_nos{55} = [:];
% rib_nos{56} = [1:5];
% rib_nos{57} = [2:6];
% rib_nos{58} = [1:5];
% rib_nos{59} = [1:5];


% 
% rib_nos{50} = [2:7]; 
% rib_nos{51} = [3:8];
% rib_nos{52} = [4:8];
% rib_nos{53} = [2:6];
% rib_nos{54} = [1:6];
% % rib_nos{55} = [:];
% rib_nos{56} = [1:7];
% rib_nos{57} = [2:6];
% rib_nos{58} = [1:5];
% rib_nos{59} = [1:5];


rib_nos{50} = [1:7]; 
rib_nos{51} = [1:8];
rib_nos{52} = [1:8];
rib_nos{53} = [1:6];
rib_nos{54} = [1:6];
% rib_nos{55} = [:];
rib_nos{56} = [1:7];
rib_nos{57} = [1:6];
rib_nos{58} = [1:5];
rib_nos{59} = [1:6];

% 
% for  s = mriSubjects
%     rib_nos{s}=rib_nos{s}-rib_nos{s}(end)+ mriSubject{s}.ribNumbers(end) ;
% end
%%
loadMRIData;
saveRibsMRI;
computeRibsAnglePointMRI
computeRotationMRI
computeRibsCartilagePoint;

recomputeSplines;
computeRibsRotationMatrixCartilagePoint;
% saveNewRibs;
save(mriSubjectsPath,'mriSubjects')
%%

runFittingSettings
for m = mriSubjects
    [ptsI{m}, rib_nos{m}]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);
end

for s= mriSubjects

    for r= 7:10
        mriSubject{s}.ribs{r}.spc = ptsI{s}{r};
    end
end




%%
n=7;nn=10;
mriSubjects=[ 50    51    52    53    54    56    57    58     60    61    63    64    65    66]
ang_matMRI(mriSubjects,(n-1)*3+1:nn*3)
% ang_mat(:,end-11:end)
% CTangleModel = pcaModeling(ang_mat(:,end-11:end));
MRangleModel = pcaModeling(ang_matMRI(mriSubjects,(n-1)*3+1:nn*3));
MRangleModel.ribNumbers = n:nn;

save(mriAnglePath,'MRangleModel')
%%
close all;
for s = mriSubjects

    figure(s);hold off;
%         plot333(pts{s},'b.',[1 3 2]);

    for rib = 7:10;%mriSubject{s}.ribNumbers %mriSubject{s}.trueRibNumbers-mriSubject{s}.offset
% .
% mriSubject{s}.ribs{m}.boneRibs
            plot333(mriSubject{s}.ribs{rib}.pts,'b.',[1 3 2]);
%             plot333(mriSubject{s}.ribs{rib}.boneRibs    	,'b.',[1 3 2]);
    
%         plot333(mriSubject{s}.ribs{rib}.sp,'b.',[1 3 2]);
        hold on;
%         if  ismember(rib,rib_nos{s}  )
% try
%     if rib==11
%         plot333(mriSubject{s}.ribs{rib}.spc    	,'g.',[1 3 2]);
%     else
%             plot333(mriSubject{s}.ribs{rib}.spc(3:end,:)    	,'b.',[1 3 2]);
%             plot333(mriSubject{s}.ribs{rib}.spc(mriSubject{s}.ribs{rib}.lateralPoint   ,:)    	,'r*',[1 3 2]);

            plot333(mriSubject{s}.ribs{rib}.spc,'r.',[1 3 2]);
    end
        axis equal
% catch
s
rib
end
        hold on;

%     end
    if readVertebraeFlag
    plot333(mriSubject{s}.vertebra.sp1,'b.',[1 3 2]);
    plot333(mriSubject{s}.vertebra.sp2,'b.',[1 3 2]);
    end
    axis equal
% end
 
















