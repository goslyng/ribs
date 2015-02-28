%% Path Settings
function paths = pathSettings(settings)
paths.dataPathUnix = '/usr/biwinas03/scratch-c/sameig/Data/dataset';

ribFolder = 'newRibs/';




if isunix
    paths.codePath = '/home/sameig/codes/';
    paths.ribsDataPathUnix = '/usr/biwinas03/scratch-b/sameig/Bjorn_CT/';
    paths.ribsDataPath = paths.ribsDataPathUnix;
%     rootPath = '/usr/biwinas01/scratch-g/sameig/';  
    paths.rootPath = '/usr/biwinas03/scratch-c/sameig/';

    paths.dataPath = dataPathUnix;
    rfCodePath ='/home/sameig/codes/RF_MexStandalone-v0.02/randomforest-matlab/RF_Class_C';
    addpath(rfCodePath);
    paths.randomForestPath = '/usr/biwinas03/scratch-c/sameig/rfData/';
%     compile_linux;
else
     [~, hostname]=system('hostname');
    if strfind(hostname,'Vina')
        paths.rootPath = 'Z:/N/';
        paths.dataPath = 'Z:/N/Data/dataset';
        paths.codePath = 'H:\codes\';
        paths.ribsDataPath = 'G:\Bjorn_CT\';
    elseif  strfind(hostname,'rr-pc02')
        paths.rootPath = 'G:/Dropbox/';
        paths.dataPath = 'G:/Data/dataset';
        paths.codePath = 'G:/Dropbox/codes/';
        paths.ribsDataPath = 'G:/Bjorn_CT/';
        paths.randomForestPath = 'G:/rfData';
    else
        paths.codePath = 'H:\codes\';
        paths.rootPath = 'N:/';
        paths.ribsDataPath = 'O:\Bjorn_CT\';
        paths.dataPath = 'N:/Data/dataset';
%         addpath(genpath([paths.codePath 'RF_MexStandalone-v0.02-precompiled']));
    end
end
% ribDataPath = [ribsDataPath 'new_'];



paths.codePathSkeleton1=[paths.codePath 'cloudcontr_2_0/matlab/'];
paths.codePathSkeleton2=[paths.codePath 'skeleton/'];

paths.codePathVTK = [paths.codePath 'mvonSiebenthal/subscripts/'];
paths.codeLsqPath = [paths.codePath 'mvonSiebenthal/leastSquaresFitting'];

paths.codePathRancac = [paths.codePath 'ransac'];
paths.codePathRibs=[paths.codePath 'ribFitting/'];

paths.codePathVTK = [paths.codePath 'mvonSiebenthal/subscripts/'];
paths.codePathSkeleton =   [paths.codePath 'skeleton/'];





% ribModelPath = [ribsDataPath  settings.ribModelName];

paths.ribShapeModelPath = [paths.ribsDataPath settings.ribShapeModelName];
% ribShapeCoefModelsPath =[ribsDataPath settings.ribShapeCoefModelsName];
% ribCageLengthModelPath = [ribsDataPath settings.ribCageLengthModeName];
% ribAngleModelCTPath = [ribsDataPath settings.ribAngleModelCTName];
paths.ribcageModelPath = [paths.ribsDataPath settings.ribcageModelName];

% ribShapeModelPath = [ribDataPath 'ribShapeModel_'];
% ribcageModelPath = [ribDataPath 'ribcageModel_'];

paths.ribcageModelPath = [paths.ribsDataPath 'new_' 'ribcageModel_'];
paths.ribShapeModelPath= [paths.ribsDataPath 'new_' 'ribShapeModel_'];
paths.ribcageWOAngleModelPath =  [paths.ribsDataPath 'new_' 'ribcageWOAngleModel'];
paths.mrAnglePath = [paths.rootPath '/Ribs/mriAngleModel'];
% mriDataPath = [rootPath 'Ribs/resized_exhMaster7_unmasked_uncropped_'];


paths.treePath = [paths.rootPath 'Ribs/Trees/'];
%patient specific settinsg


% if exist('m','var')
for m  = settings.allSubjects
    paths.mriDataPath{m} = [ paths.dataPath num2str(m) '/masterframes/resized_exhMaster7_unmasked_uncropped'];

    paths.treePaths{m}  = cell(1,length(settings.rules));

    for r = 1:length(settings.rules)
        paths.treePaths{m}{r} = [paths.treePath settings.treeName settings.rules{r} '_ps_new_' num2str(settings.x_hw) '_' num2str(settings.y_hw) '_s' num2str(m)];
    end
    
    
    if m>59
        paths.heatMapPath{m} = [paths.rootPath 'rfData/heatMaps/s' num2str(m) '/' ];
        if settings.inh
            paths.heatMapPath{m} = [paths.rootPath 'rfData/heatMaps/s' num2str(m) '/inh/' ];
        end

    else
        paths.heatMapPath{m} = [paths.rootPath 'rfData/heatMaps/s' num2str(m) '/' ];        
    end
%     heatMapPath = [rootPath 'Ribs/heatMap' num2str(m) '_' ];
%     heatMapPath = [rootPath 'Ribs/heatMap_s' num2str(m) '_' ];

    paths.heatMapPathRule{m} = cell(1,length(settings.rules));

    for r=1:length(settings.rules)

%         heatMapPathRule{r} = [heatMapPath settings.rules{r} ];
        paths.heatMapPathRule{m}{r} = [paths.heatMapPath{m} num2str(r)  ];

    end
    paths.mriAnglePath =[paths.rootPath 'Ribs/mriAngleModel'];

    if ~isfield('','HypName')
      settings.HypName = 'ribCage_';
    end

    paths.resultsPaths = [paths.rootPath 'Ribs/' settings.HypName num2str(m) '_nComps' num2str(settings.nCompsRibcage) ... 
        '_nW' num2str(settings.wFirstPoint(1)) num2str(settings.wFirstPoint(2)) num2str(settings.wFirstPoint(3)) '_fminIter'];


end
paths.vertebPathMRI  = [paths.rootPath 'vertebrae/'];
paths.vertebraPredictionMatrixPath = [paths.vertebPathMRI 'vertebraMatrix'];

% 
% 
% addpath(codePath);
% addpath(codePathVTK);
% addpath(genpath(codePathRibs));
% addpath(codePathSkeleton);
% addpath(genpath(codePathSkeleton1));
% addpath(genpath(codePathSkeleton2));
% addpath(codePathRancac);
% addpath(codeLsqPath);



paths.randomForestPath = [paths.rootPath '/rfData/'];

paths.im_size_path = [paths.randomForestPath 'im_sizes'];

% 
% for s = ctSubjects
% 
%     subjectDataPath{s} =[ribsDataPath 'v' num2str(s) '/' ribFolder ];
%     vertebPath{s} = [ ribsDataPath 'v' num2str(s) '/' 'ribs/vertebrae/'];
%     subjectsRibsPath{s} = [subjectDataPath{s} 'newRib'];
% end
%     

paths.ribFolder = 'newRibs/';


    