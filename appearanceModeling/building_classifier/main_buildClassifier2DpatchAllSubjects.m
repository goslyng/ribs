
% clear all;


%% Path Settings


dataPathUnix = '/usr/biwinas01/scratch-g/sameig/Data/dataset';

if isunix
    codePath = '/home/sameig/codes/';
    rootPath = '/usr/biwinas01/scratch-g/sameig/';
    dataPath = dataPathUnix;
    rfCodePath ='/home/sameig/codes/RF_MexStandalone-v0.02/randomforest-matlab/RF_Class_C';
    cd(rfCodePath);
    compile_linux;
else
    codePath = 'H:\codes\';
    rootPath = 'N:/';
    dataPath = 'N:/Data/dataset';
   addpath(genpath([codePath 'RF_MexStandalone-v0.02-precompiled']));

 
end
    

codePathRibs=[codePath 'ribFitting/'];

addpath(codePath);
addpath(genpath(codePathRibs));

treePath = [rootPath 'Ribs/Trees/'];
mriDataPath = [rootPath 'Ribs/resized_exhMaster7_unmasked_uncropped_'];



%% Parameter Setting

x_hw = 15;
y_hw = 15;
z_hw = 1;
patch_size = [x_hw, y_hw, z_hw];
numTrees = 500;

mriSubjects= [18 19 23:28 31:34 50:51 52 53 54 56 57 58 59];
% mriSubjects = [50 51 52 53 54 56 58 59];
newI = [13:18 20:21];

side='Right'

%% Load Images


for s = mriSubjects
%     subject = subjects(i);
    try

    tmp=load( [mriDataPath num2str(s)],'im');
    im{s}=tmp.im;
    catch
        s
    end
end



%% Load VTK files of new database

for s = mriSubjects 
    

    display(['Subject : ' num2str(s)]);

    subjectDataPath=[ dataPath num2str(s) '/ribs/'];

    ribs=[];

    for rib=1:12

%         [str, out]=system(['ls ' subjectDataPath 'Rib' side 'New' num2str(rib) '.vtk']);
%         if str==0
try
            ribFile{rib} = [subjectDataPath 'Rib' side 'New' num2str(rib)];
            newPtsRibs{s,rib}=readVTKPolyDataPoints(ribFile{rib});
            ribs=[ribs rib];
catch
end
%         end
    end


    ribPath =[subjectDataPath 'RibRightNewAll'];
    newPts{s} = readVTKPolyDataPoints(ribPath);


end
%% Tree Path Name
for s = mriSubjects %i=13:length(subjects)


   treePaths{1,s} = [treePath 'tree_cntr2_angle_ps_new_' num2str(patch_size(1)) '_' num2str(patch_size(2)) '_s' num2str(s)];     

   treePaths{2,s} = [treePath 'tree_cntr2_last_ps_new_' num2str(patch_size(1)) '_' num2str(patch_size(2)) '_s' num2str(s)];     

   treePaths{3,s} = [treePath 'tree_cntr2_middle_ps_new_' num2str(patch_size(1)) '_' num2str(patch_size(2)) '_s' num2str(s)];     

   treePaths{4,s} = [treePath 'tree_cntr2_postSagittal_ps_new_' num2str(patch_size(1)) '_' num2str(patch_size(2)) '_s' num2str(s)];     

    
end
%% Sort points based on z, and build a classifier only based on the first points
i = 20;%the ribs have been parametereized so that the ith point is angle point
ribNumbers=7:10

for s= mriSubjects %s = newI
        

%     figure(s);
%     hold off;
%     plot33(newPts{s},'b.'); hold on;
    anglePts{s}=[];

    for m=ribNumbers%mriSubject{s}.ribNumbers%  ribNumbersAngle
      
%         plot33(mriSubject{s}.ribs{m}.spc,'b.');
        anglePts{s} =[anglePts{s} newPtsRibs{s,m}(:,1:i)];%pts{s}(:, indx);
%         hold on;
    end
%     plot33(anglePts{s},'r.');
%     input(num2str(s))

end
%%  Sort points based on z, and build a classifier only based on the last sagittal points

for s = mriSubjects
%     figure(s);
%     hold off;
%     plot33(newPts{s},'b.'); hold on;
    lastPts{s}=[];

    for m=ribNumbers%mriSubject{s}.ribNumbers%  ribNumbersAngle
%     plot33(newPtsRibs{s,m},'b.'); hold on;
        threshZ = min(newPtsRibs{s,m}(3,:)) + 5;

        indx = find(newPtsRibs{s,m}(3,:)<threshZ );%& pts{s}(1,:)>midX)
        f(s,m)=indx(1);
        l(s,m)=indx(end);
        
        lastPts{s} =[lastPts{s} newPtsRibs{s,m}(:,indx)];%pts{s}(:, indx);

%         hold on;

    end
%     plot33(lastPts{s},'r.');
%     axis equal
%     input(num2str(s))

end 

%%  Sort points based on z, and build a classifier only based on the points between angle and last sagittal

for s = mriSubjects
%     figure(s);
%     hold off;
%     plot33(newPts{s},'b.'); hold on;
    middlePts{s}=[];

    for m=ribNumbers%mriSubject{s}.ribNumbers%  ribNumbersAngle

        middlePts{s} =[middlePts{s} newPtsRibs{s,m}(:,25:f(s,m))];%pts{s}(:, indx);

%         hold on;

    end
%     plot33(middlePts{s},'r.');
%     axis equal
%     input(num2str(s))

end 
%%  Sort points based on z, and build a classifier only based on the points after sagittal

