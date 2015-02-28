

function ribFittingMain(m)


runFittingSettings;

%% Path Settings

pathSettings;


%% Load image

load( [mriDataPath num2str(m)],'im');

%% Load Rib Models

load(ribModelPath,'ribModel')
load(mriAnglePath,'MRangleModel')

load(ribShapeModelPath,'ribShapeModel');
load(ribShapeCoefModelsPath ,'ribShapeCoefModels');
load(ribCageLengthModelPath ,'ribCageLengthModel');
load(ribAngleModelCTPath ,'ribAngleModelCT');
load(ribcageModelPath,'ribcageModel');

allmodels.ribShapeModel = ribShapeModel;
allmodels.ribShapeCoefModels = ribShapeCoefModels;
allmodels.ribCageLengthModel = ribCageLengthModel;
allmodels.ribAngleModelCT = ribAngleModelCT;
allmodels.ribcageModel = ribcageModel;

% ribModelTest=ribModel;
% ribModelTest.angleModel = MRangleModel;

%% Load Rib VTK File

[ptsRibs, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);

%% Find first points

[firstPts, ptsRibcage] = findFirstPoints(rib_nos,ptsRibs,settings,m);

%% if displayImage

if settings.displayImages
    
    figure;hold on;
    plot333(ptsRibcage,'b.',[ 1 3 2]);

end

%%
for i=1:length(settings.rules)

    load(heatMapPathRule{i},'heatMap');
    heatMap(heatMap == -9999) = 0;
    heatMaps{i} = heatMap;
    
end    
%% Find the probability of the manually selected ribs

if settings.doTestManualRibs
     
    z_dif = max(ptsRibcage(3,:))-min(ptsRibcage(3,:));

    trueRibsHyp.transformation= ptsRibs;
    trueRibsHyp.nHyps=1;
    fprintf(1, 'Computing the cost of manually selected ribs...');
    resultsTrue = computeValidHypothesesGroundtruth(trueRibsHyp, firstPts, z_dif,settings);

    for i=1:length(settings.rules)

        fprintf(1,'Performing Random Forest %s' , settings.rules{i} );

        resultsTrue.im_cost = heatMaps{i};
        resultsTrue = computeAppearanceCostRibCageGroundtruth(trueRibsHyp,resultsTrue, im, firstPts, treePaths{i},...
        settings,settings.rules{i});

    end      

    resultsTrue = evaluateHypotheses(resultsTrue, trueRibsHyp,  settings);
    resultsTrue = rmfield(resultsTrue,'im_cost');
    resultsTrue = rmfield(resultsTrue,'appearanceCost');
    resultsTrue = rmfield(resultsTrue,'appearanceCostN');

    display(['The cost of the manually selected ribs: ' num2str(resultsTrue.candidate_cost/4)]);
    result.resultsTrue = resultsTrue;

end

%% Find the best cases

z_dif = max(ptsRibcage(3,:))-min(ptsRibcage(3,:));
x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));

hypotheses = generateHypothesesRibcage(allmodels,settings);

fprintf(1,'Computing valid Hyposthes...\n');

[result, hypotheses] = computeValidHypotheses( hypotheses,  firstPts, z_dif, x_dif, settings);

for i=1:length(settings.rules)
    
    fprintf(1,'Performing Random Forest %s' , settings.rules{i} );

    result.im_cost = heatMaps{i};
    result = computeAppearanceCostRibCage(hypotheses, result, im, firstPts, treePaths{i},...
    settings,settings.rules{i});

end

result = evaluateHypotheses(result, hypotheses, settings);

result.paramset = hypotheses.paramset;
result.settings = settings;

save([resultsPaths num2str(hypotheses.nHyps)],'result','-v7.3');


%% Resample
% 
% HypResamplingSettings{m} = settings;
% 
% HypResamplingSettings{m}.nSamplesShape=1;
% HypResamplingSettings{m}.nSamplesLength =10;
% HypResamplingSettings{m}.nSamplesAngle = 5;%[10 10 5 1 1];%[15 15 10 10 10];
% 
% HypResamplingSettings{m}.nStd=1;
%     
%     
% 
% NbestSamples=20;
% [~, b]=sort(results{m}.candidate_cost);
% d_vector=results{m}.candidate_params(b);
% bestParams = hypotheses1.params(d_vector(1:NbestSamples),:);
% 
% importantSamples.ribShapeCompsParams = hypotheses1.parameters.ribShapeCompsParams(bestParams(:,1),:);
% importantSamples.lengthParams   = hypotheses1.parameters.lengthParams(bestParams(:,2),:);
% importantSamples.angleParams   = hypotheses1.parameters.angleParams(bestParams(:,3),:);
% 
% 
% hypothesesResampling = generateHypothesisRotateEulerListRibcageImportanceResampling(ribModelTest...
%             ,HypResamplingSettings{m},nPoints,ribNumber,[],importantSamples);
%     
%         z_dif = max(pts{m}(3,:))-min(pts{m}(3,:));
%          
%         resultsRe{m} = computeValidHypotheses5(hypothesesResampling, im{m}, firstPts{m}, ...
%         savePaths{m},  params.w_s, ribNumber,z_dif,tol,startP,nPoints);
% 
%         resultsRe{m} = computeAppearanceCostRibCageHyp5(hypothesesResampling, resultsRe{m}, im{m}, firstPoints ,firstPts{m}, treePathsAngle{m},...
%         patch_size, savePaths{m}, params.w_s, params.efficientMode,ribNumber,startP);
% 
%   
%         resultsRe{m} = computeAppearanceCostRibCageHypMiddle5(hypothesesResampling, resultsRe{m}, im{m}, firstPts{m}, treePathsLast{m},...
%         patch_size, savePaths{m}, params.w_s, params.efficientMode,ribNumber,tol,startP,nPoints);
%     
%       results{m} = evaluateHypothesisList5(resultsRe{m}, hypothesesResampling, ribNumber,   savePaths{m}, 'noNeighbour',wFirst,wMiddle,20);
% 
%  displayHyps5(hypothesesResampling,  pts{m},firstPts{m},ribNumber ,startP,101,resultsRe{m});
