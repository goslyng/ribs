addpath(genpath('G:\Dropbox\codes\'))

clear all;

runFittingSettings;

%settings.ribNumber = 6:10;
%ribNumbers=settings.ribNumber;
% settings.patch_size=[15 15 0];
% patch_size=settings.patch_size;

% x_hw = settings.patch_size(1);
% y_hw = settings.patch_size(2);
% z_hw = settings.patch_size(3);

writeImages= 0;
loadImages = 1;

sides={'Right'};    %{'Right','Left'};%


nTrees=10;

nTests=1000;
maxDepth=20;
minSamplesPerNode=10;
patchSize=30;
features=1:5;
mriSubjects =[50 51 52 53 54 550 56 57 58 59 60 61 63 64 65 66];
mriSubjectsBH =[]; [60   63    64    65    66];
mriSubjects=[ 18 19 23:28 31 33:34 50 51 52 53 54  56 57 58 59 60 61 63 64 65 66];
leftoutSetS=[18 19 23:28 31 33:34];
%%
settings=exportSettings();
paths = pathSettings(settings);


localRFCodePath = [ paths.codePath '/randomForest/'];
im_size_path = [paths.randomForestPath 'im_sizes'];

imPath_ = [paths.randomForestPath 'ims/s' ];
indexPath = [paths.randomForestPath 'indexFiles/'];
resultsPath_ = [paths.randomForestPath 'results/'];
exePath = [localRFCodePath 'ribdetect'];
configPath =[paths.randomForestPath 'config_ribcage.txt'];
heatMapsPath = [paths.randomForestPath 'heatMaps/'];
sungridPath = [paths.randomForestPath 'sungrid/'];

addpath(localRFCodePath)
addpath(paths.codePath);
featuresName_ = sprintf('%s%d',sprintf('%d',features(1:end-1)),features(end));

sidesTag=[];

for i=1:length(sides)
    sidesTag = [sidesTag sides{i}(1)];
end

testPreFix   = [indexPath     'ribs_test'   ];
trainPreFix  = [indexPath     'ribs_train'  ];
resultPreFix = [resultsPath_  'ribs_results']; 

postFix = [ '_' sidesTag '_' sprintf('%d',settings.ribNumber) '.txt'];
heatMapPostFix = ['.txt'];

treePreFix = ['Trees/' 'T' num2str(nTests) '_' num2str(maxDepth) '_' num2str(minSamplesPerNode) '_' num2str(patchSize) '_' featuresName_ ];
% treePreFix = [treePreFix ];

for s = mriSubjects
    
    mriDataPath{s} = [ dataPath num2str(s) '/masterframes/resized_exhMaster7_unmasked_uncropped'];

    for rule=1:4
        
            middleFix = ['_' num2str(s) '_' num2str(rule)];
            
%             train_index_path{s,rule} = [trainPreFix  middleFix 'nonRibAllPoints' postFix];        
%             test_index_path{s,rule}  = [testPreFix   middleFix 'nonRibAllPoints' postFix];
            train_index_path{s,rule} = [trainPreFix  middleFix '' postFix];        
            test_index_path{s,rule}  = [testPreFix   middleFix '' postFix];         
            
            treeFolder{s,rule} = [ treePreFix middleFix postFix(1:end-4) '/' ];
            heatmapResultsPath{s,rule} = [heatMapsPath 'heatMap' middleFix postFix];
            resultsPath{s,rule} = [ resultPreFix middleFix postFix];
            resultsPathAll{s,rule} = [ resultPreFix middleFix '_allRules' postFix]; 
            
            sungridHeatmapSubjectPath{s,rule} = [sungridPath 'sungrid_heatmap' middleFix postFix(1:end-4) '.sh'];
            sungridHeatmapInhSubjectPath{s,rule} = [sungridPath 'sungrid_heatmap_inh_' middleFix postFix(1:end-4) '.sh'];

    end

% 	treeFolderAll{s}=sprintf('Trees/rf_%s_%d_all_nTs%dmd%dms%dps%df%s/',sidesTag,s,nTests,maxDepth,minSamplesPerNode,patchSize,featuresName_);
% 	treeFolderAllTmp=sprintf('Trees/rf_%s_${1}_all_nTs%dmd%dms%dps%df%s/',sidesTag,nTests,maxDepth,minSamplesPerNode,patchSize,featuresName_);
    
    allMiddleFix = [num2str(s) '_allRules' ];

    heatMapSubjectPath{s} = sprintf('%ss%d/',heatMapsPath,s);
    if exist(heatMapSubjectPath{s},'dir')~=7
        mkdir(heatMapSubjectPath{s});
    end
    
    heatMapIndexPath{s} = sprintf('%sindexFiles/',heatMapSubjectPath{s} );
    if exist(heatMapIndexPath{s},'dir')~=7
        mkdir(heatMapIndexPath{s});
    end
    
    heatMapInhPath{s} = sprintf('%ss%d/inh/',heatMapsPath,s);
    if exist(heatMapInhPath{s},'dir')~=7
        mkdir(heatMapInhPath{s});
    end
    
    heatMapInhIndexPath{s} = sprintf('%sinh/indexFiles/',heatMapSubjectPath{s} );
    if exist(heatMapInhIndexPath{s},'dir')~=7
        mkdir(heatMapInhIndexPath{s});
    end
    
    
    train_index_path_allrules{s} = [trainPreFix allMiddleFix postFix];
%     test_index_path_allrules{s} = [testPreFix allMiddleFix postFix];
    sungridPathSubject{s}  = [sungridPath 'sungrid_test_' num2str(s)  postFix(1:end-4)  '.sh'];
    sungridTrainingPaths{s} = [sungridPath 'sungrid_train_' num2str(s)  postFix(1:end-4)  '.sh'];
    
    
end 

heatMapIndexPathTmp = [heatMapsPath 's${1}/indexFiles/${3}.txt '];
heatMapsResultPathTmp = [heatMapsPath 's${1}/${2}_${3}' postFix];

heatMapInhIndexPathTmp = [heatMapsPath 's${1}/inh/indexFiles/${3}.txt '];
heatMapsInhResultPathTmp = [heatMapsPath 's${1}/inh/${2}_${3}' postFix];

sungridHeatmapInhPath =  [sungridPath 'sungrid_heatmap_ing_sub' postFix(1:end-4) '.sh'];
sungridHeatmapPath = [sungridPath 'sungrid_heatmap_sub' postFix(1:end-4) '.sh'];
sungridHeatmapPathGeneral = [sungridPath 'sungrid_heatmap_sub_general' postFix(1:end-4) '.sh'];
evaluteTreePath = [sungridPath 'sungrid_evaluate_trees' postFix(1:end-4)  '.sh'];
sungridTrainingPath = [sungridPath 'sungrid_training_sub' postFix(1:end-4) '.sh'];


tmpMiddleFix = '_${1}_${2}';
tmpMiddleFixGeneral = '_550_${2}';

treePathTmp = [ treePreFix  tmpMiddleFix postFix(1:end-4) '/' ];
treePathTmpGeneral =[ treePreFix tmpMiddleFixGeneral postFix(1:end-4) '/' ];
testPathTmp = [testPreFix tmpMiddleFix postFix];
resultPathTmp = [resultPreFix tmpMiddleFix postFix  ];
resultPathAllTmp = [resultPreFix tmpMiddleFix '_allRules' postFix]; 
trainPathTmp = [trainPreFix tmpMiddleFix postFix];



%%
% saveRec2HDR
% resize_images_hdr
% rfWriteImages

resize_images_hdr(mriSubjects)

for s = mriSubjects
    rfWriteImages(s)
end
%%

writeConfigFile;


%% write index files



for s=mriSubjects

    subjectDataPath = [paths.dataPath num2str(s) '/'];
    imPath = [subjectDataPath 'masterframes/resized_exhMaster7_unmasked_uncropped'];
    load(imPath,'im');
    [s_1(s), s_2(s), s_3(s)]=size(im);
    
end

if exist('s_1','var')

    save(im_size_path,'s_1','s_2','s_3');
else
    load(im_size_path,'s_1','s_2','s_3');
end



%% Write the files

writeTestTrainFiles
writeHeatmapFile;
    

%% Train individual forests based on the position of the points


writeSungridTraining;

for s = leftoutSetS% mriSubjects

    fprintf(1,['qsub ' sungridTrainingPaths{s} '\n']);
%     system(['qsub ' sungridTrainingPaths{s} ]);
end



%% Compute Heat Maps

writeSungridHeatMap
writeSungridHeatMapInh;

for s = mriSubjects
    for r=1:4

        fprintf(1,['qsub ' sungridHeatmapSubjectPath{s,r} '\n']);
        

%         system(['qsub ' sungridHeatmapSubjectPath{s,r} ]);
    end
end

for s =mriSubjectsBH
    for r=1:4

%         fprintf(1,['qsub ' sungridHeatmapSubjectPath{s,r} '\n']);
%         fprintf(1,['qsub ' sungridHeatmapInhSubjectPath{s,r} '\n']);

        system(['qsub ' sungridHeatmapSubjectPath{s,r} ]);
    end
end
    fprintf(1, '\n');

%% compute the optimum parameters of the ribcage

inh=0;
for iter = 1:3
    for s = mriSubjects
        setAngeModulOpt_iterWF2(s,iter,inh)
    end
end


inh=1;

for iter = 1:3
    for s =mriSubjectsBH
        setAngeModulOpt_iterWF2(s,iter,inh)

    end
end
%% construct and evaluate the best parameters 


nBest=1;
iter=1;
displayImages=1;

inh=0;

for s = mriSubjects (12:end)
    
    [ errs1,errs2, costs,ribError1,ribError2,lenError,outOfPlaneError]  = ...
        displayAngleIndividualScaleN(s,nBest,iter,displayImages,inh);
    
end

inh=1;

for s = mriSubjectsBH
    
    [ errs1,errs2, costs,ribError1,ribError2,lenError,outOfPlaneError]  = ...
        displayAngleIndividualScaleN(s,nBest,iter,displayImages,inh);
    
end


%% Evaluate forest

writeSungridEvaluate

for s =mriSubjects

    fprintf(1,['qsub ' sungridPathSubject{s} '\n']);
%     system(['qsub ' sungridPathSubject{s} ]);
end




%% Load results 

% resPath =  resultsPathAll;
resPath =  resultsPath;
clear res
for s= mriSubjects  
    
    for rule=1:4 
       try
        fid = fopen(resPath{s,rule} );
%         fid = fopen('fgetl.m');
        tline = fgetl(fid);
        while ischar(tline)
            
            text1 = sscanf(tline,'Neg accuracy: %f');
            text2 = sscanf(tline,'Pos accuracy: %f');
            
            if (~isempty(text1))
                res(s,rule,1) = text1;
            end
            if (~isempty(text2))
                res(s,rule,2) = text2;
            end           
            tline = fgetl(fid);
%            res(s,rule,:) = fscanf(fid,'Neg accuracy: %f\nPos accuracy: %f');

        end

        fclose(fid);
%         res(s,rule,:) = fscanf(fid,'Neg accuracy: %f\nPos accuracy: %f');
%         fclose(fid);
       catch
           s
           rule
       end
    end
end
res(mriSubjects,:,:)

% Pos right side using Trees trained on both sides using all rules 
%     0.8287    0.6070    0.7431    0.5157
% Pos Right Side using Trees trained on both sides
%     0.8380    0.6554    0.7198    0.5187
% Pos right side using Trees trained on right side using all rules 
%     0.8610    0.6520    0.7853    0.5683
% Pos Right Side using Trees trained on right side
%     0.8755    0.6936    0.7527    0.7200
% Pos Right Side using Trees trained on right side being trained on ribs
% 6-10
%     0.8811    0.6966    0.7744    0.7335
% Pos Right Side using Trees trained on right side being trained on ribs
% 6-10 100 trees
%     0.8573    0.7119    0.7837    0.7199
% Pos Right Side using Trees trained on right side being trained on ribs
% 6-9 100 trees
%     0.8643    0.7306    0.7852    0.7103
% Pos Right Side using Trees trained on right side being trained on ribs
% 6-9 10 trees
%     0.8726    0.7315    0.7965    0.7072








