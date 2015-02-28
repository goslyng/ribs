


function [err, hypotheses] = optimizeShapeAngleLengthWrapperAng(params, models)


[err, hypotheses] = optimizeShapeAngleLength(models.ang0,params(1),params(2:3), ...
    models.firstPoint, models.startP, models.ribShapeModel,models.rot_mat,models.offset,models.heatMaps,models.settings);

