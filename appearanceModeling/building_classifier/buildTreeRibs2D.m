
function tree = buildTreeRibs2D(treePath,ribPatches,nonRibPatches,leftOut,numTrees,featureType)


if (isunix)
    
    rfCodePath ='/home/sameig/codes/RF_MexStandalone-v0.02/randomforest-matlab/RF_Class_C';
    cd(rfCodePath);
%     compile_linux;
else
       codePath='H:/codes/';

    addpath(genpath([codePath 'RF_MexStandalone-v0.02-precompiled']));

end
%% Build Random Forest Classifier

for i=1:length(ribPatches)
    
    featureVector{i} = [ribPatches{i} nonRibPatches{i}]';
    categories{i} = [ones(1,size(ribPatches{i},2)), zeros(1,size(nonRibPatches{i},2))]';
    
    
end

offset = 0 ;
allFeatureVectors=[];
allCategories=[];

for i=1:length(ribPatches)
    
    numFeatures(i) =  size(featureVector{i},1) ;
    samples{i} = offset + (1 : numFeatures(i));
    
    allFeatureVectors = [allFeatureVectors;featureVector{i}];
    allCategories = [allCategories ;categories{i}];
    
    offset = offset + numFeatures(i);
end


allsamples =  1: size(allFeatureVectors,1);
display(['Building tree for subject no' ])
for i = leftOut
    display([num2str(i) ' ...' ])
    leftOutPatches = samples{i};
    training_vector = setdiff(allsamples, leftOutPatches);
    
    tree{i} = classRF_train(allFeatureVectors(training_vector,:),allCategories(training_vector,:),numTrees);
    display('Done!' );
    treeModel=tree{i};
    treeModel.featureType=featureType;
    save(treePath{i},'treeModel');

end