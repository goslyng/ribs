
function selectedPoints = selectPointsR(p,rule,settings,startP,side)

if ~exist('side','var')
    side=settings.side;
end

% if ~exist('firstP','var')
%     firstP=1;
% end

middlePoint=settings.middlePoint;
anglePoint=settings.anglePoint;
nPoints=settings.nPoints;
sliceThickness = settings.sliceThickness;
selectedPoints=false(settings.nPoints,1);

if strcmp(rule,'last')
    
    if strcmp ( side,'Right')

    max_z=max(p(3,:));
    max_z_tol  = max_z - sliceThickness;
%     selectedPoints = find(p(3,:) <= max_z & p(3,:)>=max_z_tol);
%     selectedPoints = logical(p(3,:) <= max_z & p(3,:)>=max_z_tol);
    selectedPoints(p(3,:) <= max_z & p(3,:)>=max_z_tol) = true;
    else
        min_z=min(p(3,:));
        min_z_tol  = min_z + sliceThickness;
        selectedPoints(p(3,:) >= min_z & p(3,:)<=min_z_tol) = true;
    end
    
elseif strcmp(rule,'angle')
    
%     selectedPoints=settings.startP:anglePoint;
 selectedPoints(startP:anglePoint) = true;
    
elseif strcmp(rule,'middle')
    if strcmp ( side,'Right')
        
        max_z=max(p(3,:));
        max_z_tol  = max_z - sliceThickness;
        lastPoints = find(p(3,:) <= max_z & p(3,:)>=max_z_tol);
    else
        min_z=min(p(3,:));
        min_z_tol  = min_z + sliceThickness;
        lastPoints = find(p(3,:) >= min_z & p(3,:)<=min_z_tol);
    end
    selectedPoints(middlePoint:lastPoints(1)) = true;

    
elseif strcmp(rule,'postSagittal')
    
    if strcmp ( side,'Right')
        
        max_z=max(p(3,:));
        max_z_tol  = max_z - sliceThickness;
        lastPoints = find(p(3,:) <= max_z & p(3,:)>=max_z_tol);
        
    else
        min_z=min(p(3,:));
        min_z_tol  = min_z + sliceThickness;
        lastPoints = find(p(3,:) >= min_z & p(3,:)<=min_z_tol);
    end
    
    selectedPoints(lastPoints(end):nPoints) = true;

      
        
end