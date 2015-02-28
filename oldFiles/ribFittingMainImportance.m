

function ribFittingMainImportance(m)


runFittingSettings;

%% Path Settings

pathSettings;


%% Load Rib Models


load(ribShapeModelPath,'ribShapeModel');
load(ribcageModelPath,'ribcageModel');

allmodels.ribShapeModel = ribShapeModel;
allmodels.ribcageModel = ribcageModel;


%% Load Rib VTK File

[ptsRibs, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);

%% Find first points

   
% [firstPts, ptsRibcage] = findFirstPoints(ptsRibs,m,vertebraPredictionMatrixPath,rootPath,settings);
[firstPts, ptsRibcage] = findFirstPoints(settings.ribNumber,ptsRibs,settings,m);

%     
% end
%% if displayImage

if settings.displayImages
    
    figure;hold on;
    plot333(ptsRibcage,'b.',[ 1 3 2]);

end

%%

if settings.verbose
    fprintf(1,' Loading and convolving the heat maps...\n');
end

if strcmp(settings.costMethod,'log')

    maxCost=-log(0.001);

elseif strcmp(settings.costMethod,'prob');
    maxCost=0;

end 

settings.outOfRangeCost  = maxCost;
             
h = makeGaussian(settings.hw_s(1),settings.hw_s(2),settings.hw_s(3),settings.hw_sigma1);
load(im_size_path,'s_1','s_2','s_3');

for i=1:length(settings.rules)



        try
           
            load([heatMapPathRule{i} postFix(1:end-4)],'heatMap');
            heatMaps{i} = heatMap;
            
        catch
            if newHeatMaps
                heatMaps{i} = loadHeatMaps(heatMapPathRule{i},s_1(m),s_2(m),165,settings.patch_size ,-9999,postFix);
%                 heatMaps{i} = loadHeatMaps([heatMapPath settings.rules{i} '_999.txt' ],s_1(m),s_2(m),170,settings.patch_size ,-9999,1);

                heatMap =  heatMaps{i};
            else
                load(heatMapPathRule{i},'heatMap');
            end
            indxN = logical(heatMap==-9999);

            if strcmp(settings.costMethod,'log')
                heatMap = -log(heatMap);

            elseif strcmp(settings.costMethod,'prob');
                heatMap = -(heatMap);

            end 
            heatMap(indxN)=maxCost;
            heatMaps{i} = heatMap;
%             heatMaps{i} = convn(heatMap,h,'same'); 
            save([heatMapPathRule{i} postFix(1:end-4)],'heatMap');
        end
end 

if settings.verbose
    fprintf(1,'Done!\n');
end


%% Find the best cases

% z_dif = max(ptsRibcage(3,:))-min(ptsRibcage(3,:));
% x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));
% z_dif =  max([ptsRibcage(3,:) mriSubject.vertebra.pts(3,:)])-min([ptsRibcage(3,:) mriSubject.vertebra.pts(3,:)]);
% x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));
z_dif =  max([ptsRibcage(3,:) firstPts(3,settings.ribNumber)])-min([ptsRibcage(3,:) firstPts(3,settings.ribNumber)]);
x_dif = max(ptsRibcage(1,:))-min(ptsRibcage(1,:));
% Generate the parameters

paramset = generateUniformSamples(allmodels.ribcageModel,settings);

% Generate Hypothesis From Parameters
[result.candidate_cost,  validParamset , offsetVec] = paramToCostConv(allmodels,paramset,heatMaps,firstPts...
    , settings , z_dif, x_dif);

%% Convolve the heatmaps with a smaller Gaussian filter
% 
% h = makeGaussian(settings.hw_s(1),settings.hw_s(2),settings.hw_s(3),settings.hw_sigma2);
% 
% for i=1:length(settings.rules)
% 
%     load(heatMapPathRule{i},'heatMap');
%     indxN = logical(heatMap==-9999);
%     
% 	if strcmp(settings.costMethod,'log')
%         
%     	maxCost=-log(0.001);
%         heatMap = -log(heatMap);
%     
% 	elseif strcmp(settings.costMethod,'prob');
%         maxCost=0;
%         heatMap = -(heatMap);
% 
%     end 
%     settings.outOfRangeCost  = maxCost;
%     heatMap(indxN)=maxCost;
% 
%     heatMaps{i} = convn(heatMap,h,'same'); 
%  
% end 
% 
% if settings.verbose
%     fprintf(1,'Done!\n');
% end

   
%% Find the probability of the manually selected ribs

if settings.doTestManualRibs
    
    fprintf(1, 'Computing the cost of manually selected ribs...');
    
    for r = settings.ribNumber
 
        resultsTrue.candidate_cost(1,r) = offsetCost(ptsRibs{r}(:,1:settings.nPoints),[0 0 0],heatMaps,settings);

    end
    
    resultsTrue.valid_params=true;
    display(['The cost of the manually selected ribs: ' num2str(sum(resultsTrue.candidate_cost(settings.ribNumber))/length(settings.ribNumber))]);
    result.resultsTrue = resultsTrue;

end

%% Optimze the results

if settings.verbose
    
    fprintf(1,'Performing the fmean optimizations...\n');
    
end

settings.verbose=0;

models.allmodels = allmodels;
models.heatMaps = heatMaps;
models.firstPts = firstPts;
models.settings = settings;
models.z_dif = z_dif;
models.x_dif = x_dif;


[a, s ]=min(result.candidate_cost,[],2);
x = sum(a,3);
[~, b ]= sort(x);
% offsets_indx = squeeze(s(b,:,settings.ribNumber));
% 
% offset{1} = -settings.wFirstPoint(1) : settings.wFirstPoint(1);
% offset{2} = -settings.wFirstPoint(2) : settings.wFirstPoint(2);
% offset{3} = -settings.wFirstPoint(3) : settings.wFirstPoint(3);

% offsetVec = generatePermutations(offset);
% offsets = [offsetVec(offsets_indx(:,1),:) offsetVec(offsets_indx(:,2),:)  offsetVec(offsets_indx(:,3),:)  offsetVec(offsets_indx(:,4),:) ];
% params = [validParamset(b,:) offsets];
params = [validParamset(b,:) reshape(offsetVec(b,settings.ribNumber,:),[],3*length(settings.ribNumber))];


if settings.verbose
    fprintf(1,'Iteration');
end
bounds = [ones(1, settings.nCompsRibcage) repmat(settings.wFirstPoint,1,length(settings.ribNumber)) ];

for n=1:min(settings.fminIteration,size(params,1))
    
    if settings.verbose
        fprintf(1,' %d',n);
    end

	[params_(n,:), cost(n)] = fminsearchbnd(@(param) paramToCostWrapper(param,models),params(n,:),-bounds, bounds);
  
%     [params_(n,:), cost(n)] = fminsearch(@(param) paramToCostWrapper(param,models),params(n,:));
  
end

if settings.verbose
    fprintf(1,'Done!\n');
end


result.candidate_cost = cost;
result.paramset = params_;
result.settings = settings;

save([resultsPaths num2str(settings.fminIteration)],'result','-v7.3');


