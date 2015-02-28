
function model = pcaModeling(X)


model.mean  = mean(X);

[model.prinComps, model.proj, eigenValues] = princomp(  X,'econ');
model.stdDev = sqrt(eigenValues);


model.dim = size(X,2);