
function selectedPoints = selectPointsR5(p,rule,settings)

if ~exist('side','var')
    side=settings.side;
end
angle_margin=5;
% if ~exist('firstP','var')
%     firstP=1;
% end

% middlePoint=settings.middlePoint;
anglePoint=settings.anglePoint;
nPoints=settings.nPoints;
sliceThickness = settings.sliceThickness;
selectedPoints=false(settings.nPoints,1);



inds = 1:size(p,2);

max_z=max(p(3,:));
lastIndx = logical(abs(p(3,:) - max_z)<=sliceThickness);
   

x_angle = p(1,anglePoint);
angleIndx = logical(abs(p(1,:) - x_angle)<angle_margin);
    
    
if strcmp(rule,'last')
    
      
    selectedPoints(lastIndx) = true;

    
elseif strcmp(rule,'angle')
    
    selectedPoints(angleIndx) = true;
    
elseif strcmp(rule,'middle')
  
    anglePoints = inds(angleIndx); 
    lastPoints = inds(lastIndx);
    selectedPoints(anglePoints(end)+1:lastPoints(1)-1) = true;

    
elseif strcmp(rule,'postSagittal')
    
   
        
    lastPoints = inds(lastIndx);
    selectedPoints(lastPoints(end):nPoints) = true;

      
        
end