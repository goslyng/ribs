


function [err, hypotheses] = optimizeShapeAngleLengthWrapper(params, models)


    [err, hypotheses] = optimizeShapeAngleLength(params(1:5),models.firstPoint, models.offset,models.heatMaps,models.hyps,models.settings,params(6:end),models.ribShapeModel ,models.rot_mat);

%     [err, hypotheses] = optimizeShapeAngleLength(params(1:5),models.firstPoint, models.offset,models.heatMaps,models.hyps,models.settings );
% 
% [err, hypotheses] = optimizeShapeAngleLength(params(1:3),params(4),params(5:6), ...
%     models.firstPoint, models.startP, models.ribShapeModel,models.rot_mat,models.offset,models.heatMaps,models.settings,models.hyps);
% 
