

function [cost,  paramset] = paramToCostModule( allmodels, paramset, heatMaps, firstPts...
    , settings, z_dif, x_dif)

nPoints = settings.nPoints;
ribNumber = settings.ribNumber;
patch_size = settings.patch_size;
startP=settings.startP;
settings.NRibs = ribNumber(end);    

ap = settings.ap;
is = settings.is;
lr = settings.lr;

settings.nHyps = size(paramset,1);
verbose = settings.verbose;

%%

[compParams ,ang_proj, lenProjected] = generateHypothesesFromParams(allmodels, paramset, settings);



%% Compute valid hypotheses 

valid_params = computeValidHypothesisModule(allmodels,  compParams, ang_proj...
        , lenProjected, firstPts, heatMaps,z_dif,x_dif,settings);
    

settings.nHyps = sum(valid_params);

if verbose
    fprintf(1,' \n');
    fprintf(1,'Valid hypotheses: %d \n',settings.nHyps);
end

paramset = paramset(valid_params,:);
ang_proj= ang_proj(valid_params,:);
lenProjected= lenProjected(valid_params,:);

%% Compute   Costs

if verbose
    fprintf(1,'Computing  costs...\n');
end


if verbose
    fprintf(1,' \nValid hypotheses: %d ',settings.nHyps);
end

 [ appearanceCost,  computedPoints, appearanceCostN, neighbours ] ...
 = computeCostsModule( allmodels,  compParams, ang_proj...
        , lenProjected,   firstPts, heatMaps, patch_size, settings);
%% Evaluate costs

if verbose
    fprintf(1,'Evaluating the costs of hypotheses...\n');
end

[candidate_cost]= evaluateCosts(appearanceCost,  computedPoints, appearanceCostN, neighbours ,settings);

%% Save Results

cost = candidate_cost;


