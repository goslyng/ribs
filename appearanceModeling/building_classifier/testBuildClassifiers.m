
% clear all;
% leftOuts = mriSubjects;
%% Parameter Setting

runFittingSettings;

x_hw = settings.x_hw;
y_hw = settings.y_hw;
z_hw = settings.z_hw;
settings.patch_size=[11 11 0];
patch_size = settings.patch_size;
numTrees = settings.numTrees;

side = settings.side;
ribNumbers=settings.ribNumber;


%% Path Settings
clear m;
pathSettings;
%Tree Path Name
for rule=1:length(settings.rules)
    for s = mriSubjects 

       treePaths{rule}{s} = [treePath treeName settings.rules{rule} '_ps_new_' num2str(patch_size(1)) '_' num2str(patch_size(2)) '_s' num2str(s)];     

    end
    
end

for s = mriSubjects 
    
    subjectDataPath{s}=[ dataPath num2str(s) '/ribs/'];
    for r=settings.ribNumber
        groundTruthRibsPath{s}{r} = [subjectDataPath{s} 'Rib' side 'New' num2str(r)];
    end
end

classifierResultPath = [treePath 'results' treeName num2str(patch_size(1)) '_' num2str(patch_size(2))];

%% Load Images


for s = mriSubjects
    tmp=load ( [mriDataPath num2str(s)],'im');
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
	for rule=1:length(settings.rules)
    	selectedPoints{rule}{s} = [];
        ribP{rule}{s}=[];
        for r=ribNumbers

            tmpPoints = transCoord(newPtsRibs{s,r},settings.ap,settings.is,settings.lr);
            pIndices = selectPointsR(tmpPoints,settings.rules{rule},settings);
            selectedPoints{rule}{s} = [selectedPoints{rule}{s} newPtsRibs{s,r}(:,pIndices)];
            ribP{rule}{s}=[ribP{rule}{s} r*ones(1,sum(pIndices))];
        end
	end
end


%%

for rule=1:length(settings.rules)
     
    [ribPatches{rule}(mriSubjects),nonRibPatches{rule}(mriSubjects), validPts(mriSubjects)] = ...
        extractPatches2DNew(im(mriSubjects), selectedPoints{rule}(mriSubjects), patch_size);
    
    featuresRibs{rule} =  extractFeatures(ribPatches{rule},patch_size,'meanCenter2');
    featuresNonRibs{rule}=  extractFeatures(nonRibPatches{rule},patch_size,'meanCenter2');
    
    for s=mriSubjects
        selectedPoints{rule}{s} = selectedPoints{rule}{s}(validPts{s});
        ribP{rule}{s} = ribP{rule}{s}(validPts{s});
    end
    
end
    %%
for rule=1:length(settings.rules)

    for s = mriSubjects
        try
        load( treePaths{rule}{s} ,'treeModel')
        treeM{s}{rule}=treeModel;
        catch
            s
        end

    end
end
%%


for s = mriSubjects([1:3 5:9])
%     prob_{s} =[];
    for rule=1:length(settings.rules)

        leftOut = s;

        test_patches = [featuresRibs{rule}{s} ]';
        test_categories =  [ones(1,size(featuresRibs{rule}{s},2)),]';


        [predicted_categories, vote] = classRF_predict(test_patches,treeM{s}{rule});

        prob=vote(:,2)/numTrees;
        accuracy_(rule,s) = mean( prob);
        for r=ribNumbers
            probs{rule,s,r}= prob(ribP{rule}{s}==r);
        end
    end
%     mean(cell2mat(accuracy{rule}(mriSubjects)))

end
% mean(cell2mat(accuracy{rule}(mriSubjects)))
%%
% end
% ribP{rule}{s}
% probs =[mean((accuracy_(1,mriSubjects)))
%  mean((accuracy_(2,mriSubjects)))
%  mean((accuracy_(3,mriSubjects)))
%  mean((accuracy_(4,mriSubjects)))];
prob = accuracy_;
save(classifierResultPath,'prob');


%     0.8993    0.6992    0.6729    0.4126
%     0.8039    0.7746    0.5538    0.4882
%     0.8774    0.4932    0.5728    0.5517
%          0         0         0         0
%     0.8004    0.5997    0.6169    0.5198
%     0.9136    0.7120    0.5577    0.5960
%     0.8057    0.6254    0.3965    0.5357
%     0.8562    0.7056    0.5142    0.4573
%     0.9010    0.6611    0.4614    0.5295

    