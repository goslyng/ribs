runFittingSettings;

pathSettings;

displayImages = 1;
settings.wFirstPoint = [0 0 0];


%% Load Rib Model


load(ribcageModelPath,'ribcageModel');
load(ribShapeModelPath,'ribShapeModel');
allmodels.ribcageModel=ribcageModel;
allmodels.ribShapeModel = ribShapeModel;


%% Load Rib VTK Files

% for m=mriSubjects
    [ptsI, rib_nos]=loadRibVTKFiles(dataPath,m,settings.ap,settings.is,settings.lr);
% end

%% Find first points

% for m=mriSubjects

    [firstPts, pts] = findFirstPoints(rib_nos,ptsI,settings,m);

% end

%%

paramset = generateUniformSamples(allmodels.ribcageModel,settings);
% paramset=zeros(1,settings.nCompsRibcage);
[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);


%%
    


LB = [-1.0000   -1.0000   -1.0000   -0.4000   -0.4000   -0.4000  -10 -10 0];
UB = [ 1.0000    1.0000    1.0000    0.4000    0.4000    0.4000   10  10 0];

%%
for r=7:10
    
    
    offsetVec1 = reshape(T(h,1:3),3,1);
    angles =  T(h,4:6);

    R1 = findEuler(angles);
    offsetVec2 = reshape(T_(r,h,1:3),3,1);
    angles =  squeeze(T_(r,h,4:6));

    R2 = findEuler(angles);


    ribShapeParams = [compParams{1}(h,r-6) compParams{2}(h,r-6)  ] ;
    tmp = reshape(ang_proj(h,:),4,[]);
    ang_rec = tmp(r-6,:);
    
    leng = lenProjected(h,r-6);

    Ts = [ribShapeParams leng];
    
   
    ribs=   buildSingleRibsFromParams0(ribShapeModel,Ts);

    R = findEuler(ang_rec(1),ang_rec(2),ang_rec(3),2);

    rib{r} = R2 *  R1 * R* ribs + repmat( offsetVec1 + offsetVec2 + firstPts(:,r) , 1, settings.nPoints); 

    [a, b, c]=findEuler(R2*R1*R);

    TTT= [ ribShapeParams  a b c lenProjected(h,r-6)  [offsetVec1 + offsetVec2 + firstPts(:,r)]'];
    [TT_{r}, ribRes{r}, fval(r)] =  fitnessFunction3( TTT, ribShapeModel,heatMaps , settings,LB,UB);

end
%%

TTT(3:5)
[TT_, ribRes, fval] =  fitnessFunction2( TTT, ribShapeModel,heatMaps , settings,LB,UB)
figure;hold on;
    pp=[];

    for r=7:10

        plot33(p{r},'b.',[1 3 2])
        plot33(rib{r},'g.',[1 3 2])
        plot33(ribRes,'b.',[1 3 2])

        
        pp=[pp RR*p{r}];
        plot33(ptsRibcage,'r.',[1 3 2])

        
    end
    axis equal
    

    hyps = buildRibsFromParamsRibcage(allmodels,  compParams, ang_proj...
        , lenProjected,  1:parameter_size, firstPts, settings);
    
 paramset(h,:)
    [compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels.ribcageModel, paramset, settings);
