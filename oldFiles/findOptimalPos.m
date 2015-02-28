

function [offset_opt, error_rib]= findOptimalPos(settings,testRibs,hypotheses,...
    offset_initial,firstPts,ang0,heatMaps,offset)

if ~exist('ang0','var')
    ang0=zeros(1,4);
end
if ~exist('errType','var')
    errType=1;
end
for r=testRibs
    firstPts(:,r) =firstPts(:,r) + offset_initial(:,r);
end

startP=1;
scale=1;
% nSamples = length(startPs);

% err = 9999*ones( nSamples ,testRibs(end));
deg1 = ang0(1);
deg2 = ang0(2);
deg3 = ang0(3);        

for r=testRibs
%     r
     
    % 	rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);    
    rot_mat = findRotaionMatrixNew(hypotheses{r});
    hyp_temp = hypotheses{r} - repmat(hypotheses{r}(:,1),1,size(hypotheses{r},2));
    direc1= rot_mat * [0 1 0 ]';



    M1 = vrrotvec2mat([0 1 0 deg1/180*pi]);
    M1_r =  rot_mat*M1*rot_mat';

    P = scale*hyp_temp;
    hyp0 = M1_r * P; 
    points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);
    [~, direc2] = lsqLine(points');

    M2 = vrrotvec2mat([direc2 deg2/180*pi]);
    direc3 = cross(direc1,direc2);


    M3 = vrrotvec2mat([direc3 deg3/180*pi]);
    hyp0_ = M3 * M2* hyp0;


    newData{r} = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
 
    settings.rules={'angle'};
    for o=1:size(offset,2)
        err(o,r) =  offsetCost(newData{r},offset(:,o),heatMaps,settings,startP);
    end
                   
    
end


[~, b]=min(sum(err(:,testRibs),2));

error_rib = err(b,:);
offset_opt(:,testRibs) = offset_initial(:,testRibs)+repmat(offset(:,b),1,length(testRibs));
