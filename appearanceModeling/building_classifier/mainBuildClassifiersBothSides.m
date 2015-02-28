

function mainBuildClassifiersBothSides(m,rule)

% clear all;
% leftOuts = mriSubjects;
%% Parameter Setting

runFittingSettings;

patch_size = settings.patch_size;

% side=settings.side;
ribNumbers=settings.ribNumber;

sides={'Right','Left'};

%% Path Settings

pathSettings;


%% Load Images


for s = mriSubjects
    tmp=load( [mriDataPath num2str(s)],'im');
    im{s}=tmp.im;
 
end



%% Load VTK files of new database

for s = mriSubjects 
    

    display(['Subject : ' num2str(s)]);

    for i = 1:length(sides)
        side = sides{i};
        subjectDataPath{s}=[ dataPath num2str(s) '/ribs/'];
        for r=settings.ribNumber
            groundTruthRibsPath = [subjectDataPath{s} 'Rib' side 'New' num2str(r)];
            newPtsRibs{s,r,i}=readVTKPolyDataPoints(groundTruthRibsPath);

        end
    end


end

%% Sort points based on z, and build a classifier only based on the first points

for s= mriSubjects 
    
    
% 	for i=1:length(settings.rules)
    for i = 1:length(sides)

    	selectedPoints{rule}{s} = [];
        for r=ribNumbers

            tmpPoints = transCoord(newPtsRibs{s,r,i},settings.ap,settings.is,settings.lr);
            selectedPoints{i}{rule}{s} = [selectedPoints{rule}{s} newPtsRibs{s,r,i}(:,selectPointsR(tmpPoints,settings.rules{rule},sides{i},settings))];
        end
    end

%     end
end



%%

%  for i=1:length(settings.rules)
    
    for i = 1:length(sides)

    [ribPatches_side{i},nonRibPatches_side{i}] = ...
        extractPatches2DNew(im(mriSubjects), selectedPoints{i}{rule}(mriSubjects), patch_size);
    end
    for j=1:length(ribPatches_side{1})
        ribPatches{rule}{j} =[ ribPatches_side{1}{j} ribPatches_side{2}{j}];
        nonRibPatches{rule}{j} =[ nonRibPatches_side{1}{j} nonRibPatches_side{2}{j}];
        
    end
      
    featuresRibs{rule}(mriSubjects) =  extractFeatures(ribPatches{rule},patch_size,'meanCenter2');
    featuresNonRibs{rule}(mriSubjects)=  extractFeatures(nonRibPatches{rule},patch_size,'meanCenter2');

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

