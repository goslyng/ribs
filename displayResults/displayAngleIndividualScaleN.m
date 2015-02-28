

function [ errs1,errs2, costs,ribError1,ribError2,lenError,outOfPlaneError]  = displayAngleIndividualScaleN(m,nBest,res,displayImages_,inh)

if ~exist('inh','var')
    inh=0;
end

settings=exportSettings();
settings.inh=inh;

paths = pathSettings(settings);

scale=1;


for i=1:3
    
    resultPath{i} = [paths.rootPath 'Ribs/ang_' 'scale' num2str(scale) '_step' num2str(i) '_sigma'  num2str(10*settings.hw_sigma(i),'%02d')  '_' num2str(m)];

end

if inh
    resultPath1 = [paths.rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma1,'%02d')  '_' num2str(m) ];
    resultPath2 = [paths.rootPath 'Ribs/ang_inh_scale' num2str(scale) '_sigma'  num2str(10*settings.hw_sigma2,'%02d')  '_' num2str(m) ];
end
  

[ errs1,errs2, costs,ribError1,ribError2,lenError,outOfPlaneError]  = displayAngleIndividualScaleStep(m,nBest,resultPath{res},displayImages_,inh);

