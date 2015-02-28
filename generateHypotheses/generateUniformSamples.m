
function [paramset, parameter_size] = generateUniformSamples(ribcageModel,settings)

dim=0;

for k=1:settings.nCompsRibcage

    dim=dim+1;
    res(dim)  = 2*(ribcageModel.stdDev(1)/ribcageModel.stdDev(k))/(settings.nSamplesRibcage-1);
%         nSamples(dim) = round(nSamplesShape*ribModel.ribShapeCoeffsModel{c}.stdDev(k)/ribModel.ribShapeCoeffsModel{c}.stdDev(1));

end

[paramset, parameter_size] = sampleHyperBall(dim, res);