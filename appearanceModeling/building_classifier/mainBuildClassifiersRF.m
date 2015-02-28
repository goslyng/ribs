

function mainBuildClassifiersRF(m,rule)

% clear all;
% leftOuts = mriSubjects;
%% Parameter Setting

runFittingSettings;

patch_size = settings.patch_size;

side=settings.side;
ribNumbers=settings.ribNumber;


%% Path Settings

pathSettings;

for s = mriSubjects 
    
    subjectDataPath{s}=[ dataPath num2str(s) '/ribs/'];
    for r=settings.ribNumber
        groundTruthRibsPath{s}{r} = [subjectDataPath{s} 'Rib' side 'New' num2str(r)];
    end
end


%% Load Images


for s = mriSubjects
    tmp=load( [mriDataPath num2str(s)],'im');
    im{s}=tmp.im;
 
end



%% Load VTK files of new database

for s = mriSubjects 
    

    display(['Subject : ' num2str(s)]);

    for rib=settings.ribNumber
     
        newPtsRibs{s,rib}=readVTKPolyDataPoints(groundTruthRibsPath{s}{rib});

    end


end

%% Sort points based on z, and build a classifier only based on the first points

for s= mriSubjects 
    
    
% 	for i=1:length(settings.rules)
    	selectedPoints{rule}{s} = [];
        for r=ribNumbers

            tmpPoints = transCoord(newPtsRibs{s,r},settings.ap,settings.is,settings.lr);
            selectedPoints{rule}{s} = [selectedPoints{rule}{s} newPtsRibs{s,r}(:,selectPointsR(tmpPoints,settings.rules{rule},settings))];
        end

%     end
end



%%

%  for i=1:length(settings.rules)
     
    [ribPatches{rule}(mriSubjects),nonRibPatches{rule}(mriSubjects)] = ...
        extractPatches2DNew(im(mriSubjects), selectedPoints{rule}(mriSubjects), patch_size);
    featuresRibs{rule} =  extractFeatures(ribPatches{rule},patch_size,'meanCenter2');
    featuresNonRibs{rule}=  extractFeatures(nonRibPatches{rule},patch_size,'meanCenter2');

%  end


%%


leftOuts=m;
% for s= mriSubjects 
%     s
% for i=1:length(settings.rules)
    settings.rules{rule}
    treePathsM{m}=treePaths{rule};
    treeModels{rule} = buildTreeRibs2D(treePathsM,featuresRibs{rule},featuresNonRibs{rule},leftOuts,settings.numTrees,'meanCenter2');
% end
% end


%%

