

function project = pcaProject(model, p, nComps)
nX=size(p,1);
project = repmat(model.mean,nX,1) + p(:,1:nComps)*model.prinComps(:,1:nComps)';
