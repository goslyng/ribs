clear all;

runFittingSettings;

settings.ribNumber = 6:10;
ribNumbers=settings.ribNumber;
settings.patch_size=[15 15 0];
patch_size=settings.patch_size;

x_hw = settings.patch_size(1);
y_hw = settings.patch_size(2);
z_hw = settings.patch_size(3);

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
% mriSubjectsBH =[]; [60   63    64    65    66];
% mriSubjects=[ 18 19 23:28 31 33:34 ];
%%

pathSettings;

if isunix
    randomForestPath = '/usr/biwinas03/scratch-c/sameig/rfData/';
else
    randomForestPath = 'N:\rfData';
end

codePath = '/home/sameig/codes/randomForest/';
im_size_path = [randomForestPath 'im_sizes'];

imPath_ = [randomForestPath 'ims/s' ];
indexPath = [randomForestPath 'indexFiles/'];
resultsPath_ = [randomForestPath 'results/'];
exePath = [codePath 'ribdetect'];
configPath =[randomForestPath 'config_ribcage.txt'];
heatMapsPath = [randomForestPath 'heatMaps/'];
sungridPath = [randomForestPath 'sungrid/'];

addpath(codePath)

featuresName_ = sprintf('%s%d',sprintf('%d',features(1:end-1)),features(end));

sidesTag=[];

for i=1:length(sides)
    sidesTag = [sidesTag sides{i}(1)];
end

testPreFix   = [indexPath     'ribs_test'   ];
trainPreFix  = [indexPath     'ribs_train'  ];
resultPreFix = [resultsPath_  'ribs_results']; 

postFix = [ '_' sidesTag '_' sprintf('%d',ribNumbers) '.txt'];
heatMapPostFix = ['.txt'];

treePreFix = ['Trees/' 'T' num2str(nTests) '_' num2str(maxDepth) '_' num2str(minSamplesPerNode) '_' num2str(patchSize) '_' featuresName_ ];
% treePreFix = [treePreFix ];

for s = mriSubjects
    
    mriDataPath{s} = [ dataPathUnix num2str(s) '/masterframes/resized_exhMaster7_unmasked_uncropped'];

    for rule=1:4
        
            middleFix = ['_' num2str(s) '_' num2str(rule)];
            
            train_index_path{s,rule} = [trainPreFix  middleFix 'nonRibAllPoints' postFix];        
            test_index_path{s,rule}  = [testPreFix   middleFix 'nonRibAllPoints' postFix];
            
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
    
    system(['mkdir ' heatMapSubjectPath{s}]);

    heatMapIndexPath{s} = sprintf('%sindexFiles/',heatMapSubjectPath{s} );
    system(['mkdir ' heatMapIndexPath{s}]);

    heatMapInhPath{s} = sprintf('%ss%d/inh/',heatMapsPath,s);
    system(['mkdir ' heatMapInhPath{s}]);
    
    heatMapInhIndexPath{s} = sprintf('%sinh/indexFiles/',heatMapSubjectPath{s} );
    system(['mkdir ' heatMapInhIndexPath{s}]);
    
    
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
close all
for s=mriSubjects
    figure(s);hold on
    for r= settings.ribNumber
    plot33(newPtsRibs{s,r,1}(:,1:100),'b.',[1 3 2]);
    end
axis equal
end
%%
side = 'Right';

 for s = mriSubjects 

        display(['Subject : ' num2str(s)]);

            subjectDataPath{s}=[ dataPath num2str(s) '/ribs/'];
            for r=1:12%settings.ribNumber

                groundTruthRibsPath = [subjectDataPath{s} 'Rib' side 'New' num2str(r)];
                groundTruthRibsNewPath = [subjectDataPath{s} 'Rib' side '120' num2str(r)];
                try
                newPtsRibs{s}{r}=readVTKPolyDataPoints(groundTruthRibsPath);
                writeVTKPolyDataPoints(groundTruthRibsNewPath,newPtsRibs{s}{r});
                catch
                    s
                    i
                    r
                end

            end
       


 end
    
 %%
 for s = mriSubjects 

            subjectDataPath{s}=[ dataPath num2str(s) '/ribs/'];
            for r=1:length(newPtsRibs{s})
                try
                groundTruthRibsPath = [subjectDataPath{s} 'Rib' side 'New' num2str(r)];

                writeVTKPolyDataPoints(groundTruthRibsPath,newPtsRibs{s}{r}(:,1:100));

                
                
                catch
                    s
                    i
                    r
                end

            end
            groundTruthRibsPath = [subjectDataPath{s} 'Rib' side 'New7_10'];

            writeVTKPolyDataPoints(groundTruthRibsPath,[newPtsRibs{s}{7}(:,1:100)...
            newPtsRibs{s}{8}(:,1:100) ...
            newPtsRibs{s}{9}(:,1:100) ...
            newPtsRibs{s}{10}(:,1:100) ]);



 end
 %%
 
 

