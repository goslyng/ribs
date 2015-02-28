

function [ newData_ R] = displayAngles(settings,hypotheses,ang,firstPts,ptsI,testRibs,startP,offsets,displayImages)

   %%

   if ~exist('displayImages','var')
       displayImages=false;
   end

   M1 = vrrotvec2mat([0 1 0 ang(1)/180*pi]);

% figure(102);

for r=testRibs

    P = hypotheses{r};
    P = ang(4)* P ;

%     rot_mat = findEuler(ang_rec(1,r),ang_rec(2,r),ang_rec(3,r),2);          
    rot_mat = findRotaionMatrixNew(hypotheses{r});

    M1_ = rot_mat*  M1* rot_mat';
    hyp0 = M1_ * P;   
    direc1= rot_mat * [0 1 0 ]';
    points = hyp0(:,1:floor((settings.anglePoint-1)/2)+1);

    [~, direc2] = lsqLine(points');
    M2 = vrrotvec2mat([direc2 ang(2)/180*pi]);
    direc3 = cross(direc1, direc2);

    M3 = vrrotvec2mat([direc3 ang(3)/180*pi]);
    hyp0_ = M3 * M2* hyp0;

    newData_{r} = hyp0_  + repmat(firstPts(:,r) - hyp0_(:,startP) ,1,settings.nPoints);
    newData_{r} = newData_{r} + repmat(offsets(:,r),1,size( hyp0_,2));
    if displayImages
        plot33(ptsI{r},'b.',[1 3 2])

        hold on;

    %     plot33(hypotheses{r}(:,:,1),'r.',[1 3 2])
        plot33(newData_{r}(:,:),'g.',[1 3 2])
    end
      R = M3*M2*M1_;          
end