for s = mriSubjects
%     figure(s);
%     hold off;
%     plot33(newPts{s},'b.'); hold on;
    postSagittalPts{s}=[];

    for m=ribNumbers%mriSubject{s}.ribNumbers%  ribNumbersAngle


        
        postSagittalPts{s} =[postSagittalPts{s} newPtsRibs{s,m}(:,l(s,m):end)];%pts{s}(:, indx);

        hold on;

    end
%     plot33(postSagittalPts{s},'r.');
%     axis equal
%     input(num2str(s))

end 



%%

[ribPatchesAngle(mriSubjects),nonRibPatchesAngle(mriSubjects)] = extractPatches2DNew(im(mriSubjects), anglePts(mriSubjects), patch_size);%,debugMode);
[ribPatchesLast(mriSubjects),nonRibPatchesLast(mriSubjects)]  = extractPatches2DNew(im(mriSubjects), lastPts(mriSubjects), patch_size);%,debugMode);
[ribPatchesMiddle(mriSubjects),nonRibPatchesMiddle(mriSubjects)]  = extractPatches2DNew(im(mriSubjects), middlePts(mriSubjects), patch_size);%,debugMode);
[ribPatchesPostSagittal(mriSubjects),nonRibPatchesPostSagittal(mriSubjects)]  = extractPatches2DNew(im(mriSubjects), postSagittalPts(mriSubjects), patch_size);%,debugMode);

%% View the patches
% m=53;
% figure;
% 
% z_vec = unique(floor(anglePts{m}(3,:)));
% 
% for z=z_vec
%     imshow(im{m}(end:-1:1,:,z),[]);
%     ppp = anglePts{m}(:,floor(anglePts{m}(3,:))  ==z); 
%     hold on;
%     plot(ppp(1,:),size(im{m},1)-ppp(2,:)+1,'r.');
%     input(num2str(z))
% end
% imshow(reshape(ribPatches{1}(:,1),2*patch_size(1)+1,2*patch_size(2)+1),[]);
%%


featuresRibs{1} =  extractFeatures(ribPatchesAngle,patch_size,'meanCenter2');
featuresNonRibs{1}=  extractFeatures(nonRibPatchesAngle,patch_size,'meanCenter2');


featuresRibs{2} =  extractFeatures(ribPatchesLast,patch_size,'meanCenter2');
featuresNonRibs{2} =  extractFeatures(nonRibPatchesLast,patch_size,'meanCenter2');


featuresRibs{3} =  extractFeatures(ribPatchesMiddle,patch_size,'meanCenter2');
featuresNonRibs{3} =  extractFeatures(nonRibPatchesMiddle,patch_size,'meanCenter2');

featuresRibs{4}=  extractFeatures(ribPatchesPostSagittal,patch_size,'meanCenter2');
featuresNonRibs{4} =  extractFeatures(nonRibPatchesPostSagittal,patch_size,'meanCenter2');



leftOuts = mriSubjects;

treeModels{m} = buildTreeRibs2D(treePathsCenter2Angle,featuresRibs{m},featuresNonRibs{m},leftOuts,numTrees,'meanCenter2');

% treeModelsCntr2Last = buildTreeRibs2D(treePathsCenter2Last,featuresRibsLast,featuresNonRibsLast,leftOuts,numTrees,'meanCenter2');

% treeModelsCntr2Middle = buildTreeRibs2D(treePathsCenter2Middle,featuresRibsMiddle,featuresNonRibsMiddle,leftOuts,numTrees,'meanCenter2');

% treeModelsCntr2PostSagittal = buildTreeRibs2D(treePathsCenter2PostSagittal,featuresRibsPostSagittal,featuresNonRibsPostSagittal,leftOuts,numTrees,'meanCenter2');


%%

% indx=1:length(subjects)
% featuresRibs =featuresRibsAngle;%featuresRibsLast;% featuresRibsMiddle;%featuresRibsPostSagittal;%
% featuresNonRibs = featuresNonRibsAngle;%featuresNonRibsLast;%featuresNonRibsMiddle;%featuresNonRibsPostSagittal;%
    
% treeM = treeModelsCntr2PostSagittal;%treeModelsCntr2Middle;%treeModelsCntr2Last;%treeModelsCntr2Angle;
% treePathsCenter2Angle{s} 
% 
%    treePathsCenter2Last{s} 
% 
%    treePathsCenter2Middle{s}
% 
%    treePathsCenter2PostSagittal{s} 


for m=1:4
    for s = mriSubjects
        try
        load(treePaths{m,s},'treeModel')
        treeM{m,s}=treeModel;
        catch
            s
        end

    end
    for s = mriSubjects

        leftOut = s;
        test_patches = [featuresRibs{m}{s} featuresNonRibs{m}{s}]';
        test_categories =  [ones(1,size(featuresRibs{m}{s},2)), zeros(1,size(featuresNonRibs{m}{s},2))]';

        [predicted_categories, vote] = classRF_predict(test_patches,treeM{m,s});

        probs=vote(:,2)/numTrees;
        figure(s)
        hold off
        plot(test_categories);
        hold on;
        plot(probs,'r*')
        prob=vote(:,2)/numTrees;
    %     accuracy{m,s) = 1 - (sum(sqrt((test_categories - prob).^2)))/length(predicted_categories );
        accuracy{m}{s} = 1 - (sum(sqrt((test_categories - predicted_categories).^2)))/length(predicted_categories )

    %     plot(test_categories - predicted_categories)

    end
end
% end
mean(accuracy(mriSubjects))
    
    